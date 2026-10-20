<?php

namespace App\Policies;

use App\Models\Submission;
use App\Models\User;

class SubmissionPolicy
{
    /** Siswa hanya melihat submission miliknya sendiri. */
    public function view(User $user, Submission $submission): bool
    {
        return $submission->student_id === $user->id || $user->isTeacherOf($submission->post->course);
    }

    public function grade(User $user, Submission $submission): bool
    {
        return $user->isTeacherOf($submission->post->course);
    }
}
