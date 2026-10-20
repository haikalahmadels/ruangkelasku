<?php

namespace App\Services;

use App\Models\Course;
use App\Models\Topic;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class TopicService
{
    public function create(Course $course, string $name): Topic
    {
        $course->ensureNotArchived();

        return $course->topics()->create([
            'name' => $name,
            'position' => ($course->topics()->max('position') ?? -1) + 1,
        ]);
    }

    public function rename(Topic $topic, string $name): Topic
    {
        $topic->course->ensureNotArchived();
        $topic->update(['name' => $name]);

        return $topic;
    }

    /** Posting di dalamnya menjadi tanpa topik (FK nullOnDelete). */
    public function delete(Topic $topic): void
    {
        $topic->course->ensureNotArchived();
        $topic->delete();
    }

    /** @param  list<int>  $topicIds  seluruh topik kelas dalam urutan baru */
    public function reorder(Course $course, array $topicIds): void
    {
        $course->ensureNotArchived();
        $existing = $course->topics()->pluck('id')->sort()->values()->all();

        if (collect($topicIds)->sort()->values()->all() !== $existing) {
            throw ValidationException::withMessages([
                'topic_ids' => ['Daftar topik harus berisi semua topik kelas ini tepat satu kali.'],
            ]);
        }

        DB::transaction(function () use ($topicIds) {
            foreach ($topicIds as $position => $id) {
                Topic::whereKey($id)->update(['position' => $position]);
            }
        });
    }
}
