<?php

namespace Tests\Feature\Submissions;

use App\Enums\SubmissionStatus;
use App\Models\Course;
use App\Models\Post;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\Concerns\BuildsCourses;
use Tests\TestCase;

class SubmissionTest extends TestCase
{
    use BuildsCourses, RefreshDatabase;

    private Course $course;

    private User $student;

    private Post $post;

    protected function setUp(): void
    {
        parent::setUp();
        Storage::fake('public');
        $this->course = Course::factory()->create();
        $this->student = $this->addStudent($this->course);
        $this->post = $this->makePost($this->course);
    }

    public function test_student_attaches_turns_in_and_unsubmits(): void
    {
        Sanctum::actingAs($this->student);
        $url = "/api/v1/posts/{$this->post->id}/my-submission";

        $file = $this->post("{$url}/attachments", ['file' => UploadedFile::fake()->image('tugas.jpg')], ['Accept' => 'application/json'])
            ->assertCreated()->json('data');
        $this->postJson("{$url}/attachments", ['url' => 'https://docs.example.com/x', 'title' => 'Dokumen'])->assertCreated();

        $this->postJson("{$url}/turn-in")->assertOk()->assertJsonPath('data.display_status', 'turned_in');
        $this->postJson("{$url}/attachments", ['url' => 'https://x.test'])->assertStatus(409)->assertJson(['code' => 'already_turned_in']);
        $this->deleteJson("{$url}/attachments/{$file['id']}")->assertStatus(409);
        $this->postJson("{$url}/turn-in")->assertStatus(409)->assertJson(['code' => 'already_turned_in']);

        $this->postJson("{$url}/unsubmit")->assertOk()->assertJsonPath('data.status', 'assigned');
        $this->deleteJson("{$url}/attachments/{$file['id']}")->assertNoContent();
        $this->getJson($url)->assertOk()->assertJsonCount(1, 'data.attachments');
    }

    public function test_turn_in_notifies_teachers(): void
    {
        $coTeacher = $this->addTeacher($this->course);
        Sanctum::actingAs($this->student);

        $this->postJson("/api/v1/posts/{$this->post->id}/my-submission/turn-in")->assertOk();

        foreach ([$this->course->owner, $coTeacher] as $teacher) {
            $this->assertSame(1, $teacher->notifications()->where('type', 'submission_turned_in')->count());
        }
    }

    public function test_student_cannot_read_another_students_submission(): void
    {
        $other = $this->addStudent($this->course);
        $otherSubmission = $this->post->submissions()->create(['student_id' => $other->id]);
        Sanctum::actingAs($this->student);

        $this->getJson("/api/v1/submissions/{$otherSubmission->id}")->assertForbidden();
        $this->getJson("/api/v1/submissions/{$otherSubmission->id}/comments")->assertForbidden();
        $this->postJson("/api/v1/submissions/{$otherSubmission->id}/comments", ['body' => 'X'])->assertForbidden();
        $this->getJson("/api/v1/posts/{$this->post->id}/submissions")->assertForbidden();
        $this->patchJson("/api/v1/submissions/{$otherSubmission->id}/grade", ['draft_grade' => 100])->assertForbidden();
    }

    public function test_teachers_cannot_use_student_endpoints(): void
    {
        Sanctum::actingAs($this->course->owner);

        $this->getJson("/api/v1/posts/{$this->post->id}/my-submission")->assertForbidden();
    }

    public function test_teacher_lists_submissions_with_counts_and_filter(): void
    {
        $second = $this->addStudent($this->course);
        $this->post->submissions()->create(['student_id' => $second->id, 'status' => SubmissionStatus::TurnedIn, 'turned_in_at' => now()]);
        Sanctum::actingAs($this->course->owner);

        $this->getJson("/api/v1/posts/{$this->post->id}/submissions")
            ->assertOk()
            ->assertJsonCount(2, 'data')
            ->assertJsonPath('meta.counts', ['assigned' => 1, 'turned_in' => 1, 'graded' => 0, 'returned' => 0]);

        $this->getJson("/api/v1/posts/{$this->post->id}/submissions?display_status=turned_in")
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.student.id', $second->id);
    }

