<?php

namespace App\Policies;

use App\Enums\PostStatus;
use App\Enums\PostType;
use App\Models\Course;
use App\Models\Post;
use App\Models\User;
use Illuminate\Auth\Access\Response;

class PostPolicy
{
    /** Draf dan posting terjadwal tidak ada bagi siswa. */
    public function view(User $user, Post $post): Response
    {
        $course = $post->course;

        if (! $user->isMemberOf($course)) {
            return Response::deny();
        }
        if ($post->status !== PostStatus::Published && ! $user->isTeacherOf($course)) {
            return Response::denyAsNotFound();
        }

        return Response::allow();
    }

    /** Guru membuat jenis apa pun; siswa hanya pengumuman bila stream_permission = all. */
    public function create(User $user, Course $course, ?PostType $type): bool
    {
        if ($user->isTeacherOf($course)) {
            return true;
        }

        return $type === PostType::Announcement
            && $course->stream_permission === 'all'
            && $user->isStudentOf($course);
    }

    public function update(User $user, Post $post): bool
    {
        return $user->isTeacherOf($post->course) || $post->author_id === $user->id;
    }

    public function delete(User $user, Post $post): bool
    {
        return $this->update($user, $post);
    }

    public function publish(User $user, Post $post): bool
    {
        return $user->isTeacherOf($post->course);
    }

    /** Siswa boleh berkomentar kecuali stream_permission = teacher_only. */
    public function comment(User $user, Post $post): bool
    {
        if ($post->status !== PostStatus::Published || ! $user->isMemberOf($post->course)) {
            return false;
        }

        return $user->isTeacherOf($post->course) || $post->course->stream_permission !== 'teacher_only';
    }
}
