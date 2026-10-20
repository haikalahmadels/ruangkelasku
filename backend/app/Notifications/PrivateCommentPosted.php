<?php

namespace App\Notifications;

use App\Models\PrivateComment;

class PrivateCommentPosted extends AppNotification
{
    public function __construct(private PrivateComment $comment) {}

    public function databaseType(object $notifiable): string
    {
        return 'private_comment';
    }

    public function toArray(object $notifiable): array
    {
        $post = $this->comment->submission->post;

        return [
            'title' => 'Komentar pribadi baru',
            'message' => $this->comment->user->name.': '.self::excerpt($this->comment->body),
            'course_id' => $post->course_id,
            'post_id' => $post->id,
        ];
    }
}
