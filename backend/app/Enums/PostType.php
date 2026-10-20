<?php

namespace App\Enums;

enum PostType: string
{
    case Announcement = 'announcement';
    case Material = 'material';
    case Assignment = 'assignment';
    case Quiz = 'quiz';
    case Question = 'question';

    /** Jenis yang membuat baris submissions untuk setiap siswa saat terbit. */
    public function requiresSubmissions(): bool
    {
        return in_array($this, [self::Assignment, self::Quiz, self::Question], true);
    }
}
