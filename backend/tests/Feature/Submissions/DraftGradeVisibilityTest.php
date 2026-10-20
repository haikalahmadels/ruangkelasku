<?php

namespace Tests\Feature\Submissions;

use App\Enums\SubmissionStatus;
use App\Models\Course;
use App\Models\Post;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Concerns\BuildsCourses;
use Tests\TestCase;

/** Nilai draf hanya terlihat guru: siswa melihat "Diserahkan", bukan "Dinilai (draf)". */
class DraftGradeVisibilityTest extends TestCase
{
    use BuildsCourses, RefreshDatabase;

    private Course $course;

    private User $student;

    private Post $post;

    protected function setUp(): void
    {
        parent::setUp();

        $this->course = Course::factory()->create();
        $this->student = $this->addStudent($this->course);
        $this->post = $this->makePost($this->course);
        $this->post->submissions()->where('student_id', $this->student->id)->update([
            'status' => SubmissionStatus::TurnedIn,
            'turned_in_at' => now(),
            'draft_grade' => 80,
        ]);
    }

    public function test_student_sees_turned_in_while_grade_is_draft(): void
    {
        Sanctum::actingAs($this->student);

        $this->getJson("/api/v1/posts/{$this->post->id}/my-submission")
            ->assertOk()
            ->assertJsonPath('data.display_status', 'turned_in')
            ->assertJsonMissingPath('data.draft_grade');

        $this->getJson("/api/v1/posts/{$this->post->id}")
            ->assertJsonPath('data.my_submission.display_status', 'turned_in');

        $this->getJson("/api/v1/courses/{$this->course->id}/my-work")
            ->assertJsonPath('data.0.my_submission.display_status', 'turned_in');

        $this->getJson('/api/v1/todo?tab=done')
            ->assertJsonPath('data.0.my_submission.display_status', 'turned_in');
    }

    public function test_teacher_still_sees_graded(): void
    {
        Sanctum::actingAs($this->course->owner);
        $submissionId = $this->post->submissions()->value('id');

        $this->getJson("/api/v1/submissions/{$submissionId}")
            ->assertJsonPath('data.display_status', 'graded')
            ->assertJsonPath('data.draft_grade', 80);

        $this->getJson("/api/v1/posts/{$this->post->id}/submissions")
            ->assertJsonPath('data.0.display_status', 'graded')
            ->assertJsonPath('meta.counts.graded', 1);

        $this->getJson("/api/v1/courses/{$this->course->id}/grades")
            ->assertJsonPath("data.students.0.grades.{$this->post->id}.display_status", 'graded');
    }
}
