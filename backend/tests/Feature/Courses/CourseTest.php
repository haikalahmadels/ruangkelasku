<?php

namespace Tests\Feature\Courses;

use App\Models\Course;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Concerns\BuildsCourses;
use Tests\TestCase;

class CourseTest extends TestCase
{
    use BuildsCourses, RefreshDatabase;

    public function test_creator_becomes_owner_and_teacher_with_generated_code(): void
    {
        $user = Sanctum::actingAs(User::factory()->create());

        $response = $this->postJson('/api/v1/courses', ['name' => 'Matematika Wajib', 'section' => 'XI IPA 2'])
            ->assertCreated()
            ->assertJsonPath('data.my_role', 'teacher')
            ->assertJsonPath('data.is_owner', true)
            ->assertJsonPath('data.student_count', 0)
            ->assertJsonPath('data.owner.id', $user->id)
            ->assertJsonPath('data.code_enabled', true)
            ->assertJsonPath('data.stream_permission', 'all')
            ->assertJsonPath('data.classwork_on_stream', 'compact')
            ->assertJsonPath('data.is_archived', false);

        $this->assertMatchesRegularExpression('/^[a-z0-9]{7}$/', $response->json('data.code'));
        $this->assertContains($response->json('data.theme'), Course::THEMES);
        $this->assertTrue($user->isTeacherOf(Course::findOrFail($response->json('data.id'))));
    }

    public function test_index_lists_only_my_courses_split_by_archive(): void
    {
        $user = User::factory()->create();
        $active = Course::factory()->for($user, 'owner')->create();
        $archived = Course::factory()->for($user, 'owner')->archived()->create();
        $joined = Course::factory()->create();
        $this->addStudent($joined, $user);
        Course::factory()->create();
        Sanctum::actingAs($user);

        $this->getJson('/api/v1/courses')
            ->assertOk()
            ->assertJsonCount(2, 'data')
            ->assertJsonStructure(['data', 'links', 'meta' => ['current_page', 'last_page', 'per_page', 'total']]);

        $ids = collect($this->getJson('/api/v1/courses')->json('data'))->keyBy('id');
        $this->assertSame('teacher', $ids[$active->id]['my_role']);
        $this->assertSame('student', $ids[$joined->id]['my_role']);
        $this->assertArrayNotHasKey('code', $ids[$joined->id]);

        $this->getJson('/api/v1/courses?archived=1')
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $archived->id);
    }

    public function test_students_do_not_see_the_class_code(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs($this->addStudent($course));

        $this->getJson("/api/v1/courses/{$course->id}")
            ->assertOk()
            ->assertJsonMissingPath('data.code')
            ->assertJsonPath('data.my_role', 'student');
    }

    public function test_non_member_cannot_view_course(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs(User::factory()->create());

        $this->getJson("/api/v1/courses/{$course->id}")->assertForbidden();
    }

    public function test_teacher_updates_settings_and_student_cannot(): void
    {
        $course = Course::factory()->create();
        $coTeacher = $this->addTeacher($course);
        $student = $this->addStudent($course);

        Sanctum::actingAs($coTeacher);
        $this->patchJson("/api/v1/courses/{$course->id}", [
            'name' => 'Nama Baru',
            'stream_permission' => 'teacher_only',
            'code_enabled' => false,
        ])->assertOk()
            ->assertJsonPath('data.name', 'Nama Baru')
            ->assertJsonPath('data.stream_permission', 'teacher_only')
            ->assertJsonPath('data.code_enabled', false);

        Sanctum::actingAs($student);
        $this->patchJson("/api/v1/courses/{$course->id}", ['name' => 'X'])->assertForbidden();
    }

    public function test_invalid_theme_is_rejected(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs($course->owner);

        $this->patchJson("/api/v1/courses/{$course->id}", ['theme' => 'neon'])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('theme');
    }

    public function test_reset_code_changes_code(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs($course->owner);

        $newCode = $this->postJson("/api/v1/courses/{$course->id}/code/reset")->assertOk()->json('data.code');

        $this->assertNotSame($course->code, $newCode);
    }

    public function test_only_owner_archives_restores_and_deletes(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs($this->addTeacher($course));

        $this->postJson("/api/v1/courses/{$course->id}/archive")->assertForbidden();
        $this->deleteJson("/api/v1/courses/{$course->id}")->assertForbidden();

        Sanctum::actingAs($course->owner);
        $this->postJson("/api/v1/courses/{$course->id}/archive")->assertOk()->assertJsonPath('data.is_archived', true);
        $this->postJson("/api/v1/courses/{$course->id}/restore")->assertOk()->assertJsonPath('data.is_archived', false);
    }

    public function test_archived_course_is_read_only(): void
    {
        $course = Course::factory()->archived()->create();
        Sanctum::actingAs($course->owner);

        $this->patchJson("/api/v1/courses/{$course->id}", ['name' => 'X'])
            ->assertStatus(409)
            ->assertJson(['code' => 'course_archived']);
        $this->postJson("/api/v1/courses/{$course->id}/code/reset")
            ->assertStatus(409)
            ->assertJson(['code' => 'course_archived']);
        $this->getJson("/api/v1/courses/{$course->id}")->assertOk();
    }

    public function test_delete_requires_archived_course_and_soft_deletes(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs($course->owner);

        $this->deleteJson("/api/v1/courses/{$course->id}")
            ->assertStatus(409)
            ->assertJson(['code' => 'course_not_archived']);

        $course->update(['archived_at' => now()]);
        $this->deleteJson("/api/v1/courses/{$course->id}")->assertNoContent();

        $this->assertSoftDeleted($course);
        $this->getJson("/api/v1/courses/{$course->id}")->assertNotFound();
    }
}