    public function test_grading_respects_points_and_return_copies_grade(): void
    {
        $submission = $this->post->submissions()->firstOrFail();
        $submission->update(['status' => SubmissionStatus::TurnedIn, 'turned_in_at' => now()]);
        Sanctum::actingAs($this->course->owner);

        $this->patchJson("/api/v1/submissions/{$submission->id}/grade", ['draft_grade' => 101])->assertJsonValidationErrors('draft_grade');
        $this->patchJson("/api/v1/submissions/{$submission->id}/grade", ['draft_grade' => 85.5])
            ->assertOk()
            ->assertJsonPath('data.draft_grade', 85.5)
            ->assertJsonPath('data.display_status', 'graded');

        Sanctum::actingAs($this->student);
        $this->getJson("/api/v1/posts/{$this->post->id}/my-submission")
            ->assertJsonMissingPath('data.draft_grade')
            ->assertJsonPath('data.grade', null);

        Sanctum::actingAs($this->course->owner);
        $this->postJson("/api/v1/posts/{$this->post->id}/return", ['submission_ids' => [$submission->id]])
            ->assertOk()
            ->assertJsonPath('data.0.status', 'returned')
            ->assertJsonPath('data.0.grade', 85.5);

        Sanctum::actingAs($this->student);
        $this->getJson("/api/v1/posts/{$this->post->id}/my-submission")->assertJsonPath('data.grade', 85.5);
        $this->assertSame(
            'Judul: nilai 85.5/100',
            $this->student->notifications()->where('type', 'submission_returned')->first()->data['message'],
        );
    }

    public function test_cannot_grade_post_without_points(): void
    {
        $this->post->update(['points' => null]);
        $submission = $this->post->submissions()->firstOrFail();
        Sanctum::actingAs($this->course->owner);

        $this->patchJson("/api/v1/submissions/{$submission->id}/grade", ['draft_grade' => 10])->assertJsonValidationErrors('draft_grade');
        $this->patchJson("/api/v1/submissions/{$submission->id}/grade", ['draft_grade' => null])->assertOk();
    }

    public function test_bulk_return_ignores_other_posts_submissions(): void
    {
        $otherPost = $this->makePost($this->course);
        $foreign = $otherPost->submissions()->firstOrFail();
        Sanctum::actingAs($this->course->owner);

        $this->postJson("/api/v1/posts/{$this->post->id}/return", ['submission_ids' => [$foreign->id]])
            ->assertJsonValidationErrors('submission_ids.0');
    }

    public function test_resubmitting_after_return_keeps_old_grade_visible(): void
    {
        $this->post->submissions()->update([
            'status' => SubmissionStatus::Returned, 'draft_grade' => 70, 'grade' => 70, 'returned_at' => now(),
        ]);
        Sanctum::actingAs($this->student);

        $this->postJson("/api/v1/posts/{$this->post->id}/my-submission/turn-in")
            ->assertOk()
            ->assertJsonPath('data.status', 'turned_in')
            ->assertJsonPath('data.grade', 70);
    }

    public function test_private_comments_between_teacher_and_student(): void
    {
        $submission = $this->post->submissions()->firstOrFail();

        Sanctum::actingAs($this->student);
        $this->postJson("/api/v1/submissions/{$submission->id}/comments", ['body' => 'Bu, boleh minta perpanjangan?'])
            ->assertCreated()
            ->assertJsonPath('data.author.id', $this->student->id);
        $this->assertSame(1, $this->course->owner->notifications()->where('type', 'private_comment')->count());

        Sanctum::actingAs($this->course->owner);
        $this->postJson("/api/v1/submissions/{$submission->id}/comments", ['body' => 'Boleh, sampai Jumat.'])->assertCreated();
        $this->getJson("/api/v1/submissions/{$submission->id}/comments")->assertOk()->assertJsonCount(2, 'data');
        $this->assertSame(1, $this->student->notifications()->where('type', 'private_comment')->count());
    }

    public function test_archived_course_blocks_turn_in_and_grading(): void
    {
        $submission = $this->post->submissions()->firstOrFail();
        $this->course->update(['archived_at' => now()]);

        Sanctum::actingAs($this->student);
        $this->postJson("/api/v1/posts/{$this->post->id}/my-submission/turn-in")->assertStatus(409)->assertJson(['code' => 'course_archived']);

        Sanctum::actingAs($this->course->owner);
        $this->patchJson("/api/v1/submissions/{$submission->id}/grade", ['draft_grade' => 50])->assertStatus(409);
    }
}
