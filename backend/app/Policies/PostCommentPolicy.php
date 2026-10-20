<?php

namespace App\Policies;

use App\Models\PostComment;
use App\Models\User;

class PostCommentPolicy
{
    public function delete(User $user, PostComment $comment): bool
    {
        return $comment->user_id === $user->id || $user->isTeacherOf($comment->post->course);
    }
}
