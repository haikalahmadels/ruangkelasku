<?php

namespace App\Notifications;

use App\Models\Submission;

class SubmissionReturned extends AppNotification
{
    public function __construct(private Submission $submission) {}

    public function databaseType(object $notifiable): string
    {
        return 'submission_returned';
    }

    public function toArray(object $notifiable): array
    {
        $post = $this->submission->post;
        $message = $post->title;

        if ($this->submission->grade !== null && $post->points !== null) {
            $message .= ': nilai '.self::number($this->submission->grade).'/'.$post->points;
        }

        return [
            'title' => 'Tugas dikembalikan',
            'message' => $message,
            'course_id' => $post->course_id,
            'post_id' => $post->id,
        ];
    }
}
