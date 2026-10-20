<?php

namespace App\Notifications;

use Illuminate\Notifications\Notification;
use Illuminate\Support\Str;

/**
 * Notifikasi in-app di tabel notifications. Kolom `type` berisi kode dari docs/api.md
 * (post_published, ...) dan `data` berisi title, message, course_id, post_id.
 */
abstract class AppNotification extends Notification
{
    abstract public function databaseType(object $notifiable): string;

    /** @return array{title: string, message: string, course_id: ?int, post_id: ?int} */
    abstract public function toArray(object $notifiable): array;

    /** @return list<string> */
    public function via(object $notifiable): array
    {
        return ['database'];
    }

    protected static function excerpt(?string $text, int $limit = 80): string
    {
        return Str::limit(Str::squish((string) $text), $limit);
    }

    /** 85.00 → "85", 87.50 → "87.5" */
    protected static function number(string|float|int $value): string
    {
        return rtrim(rtrim(number_format((float) $value, 2, '.', ''), '0'), '.');
    }
}
