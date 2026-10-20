<?php

namespace Tests\Concerns;

use App\Enums\CourseRole;
use App\Enums\PostStatus;
use App\Enums\PostType;
use App\Models\Course;
use App\Models\Post;
use App\Models\QuizQuestion;
use App\Models\User;
use App\Services\PublishPostService;

trait BuildsCourses
{
    protected function addStudent(Course $course, ?User $student = null): User
    {
        $student ??= User::factory()->create();
        $course->users()->attach($student->id, ['role' => CourseRole::Student->value]);

        return $student;
    }

    protected function addTeacher(Course $course, ?User $teacher = null): User
    {
        $teacher ??= User::factory()->create();
        $course->users()->attach($teacher->id, ['role' => CourseRole::Teacher->value]);

        return $teacher;
    }

    protected function makePost(Course $course, PostType $type = PostType::Assignment, bool $publish = true): Post
    {
        $post = Post::create([
            'course_id' => $course->id,
            'author_id' => $course->owner_id,
            'type' => $type,
            'title' => $type === PostType::Announcement ? null : 'Judul',
            'points' => $type === PostType::Assignment ? 100 : null,
            'status' => PostStatus::Draft,
            'position' => 0,
        ]);

        if ($type === PostType::Quiz) {
            $this->addQuizQuestion($post);
        }

        if ($publish) {
            app(PublishPostService::class)->publish($post);
        }

        return $post->fresh();
    }

    /** Soal pilihan ganda; opsi indeks $correct yang benar. */
    protected function addQuizQuestion(Post $post, int $points = 10, int $correct = 0, int $options = 3): QuizQuestion
    {
        $question = $post->quizQuestions()->create([
            'prompt' => 'Soal '.($post->quizQuestions()->count() + 1),
            'points' => $points,
            'position' => $post->quizQuestions()->count(),
        ]);
        foreach (range(0, $options - 1) as $index) {
            $question->options()->create([
                'label' => 'Opsi '.chr(65 + $index),
                'is_correct' => $index === $correct,
                'position' => $index,
            ]);
        }
        $post->update(['points' => $post->quizQuestions()->sum('points')]);

        return $question;
    }
}
