<?php

namespace Tests\Feature\Courses;

use App\Models\Course;
use App\Models\Invitation;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Concerns\BuildsCourses;
use Tests\TestCase;

class InvitationTest extends TestCase
{
    use BuildsCourses, RefreshDatabase;

    public function test_teacher_invites_student_by_email(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs($this->addTeacher($course));

        $this->postJson("/api/v1/courses/{$course->id}/invitations", ['email' => 'Baru@Example.com', 'role' => 'student'])
            ->assertCreated()
            ->assertJsonPath('data.email', 'baru@example.com')
            ->assertJsonPath('data.status', 'pending');

        $this->getJson("/api/v1/courses/{$course->id}/invitations")->assertJsonCount(1, 'data');
    }

    public function test_only_owner_invites_co_teachers(): void
    {
        $course = Course::factory()->create();

        Sanctum::actingAs($this->addTeacher($course));
        $this->postJson("/api/v1/courses/{$course->id}/invitations", ['email' => 'guru@example.com', 'role' => 'teacher'])
            ->assertForbidden();

        Sanctum::actingAs($course->owner);
        $this->postJson("/api/v1/courses/{$course->id}/invitations", ['email' => 'guru@example.com', 'role' => 'teacher'])
            ->assertCreated();
    }

    public function test_student_cannot_invite(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs($this->addStudent($course));

        $this->postJson("/api/v1/courses/{$course->id}/invitations", ['email' => 'x@example.com', 'role' => 'student'])
            ->assertForbidden();
    }

    public function test_duplicate_and_member_invitations_are_rejected(): void
    {
        $course = Course::factory()->create();
        $student = $this->addStudent($course);
        Sanctum::actingAs($course->owner);

        $this->postJson("/api/v1/courses/{$course->id}/invitations", ['email' => $student->email, 'role' => 'student'])
            ->assertStatus(409)
            ->assertJson(['code' => 'already_member']);

        $this->postJson("/api/v1/courses/{$course->id}/invitations", ['email' => 'x@example.com', 'role' => 'student'])->assertCreated();
        $this->postJson("/api/v1/courses/{$course->id}/invitations", ['email' => 'x@example.com', 'role' => 'student'])
            ->assertStatus(409)
            ->assertJson(['code' => 'already_invited']);
    }

    public function test_invitee_sees_and_accepts_invitation(): void
    {
        $course = Course::factory()->create();
        $this->makePost($course);
        $invitee = User::factory()->create();
        $invitation = $this->invite($course, $invitee->email, 'student');
        Sanctum::actingAs($invitee);

        $this->getJson('/api/v1/me/invitations')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.course.name', $course->name);

        $this->postJson("/api/v1/invitations/{$invitation->id}/accept")
            ->assertOk()
            ->assertJsonPath('data.my_role', 'student');

        $this->assertTrue($invitee->isStudentOf($course));
        $this->assertSame(1, $invitee->submissions()->count());
        $this->assertSame('accepted', $invitation->fresh()->status);
        $this->getJson('/api/v1/me/invitations')->assertJsonCount(0, 'data');
    }

    public function test_co_teacher_invitation_makes_teacher_without_submissions(): void
    {
        $course = Course::factory()->create();
        $this->makePost($course);
        $invitee = User::factory()->create();
        $invitation = $this->invite($course, $invitee->email, 'teacher');
        Sanctum::actingAs($invitee);

        $this->postJson("/api/v1/invitations/{$invitation->id}/accept")->assertOk()->assertJsonPath('data.my_role', 'teacher');

        $this->assertSame(0, $invitee->submissions()->count());
    }

    public function test_other_users_cannot_respond(): void
    {
        $course = Course::factory()->create();
        $invitation = $this->invite($course, 'orang@example.com', 'student');
        Sanctum::actingAs(User::factory()->create());

        $this->postJson("/api/v1/invitations/{$invitation->id}/accept")->assertForbidden();
        $this->postJson("/api/v1/invitations/{$invitation->id}/decline")->assertForbidden();
    }

    public function test_decline_and_responding_twice(): void
    {
        $course = Course::factory()->create();
        $invitee = User::factory()->create();
        $invitation = $this->invite($course, $invitee->email, 'student');
        Sanctum::actingAs($invitee);

        $this->postJson("/api/v1/invitations/{$invitation->id}/decline")->assertNoContent();
        $this->assertSame('declined', $invitation->fresh()->status);
        $this->postJson("/api/v1/invitations/{$invitation->id}/accept")->assertNotFound();
    }

    public function test_joining_by_code_clears_pending_invitation(): void
    {
        $course = Course::factory()->create();
        $student = User::factory()->create();
        $invitation = $this->invite($course, $student->email, 'student');
        Sanctum::actingAs($student);

        $this->postJson('/api/v1/courses/join', ['code' => $course->code])->assertOk();

        $this->assertSame('accepted', $invitation->fresh()->status);
    }

    public function test_teacher_cancels_invitation(): void
    {
        $course = Course::factory()->create();
        $invitation = $this->invite($course, 'x@example.com', 'student');

        Sanctum::actingAs($this->addStudent($course));
        $this->deleteJson("/api/v1/invitations/{$invitation->id}")->assertForbidden();

        Sanctum::actingAs($course->owner);
        $this->deleteJson("/api/v1/invitations/{$invitation->id}")->assertNoContent();
        $this->assertModelMissing($invitation);
    }

    private function invite(Course $course, string $email, string $role): Invitation
    {
        return Invitation::create([
            'course_id' => $course->id,
            'invited_by' => $course->owner_id,
            'email' => $email,
            'role' => $role,
        ]);
    }
}
