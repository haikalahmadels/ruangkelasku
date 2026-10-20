<?php

namespace Tests\Feature\Courses;

use App\Models\Attachment;
use App\Models\Course;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Concerns\BuildsCourses;
use Tests\TestCase;

class MemberTest extends TestCase
{
    use BuildsCourses, RefreshDatabase;

    public function test_members_are_split_and_owner_listed_first(): void
    {
        $course = Course::factory()->create();
        $coTeacher = $this->addTeacher($course, User::factory()->create(['name' => 'Aaa Guru']));
        $student = $this->addStudent($course);
        Sanctum::actingAs($course->owner);

        $this->getJson("/api/v1/courses/{$course->id}/members")
            ->assertOk()
            ->assertJsonPath('data.teachers.0.id', $course->owner_id)
            ->assertJsonPath('data.teachers.0.is_owner', true)
            ->assertJsonPath('data.teachers.1.id', $coTeacher->id)
            ->assertJsonPath('data.students.0.id', $student->id)
            ->assertJsonPath('data.students.0.email', $student->email);
    }

    public function test_students_do_not_see_member_emails(): void
    {
        $course = Course::factory()->create();
        $student = $this->addStudent($course);
        Sanctum::actingAs($student);

        $this->getJson("/api/v1/courses/{$course->id}/members")
            ->assertOk()
            ->assertJsonMissingPath('data.students.0.email');
    }

    public function test_teacher_removes_student_and_their_submissions(): void
    {
        $course = Course::factory()->create();
        $student = $this->addStudent($course);
        $post = $this->makePost($course);
        $submission = $post->submissions()->firstOrFail();
        $submission->attachments()->create(['uploaded_by' => $student->id, 'kind' => 'link', 'url' => 'https://x.test']);
        Sanctum::actingAs($this->addTeacher($course));

        $this->deleteJson("/api/v1/courses/{$course->id}/members/{$student->id}")->assertNoContent();

        $this->assertFalse($student->isMemberOf($course));
        $this->assertModelMissing($submission);
        $this->assertSame(0, Attachment::count());
    }

    public function test_student_cannot_remove_members(): void
    {
        $course = Course::factory()->create();
        $other = $this->addStudent($course);
        Sanctum::actingAs($this->addStudent($course));

        $this->deleteJson("/api/v1/courses/{$course->id}/members/{$other->id}")->assertForbidden();
    }

    public function test_only_owner_removes_teachers_and_owner_cannot_be_removed(): void
    {
        $course = Course::factory()->create();
        $coTeacher = $this->addTeacher($course);
        $otherTeacher = $this->addTeacher($course);

        Sanctum::actingAs($coTeacher);
        $this->deleteJson("/api/v1/courses/{$course->id}/members/{$otherTeacher->id}")->assertForbidden();
        $this->deleteJson("/api/v1/courses/{$course->id}/members/{$course->owner_id}")->assertForbidden();

        Sanctum::actingAs($course->owner);
        $this->deleteJson("/api/v1/courses/{$course->id}/members/{$otherTeacher->id}")->assertNoContent();
        $this->deleteJson("/api/v1/courses/{$course->id}/members/{$course->owner_id}")->assertForbidden();
    }

    public function test_removing_non_member_returns_404(): void
    {
        $course = Course::factory()->create();
        $stranger = User::factory()->create();
        Sanctum::actingAs($course->owner);

        $this->deleteJson("/api/v1/courses/{$course->id}/members/{$stranger->id}")->assertNotFound();
    }

    public function test_member_leaves_but_owner_cannot(): void
    {
        $course = Course::factory()->create();
        $student = $this->addStudent($course);

        Sanctum::actingAs($student);
        $this->deleteJson("/api/v1/courses/{$course->id}/membership")->assertNoContent();
        $this->assertFalse($student->isMemberOf($course));

        Sanctum::actingAs($course->owner);
        $this->deleteJson("/api/v1/courses/{$course->id}/membership")->assertForbidden();
    }
}
