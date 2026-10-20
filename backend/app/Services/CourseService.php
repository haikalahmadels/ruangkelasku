<?php

namespace App\Services;

use App\Enums\CourseRole;
use App\Exceptions\DomainActionException;
use App\Models\Course;
use App\Models\User;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\DB;

class CourseService
{
    /** Pembuat menjadi pemilik dan tercatat sebagai teacher. */
    public function create(User $owner, array $data): Course
    {
        return DB::transaction(function () use ($owner, $data) {
            $course = Course::create([
                ...$data,
                'owner_id' => $owner->id,
                'code' => Course::generateUniqueCode(),
                'theme' => $data['theme'] ?? Arr::random(Course::THEMES),
            ]);

            $course->users()->attach($owner->id, ['role' => CourseRole::Teacher->value]);

            // Memuat nilai default kolom (stream_permission, dsb.) dari database.
            return $course->refresh();
        });
    }

    public function update(Course $course, array $data): Course
    {
        $course->ensureNotArchived();
        $course->update($data);

        return $course;
    }

    public function resetCode(Course $course): Course
    {
        $course->ensureNotArchived();
        $course->update(['code' => Course::generateUniqueCode()]);

        return $course;
    }

    public function archive(Course $course): Course
    {
        if (! $course->isArchived()) {
            $course->update(['archived_at' => now()]);
        }

        return $course;
    }

    public function restore(Course $course): Course
    {
        $course->update(['archived_at' => null]);

        return $course;
    }

    /** Soft delete; hanya kelas terarsip. */
    public function delete(Course $course): void
    {
        if (! $course->isArchived()) {
            throw new DomainActionException('course_not_archived', 'Arsipkan kelas terlebih dahulu sebelum menghapusnya.');
        }

        $course->delete();
    }
}
