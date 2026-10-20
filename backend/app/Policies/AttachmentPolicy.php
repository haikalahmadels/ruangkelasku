<?php

namespace App\Policies;

use App\Models\Attachment;
use App\Models\Post;
use App\Models\User;

class AttachmentPolicy
{
    /**
     * Lampiran posting: pengunggah atau guru. Lampiran submission hanya lewat
     * /posts/{post}/my-submission/attachments agar aturan penyerahan tetap berlaku.
     */
    public function delete(User $user, Attachment $attachment): bool
    {
        $attachable = $attachment->attachable;

        if (! $attachable instanceof Post) {
            return false;
        }

        return $attachment->uploaded_by === $user->id || $user->isTeacherOf($attachable->course);
    }
}
