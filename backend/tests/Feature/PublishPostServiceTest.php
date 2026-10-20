<?php

namespace Tests\Feature;

use App\Enums\CourseRole;
use App\Enums\PostStatus;
use App\Enums\PostType;
use App\Models\Course;
use App\Models\Post;
use App\Models\User;
use App\Services\PublishPostService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PublishPostServiceTest extends TestCase
{
    use RefreshDatabase;

    public function test_publishing_assignment_creates_one_submission_per_student(): void
    {
        [$course, $students] = $this->courseWithStudents(3);
        $post = $this->draft($course, PostType::Assignment);

        app(PublishPostService::class)->publish($post);

        $post->refresh();
        $this->assertSame(PostStatus::Published, $post->status);
        $this->assertNotNull($post->published_at);
        $this->assertEqualsCanonicalizing(
            $students->pluck('id')->all(),
            $post->submissions()->pluck('student_id')->all(),
        );
    }

    public function test_teachers_do_not_get_submissions(): void
    {
        [$course] = $this->courseWithStudents(1);
        $post = $this->draft($course, PostType::Quiz);

        app(PublishPostService::class)->publish($post);

        $this->assertSame(1, $post->submissions()->count());
        $this->assertFalse($post->submissions()->where('student_id', $course->owner_id)->exists());
    }

    public function test_announcement_and_material_create_no_submissions(): void
    {
        [$course] = $this->courseWithStudents(2);
        $announcement = $this->draft($course, PostType::Announcement);
        $material = $this->draft($course, PostType::Material);

        app(PublishPostService::class)->publish($announcement);
        app(PublishPostService::class)->publish($material);

        $this->assertSame(0, $announcement->submissions()->count() + $material->submissions()->count());
    }

    public function test_publishing_twice_is_harmless(): void
    {
        [$course] = $this->courseWithStudents(2);
        $post = $this->draft($course, PostType::Assignment);
        $service = app(PublishPostService::class);

        $service->publish($post);
        $service->publish($post->fresh());

        $this->assertSame(2, $post->submissions()->count());
    }

    private function courseWithStudents(int $count): array
    {
        $teacher = User::factory()->create();
        $course = Course::create([
            'owner_id' => $teacher->id,
            'name' => 'Kelas Uji',
            'code' => Course::generateUniqueCode(),
            'theme' => 'forest',
        ]);
        $course->users()->attach($teacher->id, ['role' => CourseRole::Teacher->value]);

        $students = User::factory()->count($count)->create();
        foreach ($students as $student) {
            $course->users()->attach($student->id, ['role' => CourseRole::Student->value]);
        }

        return [$course, $students];
    }

    private function draft(Course $course, PostType $type): Post
    {
        $post = Post::create([
            'course_id' => $course->id,
            'author_id' => $course->owner_id,
            'type' => $type,
            'title' => $type === PostType::Announcement ? null : 'Judul',
            'status' => PostStatus::Draft,
            'position' => 0,
        ]);

        if ($type === PostType::Quiz) {
            $post->quizQuestions()->create(['prompt' => 'Soal', 'points' => 1, 'position' => 0]);
        }

        return $post;
    }
}
