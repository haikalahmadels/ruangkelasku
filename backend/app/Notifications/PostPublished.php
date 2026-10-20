<?php

namespace App\Notifications;

use App\Enums\PostType;
use App\Models\Post;

class PostPublished extends AppNotification
{
    public function __construct(private Post $post) {}

    public function databaseType(object $notifiable): string
    {
        return 'post_published';
    }

    public function toArray(object $notifiable): array
    {
        $title = match ($this->post->type) {
            PostType::Announcement => 'Pengumuman baru',
            PostType::Material => 'Materi baru',
            PostType::Assignment => 'Tugas baru',
            PostType::Quiz => 'Kuis baru',
            PostType::Question => 'Pertanyaan baru',
        };

        return [
            'title' => $title,
            'message' => $this->post->course->name.': '.self::excerpt($this->post->title ?? $this->post->body),
            'course_id' => $this->post->course_id,
            'post_id' => $this->post->id,
        ];
    }
}
