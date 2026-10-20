<?php

namespace Tests\Feature\Submissions;

use App\Enums\PostType;
use App\Enums\SubmissionStatus;
use App\Models\Course;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Concerns\BuildsCourses;
use Tests\TestCase;

class GradesTodoNotificationTest extends TestCase
{
    use BuildsCourses, RefreshDatabase;

    public function test_grades_grid_and_csv_export(): void
    {
        $course = Course::factory()->create(['code' => 'abc1234']);
        $ani = $this->addStudent($course, User::factory()->create(['name' => 'Ani']));
        $budi = $this->addStudent($course, User::factory()->create(['name' => 'Budi']));
        $post = $this->makePost($course);
        $post->update(['title' => 'Latihan 1']);
        $post->submissions()->where('student_id', $ani->id)->update(['status' => SubmissionStatus::Returned, 'grade' => 90, 'draft_grade' => 90]);
        $post->submissions()->where('student_id', $budi->id)->update(['status' => SubmissionStatus::TurnedIn, 'draft_grade' => 72.5, 'turned_in_at' => now()]);
        $this->makePost($course, PostType::Material);
        Sanctum::actingAs($course->owner);

        $this->getJson("/api/v1/courses/{$course->id}/grades")
            ->assertOk()
            ->assertJsonCount(1, 'data.posts')
            ->assertJsonPath('data.students.0.user.name', 'Ani')
            ->assertJsonPath("data.students.0.grades.{$post->id}.grade", 90)
            ->assertJsonPath("data.students.1.grades.{$post->id}.display_status", 'graded')
            ->assertJsonPath("data.students.1.grades.{$post->id}.draft_grade", 72.5);

        $response = $this->get("/api/v1/courses/{$course->id}/grades/export")->assertOk();
        $response->assertHeader('Content-Disposition', 'attachment; filename="nilai-abc1234.csv"');
        $lines = explode("\n", trim(substr($response->getContent(), 3)));
        $this->assertSame('Nama,Email,"Latihan 1"', $lines[0]);
        $this->assertSame('"Poin maksimal",,100', $lines[1]);
        $this->assertSame("Ani,{$ani->email},90", $lines[2]);
        $this->assertSame("Budi,{$budi->email},72.5", $lines[3]);
    }

    public function test_students_cannot_open_grades(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs($this->addStudent($course));

        $this->getJson("/api/v1/courses/{$course->id}/grades")->assertForbidden();
        $this->get("/api/v1/courses/{$course->id}/grades/export", ['Accept' => 'application/json'])->assertForbidden();
    }

    public function test_my_work_lists_only_own_submissions(): void
    {
        $course = Course::factory()->create();
        $student = $this->addStudent($course);
        $this->addStudent($course);
        $this->makePost($course);
        $this->makePost($course, PostType::Material);
        Sanctum::actingAs($student);

        $this->getJson("/api/v1/courses/{$course->id}/my-work")
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.my_submission.display_status', 'assigned');

        Sanctum::actingAs($course->owner);
        $this->getJson("/api/v1/courses/{$course->id}/my-work")->assertForbidden();
    }

    public function test_todo_tabs_across_courses(): void
    {
        $student = User::factory()->create();
        $math = Course::factory()->create();
        $bio = Course::factory()->create();
        $archived = Course::factory()->create();
        foreach ([$math, $bio, $archived] as $course) {
            $this->addStudent($course, $student);
        }

        $upcoming = tap($this->makePost($math))->update(['due_at' => now()->addDays(2)]);
        $noDue = $this->makePost($bio);
        $missing = tap($this->makePost($bio))->update(['due_at' => now()->subDay()]);
        $done = $this->makePost($math);
        $done->submissions()->update(['status' => SubmissionStatus::TurnedIn, 'turned_in_at' => now()]);
        $this->makePost($archived);
        $archived->update(['archived_at' => now()]);
        Sanctum::actingAs($student);

        $assigned = $this->getJson('/api/v1/todo?tab=assigned')->assertOk();
        $this->assertSame([$upcoming->id, $noDue->id], array_column($assigned->json('data'), 'id'));
        $assigned->assertJsonPath('data.0.course.name', $math->name);

        $this->assertSame([$missing->id], array_column($this->getJson('/api/v1/todo?tab=missing')->json('data'), 'id'));
        $this->assertSame([$done->id], array_column($this->getJson('/api/v1/todo?tab=done')->json('data'), 'id'));
        $this->assertSame([$upcoming->id], array_column($this->getJson("/api/v1/todo?course_id={$math->id}")->json('data'), 'id'));
    }

    public function test_to_review_lists_work_in_courses_i_teach(): void
    {
        $teacher = User::factory()->create();
        $mine = Course::factory()->for($teacher, 'owner')->create();
        $this->addStudent($mine);
        $assignment = $this->makePost($mine);
        $assignment->submissions()->update(['status' => SubmissionStatus::TurnedIn, 'turned_in_at' => now()]);
        $this->makePost(Course::factory()->create());
        Sanctum::actingAs($teacher);

        $this->getJson('/api/v1/to-review')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $assignment->id)
            ->assertJsonPath('data.0.submission_counts.turned_in', 1);
    }

    public function test_publishing_notifies_members_except_author(): void
    {
        $course = Course::factory()->create();
        $student = $this->addStudent($course);
        $coTeacher = $this->addTeacher($course);
        $post = $this->makePost($course);

        $this->assertSame(0, $course->owner->notifications()->count());
        $this->assertSame(1, $coTeacher->notifications()->count());
        Sanctum::actingAs($student);

        $this->getJson('/api/v1/notifications')
            ->assertOk()
            ->assertJsonPath('data.0.type', 'post_published')
            ->assertJsonPath('data.0.title', 'Tugas baru')
            ->assertJsonPath('data.0.post_id', $post->id)
            ->assertJsonPath('data.0.course_id', $course->id)
            ->assertJsonPath('data.0.read_at', null);
    }

    public function test_read_and_unread_count(): void
    {
        $course = Course::factory()->create();
        $student = $this->addStudent($course);
        $this->makePost($course);
        $this->makePost($course, PostType::Announcement);
        Sanctum::actingAs($student);

        $this->getJson('/api/v1/notifications/unread-count')->assertExactJson(['data' => ['count' => 2]]);

        $id = $this->getJson('/api/v1/notifications')->json('data.0.id');
        $this->postJson("/api/v1/notifications/{$id}/read")->assertNoContent();
        $this->getJson('/api/v1/notifications/unread-count')->assertJsonPath('data.count', 1);
        $this->getJson('/api/v1/notifications?unread=1')->assertJsonCount(1, 'data');

        $this->postJson('/api/v1/notifications/read-all')->assertNoContent();
        $this->getJson('/api/v1/notifications/unread-count')->assertJsonPath('data.count', 0);

        Sanctum::actingAs($course->owner);
        $this->postJson("/api/v1/notifications/{$id}/read")->assertNotFound();
    }

    public function test_invitation_notifies_registered_invitee(): void
    {
        $course = Course::factory()->create();
        $invitee = User::factory()->create();
        Sanctum::actingAs($course->owner);

        $this->postJson("/api/v1/courses/{$course->id}/invitations", ['email' => $invitee->email, 'role' => 'teacher'])->assertCreated();

        $notification = $invitee->notifications()->firstOrFail();
        $this->assertSame('course_invitation', $notification->type);
        $this->assertStringContainsString('sebagai pengajar', $notification->data['message']);
    }
}
