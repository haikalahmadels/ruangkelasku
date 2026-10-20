<?php

namespace Tests\Feature;

use App\Enums\DisplayStatus;
use App\Enums\PostStatus;
use App\Enums\PostType;
use App\Enums\SubmissionStatus;
use App\Models\Course;
use App\Models\Post;
use App\Models\Submission;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Tests\TestCase;

/** Pemetaan status di docs/erd.md, bagian "Status submission di UI". */
class SubmissionDisplayStatusTest extends TestCase
{
    use RefreshDatabase;

    public function test_assigned_before_due_is_assigned(): void
    {
        $submission = $this->submission(due: now()->addDay());

        $this->assertSame(DisplayStatus::Assigned, $submission->display_status);
    }

    public function test_assigned_without_due_is_assigned(): void
    {
        $submission = $this->submission(due: null);

        $this->assertSame(DisplayStatus::Assigned, $submission->display_status);
    }

    public function test_assigned_after_due_is_missing(): void
    {
        $submission = $this->submission(due: now()->subMinute());

        $this->assertSame(DisplayStatus::Missing, $submission->display_status);
    }

    public function test_turned_in_without_draft_grade_is_turned_in(): void
    {
        $submission = $this->submission(due: now()->addDay(), attributes: [
            'status' => SubmissionStatus::TurnedIn,
            'turned_in_at' => now(),
        ]);

        $this->assertSame(DisplayStatus::TurnedIn, $submission->display_status);
        $this->assertFalse($submission->is_late);
    }

    public function test_turned_in_with_draft_grade_is_graded(): void
    {
        $submission = $this->submission(due: now()->addDay(), attributes: [
            'status' => SubmissionStatus::TurnedIn,
            'turned_in_at' => now(),
            'draft_grade' => 80,
        ]);

        $this->assertSame(DisplayStatus::Graded, $submission->display_status);
    }

    public function test_returned_is_returned(): void
    {
        $submission = $this->submission(due: now()->subDay(), attributes: [
            'status' => SubmissionStatus::Returned,
            'grade' => 90,
        ]);

        $this->assertSame(DisplayStatus::Returned, $submission->display_status);
    }

    public function test_turned_in_after_due_is_late(): void
    {
        $submission = $this->submission(due: now()->subHour(), attributes: [
            'status' => SubmissionStatus::TurnedIn,
            'turned_in_at' => now(),
        ]);

        $this->assertSame(DisplayStatus::TurnedIn, $submission->display_status);
        $this->assertTrue($submission->is_late);
    }

    private function submission(?Carbon $due, array $attributes = []): Submission
    {
        $teacher = User::factory()->create();
        $student = User::factory()->create();
        $course = Course::create([
            'owner_id' => $teacher->id,
            'name' => 'Kelas Uji',
            'code' => Course::generateUniqueCode(),
            'theme' => 'forest',
        ]);
        $post = Post::create([
            'course_id' => $course->id,
            'author_id' => $teacher->id,
            'type' => PostType::Assignment,
            'title' => 'Tugas',
            'points' => 100,
            'due_at' => $due,
            'status' => PostStatus::Published,
            'published_at' => now(),
            'position' => 0,
        ]);

        return Submission::create([
            'post_id' => $post->id,
            'student_id' => $student->id,
            ...$attributes,
        ])->fresh();
    }
}
