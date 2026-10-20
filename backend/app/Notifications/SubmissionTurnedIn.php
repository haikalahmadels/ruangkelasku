<?php

namespace App\Notifications;

use App\Models\Submission;

class SubmissionTurnedIn extends AppNotification
{
    public function __construct(private Submission $submission) {}

    public function databaseType(object $notifiable): string
    {
        return 'submission_turned_in';
    }

    public function toArray(object $notifiable): array
    {
        $post = $this->submission->post;

        return [
            'title' => 'Tugas diserahkan',
            'message' => $this->submission->student->name.' menyerahkan '.$post->title,
            'course_id' => $post->course_id,
            'post_id' => $post->id,
        ];
    }
}
