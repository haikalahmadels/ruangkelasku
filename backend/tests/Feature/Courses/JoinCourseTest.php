<?php

namespace Tests\Feature\Courses;

use App\Enums\PostType;
use App\Models\Course;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Concerns\BuildsCourses;
use Tests\TestCase;

class JoinCourseTest extends TestCase
{
    use BuildsCourses, RefreshDatabase;

    public function test_join_by_code_creates_submissions_for_published_work_only(): void
    {
        $course = Course::factory()->create();
        $assignment = $this->makePost($course, PostType::Assignment);
        $quiz = $this->makePost($course, PostType::Quiz);
        $this->makePost($course, PostType::Material);
        $this->makePost($course, PostType::Assignment, publish: false);
        $student = Sanctum::actingAs(User::factory()->create());

        $this->postJson('/api/v1/courses/join', ['code' => strtoupper(" {$course->code} ")])
            ->assertOk()
            ->assertJsonPath('data.id', $course->id)
            ->assertJsonPath('data.my_role', 'student');

        $this->assertTrue($student->isStudentOf($course));
        $this->assertEqualsCanonicalizing(
            [$assignment->id, $quiz->id],
            $student->submissions()->pluck('post_id')->all(),
        );
    }

    public function test_unknown_code_returns_404(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $this->postJson('/api/v1/courses/join', ['code' => 'zzzzzzz'])->assertNotFound();
    }

    public function test_disabled_code_is_rejected(): void
    {
        $course = Course::factory()->create(['code_enabled' => false]);
        Sanctum::actingAs(User::factory()->create());

        $this->postJson('/api/v1/courses/join', ['code' => $course->code])
            ->assertStatus(409)
            ->assertJson(['code' => 'join_code_disabled']);
    }

    public function test_archived_course_cannot_be_joined(): void
    {
        $course = Course::factory()->archived()->create();
        Sanctum::actingAs(User::factory()->create());

        $this->postJson('/api/v1/courses/join', ['code' => $course->code])
            ->assertStatus(409)
            ->assertJson(['code' => 'course_archived']);
    }

    public function test_existing_member_gets_already_member(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs($this->addStudent($course));

        $this->postJson('/api/v1/courses/join', ['code' => $course->code])
            ->assertStatus(409)
            ->assertJson(['code' => 'already_member']);
    }
}
