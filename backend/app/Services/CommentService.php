<?php

namespace App\Services;

use App\Models\Post;
use App\Models\PostComment;
use App\Models\User;

class CommentService
{
    public function create(Post $post, User $author, string $body): PostComment
    {
        $post->course->ensureNotArchived();

        return $post->comments()->create([
            'user_id' => $author->id,
            'body' => $body,
        ]);
    }

    public function delete(PostComment $comment): void
    {
        $comment->post->course->ensureNotArchived();
        $comment->delete();
    }
}
