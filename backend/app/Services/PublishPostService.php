<?php

namespace App\Services;

use App\Enums\PostStatus;
use App\Enums\PostType;
use App\Enums\SubmissionStatus;
use App\Models\Post;
use App\Notifications\PostPublished;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Notification;
use Illuminate\Validation\ValidationException;

/** Satu jalur penerbitan untuk tombol "Terbitkan" dan scheduler posting terjadwal. */
class PublishPostService
{
    public function publish(Post $post): Post
    {
        if ($post->status === PostStatus::Published) {
            return $post;
        }

        if ($post->type === PostType::Quiz && ! $post->quizQuestions()->exists()) {
            throw ValidationException::withMessages([
                'status' => ['Tambahkan minimal satu soal sebelum menerbitkan kuis.'],
            ]);
        }
        if ($post->type === PostType::Question && ! $post->quizQuestions()->exists()) {
            throw ValidationException::withMessages([
                'status' => ['Simpan bentuk pertanyaan sebelum menerbitkan.'],
            ]);
        }

        DB::transaction(function () use ($post) {
            $post->update([
                'status' => PostStatus::Published,
                'published_at' => now(),
            ]);

            if ($post->type->requiresSubmissions()) {
                $this->createSubmissions($post);
            }
        });

        $recipients = $post->course->users()->whereKeyNot($post->author_id)->get();
        Notification::send($recipients, new PostPublished($post));

        return $post;
    }

    /** Satu baris submissions per siswa; aman dipanggil ulang. */
    private function createSubmissions(Post $post): void
    {
        $now = now();

        $rows = $post->course->students()->pluck('users.id')
            ->map(fn (int $studentId) => [
                'post_id' => $post->id,
                'student_id' => $studentId,
                'status' => SubmissionStatus::Assigned->value,
                'created_at' => $now,
                'updated_at' => $now,
            ])
            ->all();

        DB::table('submissions')->insertOrIgnore($rows);
    }
}
