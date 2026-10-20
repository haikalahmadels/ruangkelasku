<?php

namespace App\Services;

use App\Enums\CourseRole;
use App\Enums\PostStatus;
use App\Enums\PostType;
use App\Enums\SubmissionStatus;
use App\Exceptions\DomainActionException;
use App\Models\Attachment;
use App\Models\Course;
use App\Models\Invitation;
use App\Models\Submission;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

/** Masuk dan keluarnya anggota kelas, termasuk baris submissions milik siswa. */
class JoinCourseService
{
    public function joinByCode(User $user, string $code): Course
    {
        $course = Course::where('code', strtolower(trim($code)))->first();

        if ($course === null) {
            abort(404, 'Kode kelas tidak ditemukan.');
        }
        if (! $course->code_enabled) {
            throw new DomainActionException('join_code_disabled', 'Kode kelas ini sedang dinonaktifkan.');
        }
        $course->ensureNotArchived();

        $this->addMember($course, $user, CourseRole::Student);

        return $course;
    }

    public function addMember(Course $course, User $user, CourseRole $role): void
    {
        if ($user->isMemberOf($course)) {
            throw new DomainActionException('already_member', 'Anda sudah menjadi anggota kelas ini.');
        }

        DB::transaction(function () use ($course, $user, $role) {
            $course->users()->attach($user->id, ['role' => $role->value]);

            if ($role === CourseRole::Student) {
                $this->createSubmissionsForPublishedWork($course, $user);
            }

            // Undangan yang masih tertunda tidak perlu tampil lagi di beranda.
            Invitation::where('course_id', $course->id)
                ->where('email', $user->email)
                ->where('status', 'pending')
                ->update(['status' => 'accepted']);
        });
    }

    /** Siswa yang dikeluarkan kehilangan seluruh submission dan lampirannya di kelas ini. */
    public function removeMember(Course $course, User $user): void
    {
        DB::transaction(function () use ($course, $user) {
            $submissionIds = Submission::where('student_id', $user->id)
                ->whereIn('post_id', $course->posts()->withTrashed()->select('id'))
                ->pluck('id');

            $attachments = Attachment::where('attachable_type', 'submission')
                ->whereIn('attachable_id', $submissionIds)
                ->get();
            $filePaths = $attachments->pluck('file_path')->filter()->all();

            Attachment::whereIn('id', $attachments->pluck('id'))->delete();
            Submission::whereIn('id', $submissionIds)->delete();
            $course->users()->detach($user->id);

            DB::afterCommit(fn () => Storage::disk('public')->delete($filePaths));
        });
    }

    private function createSubmissionsForPublishedWork(Course $course, User $student): void
    {
        $now = now();
        $types = array_map(
            fn (PostType $type) => $type->value,
            array_filter(PostType::cases(), fn (PostType $type) => $type->requiresSubmissions()),
        );

        $rows = $course->posts()
            ->where('status', PostStatus::Published)
            ->whereIn('type', $types)
            ->pluck('id')
            ->map(fn (int $postId) => [
                'post_id' => $postId,
                'student_id' => $student->id,
                'status' => SubmissionStatus::Assigned->value,
                'created_at' => $now,
                'updated_at' => $now,
            ])
            ->all();

        DB::table('submissions')->insertOrIgnore($rows);
    }
}
