<?php

namespace App\Policies;

use App\Models\Course;
use App\Models\User;

class CoursePolicy
{
    public function view(User $user, Course $course): bool
    {
        return $user->isMemberOf($course);
    }

    /** Setelan kelas, reset kode, dan mengundang siswa. */
    public function update(User $user, Course $course): bool
    {
        return $user->isTeacherOf($course);
    }

    /** Topik, materi, tugas, kuis, dan penilaian. */
    public function manageClasswork(User $user, Course $course): bool
    {
        return $user->isTeacherOf($course);
    }

    public function inviteTeacher(User $user, Course $course): bool
    {
        return $user->owns($course);
    }

    public function archive(User $user, Course $course): bool
    {
        return $user->owns($course);
    }

    public function delete(User $user, Course $course): bool
    {
        return $user->owns($course);
    }

    /** Guru mengeluarkan siswa; hanya pemilik yang mengeluarkan guru; pemilik tidak bisa dikeluarkan. */
    public function removeMember(User $user, Course $course, User $target): bool
    {
        if ($target->owns($course)) {
            return false;
        }

        return $target->isTeacherOf($course)
            ? $user->owns($course)
            : $user->isTeacherOf($course);
    }

    public function leave(User $user, Course $course): bool
    {
        return $user->isMemberOf($course) && ! $user->owns($course);
    }
}
