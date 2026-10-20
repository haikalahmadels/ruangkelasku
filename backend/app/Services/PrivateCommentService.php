<?php

namespace App\Services;

use App\Models\PrivateComment;
use App\Models\Submission;
use App\Models\User;
use App\Notifications\PrivateCommentPosted;
use Illuminate\Support\Facades\Notification;

/** Komentar pribadi antara guru kelas dan satu siswa. */
class PrivateCommentService
{
    public function create(Submission $submission, User $author, string $body): PrivateComment
    {
        $course = $submission->post->course;
        $course->ensureNotArchived();

        $comment = $submission->privateComments()->create([
            'user_id' => $author->id,
            'body' => $body,
        ]);
        $comment->setRelation('user', $author)->setRelation('submission', $submission);

        // Pihak lain: siswa memberi tahu semua guru kelas, guru memberi tahu siswa.
        $recipients = $author->id === $submission->student_id
            ? $course->teachers()->get()
            : collect([$submission->student]);
        Notification::send($recipients, new PrivateCommentPosted($comment));

        return $comment;
    }
}
