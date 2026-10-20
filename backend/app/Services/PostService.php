<?php

namespace App\Services;

use App\Enums\PostStatus;
use App\Enums\PostType;
use App\Models\Course;
use App\Models\Post;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Arr;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class PostService
{
    public function __construct(
        private PublishPostService $publisher,
        private AttachmentService $attachments,
    ) {}

    /**
     * @param  list<UploadedFile>  $files
     * @param  list<string>  $links
     */
    public function create(Course $course, User $author, array $data, array $files = [], array $links = []): Post
    {
        $course->ensureNotArchived();
        $type = PostType::from($data['type']);
        $status = PostStatus::from($data['status']);
        $data = $this->normalize($type, $data);

        return DB::transaction(function () use ($course, $author, $type, $status, $data, $files, $links) {
            $post = $course->posts()->create([
                ...Arr::only($data, ['title', 'body', 'topic_id', 'points', 'due_at']),
                'author_id' => $author->id,
                'type' => $type,
                'status' => $status === PostStatus::Scheduled ? PostStatus::Scheduled : PostStatus::Draft,
                'scheduled_at' => $status === PostStatus::Scheduled ? $data['scheduled_at'] : null,
                'position' => $this->nextPosition($course, $data['topic_id'] ?? null),
            ]);

            foreach ($files as $file) {
                $this->attachments->addFile($post, $author, $file);
            }
            foreach ($links as $url) {
                $this->attachments->addLink($post, $author, $url);
            }

            if ($status === PostStatus::Published) {
                $this->publisher->publish($post);
            }

            return $post;
        });
    }

    public function update(Post $post, array $data): Post
    {
        $post->course->ensureNotArchived();
        $data = $this->normalize($post->type, $data);
        $newStatus = isset($data['status']) ? PostStatus::from($data['status']) : null;

        if ($post->status === PostStatus::Published && $newStatus !== null && $newStatus !== PostStatus::Published) {
            throw ValidationException::withMessages([
                'status' => ['Posting yang sudah terbit tidak bisa dijadikan draf atau dijadwalkan.'],
            ]);
        }

        return DB::transaction(function () use ($post, $data, $newStatus) {
            $attributes = Arr::only($data, ['title', 'body', 'topic_id', 'points', 'due_at']);

            if (array_key_exists('topic_id', $attributes) && $attributes['topic_id'] !== $post->topic_id) {
                $attributes['position'] = $this->nextPosition($post->course, $attributes['topic_id']);
            }
            if ($newStatus === PostStatus::Scheduled) {
                $attributes += ['status' => PostStatus::Scheduled, 'scheduled_at' => $data['scheduled_at']];
            }
            if ($newStatus === PostStatus::Draft) {
                $attributes += ['status' => PostStatus::Draft, 'scheduled_at' => null];
            }

            $post->update($attributes);

            if ($newStatus === PostStatus::Published) {
                $this->publisher->publish($post);
            }

            return $post;
        });
    }

    /** Pindah topik atau urutan di Tugas Kelas; urutan di topik asal dan tujuan dinomori ulang. */
    public function move(Post $post, ?int $topicId, int $position): void
    {
        $post->course->ensureNotArchived();

        DB::transaction(function () use ($post, $topicId, $position) {
            $oldTopicId = $post->topic_id;

            $siblings = $this->classworkIn($post->course, $topicId)
                ->whereKeyNot($post->id)
                ->orderBy('position')
                ->get();
            $siblings->splice(min(max($position, 0), $siblings->count()), 0, [$post]);

            foreach ($siblings->values() as $index => $sibling) {
                $sibling->update(['topic_id' => $topicId, 'position' => $index]);
            }

            if ($oldTopicId !== $topicId) {
                $this->renumber($post->course, $oldTopicId);
            }
        });
    }

    public function delete(Post $post): void
    {
        $post->course->ensureNotArchived();
        $post->delete();
    }

    /** Waktu dari klien bisa ber-offset (+07:00); simpan sebagai UTC. */
    private function normalize(PostType $type, array $data): array
    {
        foreach (['due_at', 'scheduled_at'] as $key) {
            if (! empty($data[$key])) {
                $data[$key] = Carbon::parse($data[$key])->utc();
            }
        }

        // Nilai multipart selalu string.
        if (isset($data['topic_id'])) {
            $data['topic_id'] = (int) $data['topic_id'];
        }

        // Pengumuman tidak bertopik; poin kuis dihitung dari soal.
        if ($type === PostType::Announcement) {
            $data['topic_id'] = null;
        }
        if ($type === PostType::Quiz) {
            unset($data['points']);
        }

        return $data;
    }

    private function nextPosition(Course $course, ?int $topicId): int
    {
        $max = $this->classworkIn($course, $topicId)->max('position');

        return $max === null ? 0 : $max + 1;
    }

    private function renumber(Course $course, ?int $topicId): void
    {
        $this->classworkIn($course, $topicId)->orderBy('position')->get()
            ->each(fn (Post $post, int $index) => $post->update(['position' => $index]));
    }

    private function classworkIn(Course $course, ?int $topicId)
    {
        return $course->posts()
            ->where('type', '!=', PostType::Announcement)
            ->when(
                $topicId === null,
                fn ($query) => $query->whereNull('topic_id'),
                fn ($query) => $query->where('topic_id', $topicId),
            );
    }
}
