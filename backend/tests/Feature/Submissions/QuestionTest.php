<?php

namespace Tests\Feature\Submissions;

use App\Enums\PostType;
use App\Models\Course;
use App\Models\Post;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Concerns\BuildsCourses;
use Tests\TestCase;

/** Stretch prioritas 1: Pertanyaan (jawaban singkat atau pilihan ganda), dinilai manual. */
class QuestionTest extends TestCase
{
    use BuildsCourses, RefreshDatabase;

    private Course $course;

    private User $student;

    protected function setUp(): void
    {
        parent::setUp();

        $this->course = Course::factory()->create();
        $this->student = $this->addStudent($this->course);
    }

    /** Pertanyaan draf lewat API, lalu bentuknya disimpan dan diterbitkan. */
    private function question(array $options): Post
    {
        Sanctum::actingAs($this->course->owner);
        $id = $this->postJson("/api/v1/courses/{$this->course->id}/posts", [
            'type' => 'question', 'title' => 'Apa itu gaya?', 'points' => 10, 'status' => 'draft',
        ])->assertCreated()->json('data.id');

        $this->putJson("/api/v1/posts/{$id}/question", ['options' => $options])->assertOk();
        $this->postJson("/api/v1/posts/{$id}/publish")->assertOk();

        return Post::findOrFail($id);
    }

    public function test_teacher_saves_question_form_without_answer_key(): void
    {
        Sanctum::actingAs($this->course->owner);
        $post = $this->makePost($this->course, PostType::Question, publish: false);

        $this->putJson("/api/v1/posts/{$post->id}/question", ['options' => ['Dorongan', 'Tarikan']])
            ->assertOk()
            ->assertJsonCount(2, 'data.0.options')
            ->assertJsonPath('data.0.options.1.label', 'Tarikan')
            ->assertJsonMissingPath('data.0.options.0.is_correct');

        $this->putJson("/api/v1/posts/{$post->id}/question", ['options' => ['Satu']])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('options');

        $this->putJson("/api/v1/posts/{$post->id}/question", ['options' => []])
            ->assertOk()
            ->assertJsonCount(0, 'data.0.options');
    }

    public function test_only_teacher_saves_and_only_question_posts(): void
    {
        $post = $this->makePost($this->course, PostType::Question, publish: false);
        $assignment = $this->makePost($this->course);

        Sanctum::actingAs($this->student);
        $this->putJson("/api/v1/posts/{$post->id}/question", ['options' => []])->assertForbidden();

        Sanctum::actingAs($this->course->owner);
        $this->putJson("/api/v1/posts/{$assignment->id}/question", ['options' => []])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('options');
    }

    public function test_question_needs_form_before_publishing(): void
    {
        Sanctum::actingAs($this->course->owner);
        $post = $this->makePost($this->course, PostType::Question, publish: false);

        $this->postJson("/api/v1/posts/{$post->id}/publish")->assertUnprocessable();

        $this->putJson("/api/v1/posts/{$post->id}/question", ['options' => []])->assertOk();
        $this->postJson("/api/v1/posts/{$post->id}/publish")->assertOk();
        $this->assertSame(1, $post->submissions()->count());
    }

    public function test_student_answers_multiple_choice_and_can_answer_again_after_unsubmit(): void
    {
        $post = $this->question(['Dorongan', 'Tarikan']);
        Sanctum::actingAs($this->student);

        $options = $this->getJson("/api/v1/posts/{$post->id}/quiz")->assertOk()->json('data.0.options');
        $this->assertArrayNotHasKey('is_correct', $options[0]);

        $this->postJson("/api/v1/posts/{$post->id}/my-submission/turn-in")->assertUnprocessable();
        $this->postJson("/api/v1/posts/{$post->id}/my-submission/answer", ['option_id' => 999999])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('option_id');

        $this->postJson("/api/v1/posts/{$post->id}/my-submission/answer", ['option_id' => $options[1]['id']])
            ->assertOk()
            ->assertJsonPath('data.display_status', 'turned_in')
            ->assertJsonPath('data.quiz_answers.0.option_id', $options[1]['id'])
            ->assertJsonPath('data.quiz_answers.0.is_correct', null)
            ->assertJsonPath('data.answer_text', null);

        $this->postJson("/api/v1/posts/{$post->id}/my-submission/answer", ['option_id' => $options[0]['id']])
            ->assertConflict()
            ->assertJsonPath('code', 'already_turned_in');

        $this->postJson("/api/v1/posts/{$post->id}/my-submission/unsubmit")
            ->assertOk()
            ->assertJsonPath('data.display_status', 'assigned');
        $this->postJson("/api/v1/posts/{$post->id}/my-submission/answer", ['option_id' => $options[0]['id']])
            ->assertOk()
            ->assertJsonCount(1, 'data.quiz_answers')
            ->assertJsonPath('data.quiz_answers.0.option_id', $options[0]['id']);
    }

    public function test_short_answer_is_graded_manually_and_private_to_the_student(): void
    {
        $post = $this->question([]);
        $other = $this->addStudent($this->course);
        // Guru tidak punya submission untuk dijawab.
        $this->postJson("/api/v1/posts/{$post->id}/my-submission/answer", ['answer_text' => 'x'])->assertForbidden();

        Sanctum::actingAs($this->student);
        $this->postJson("/api/v1/posts/{$post->id}/my-submission/answer", ['answer_text' => '   '])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('answer_text');
        $submissionId = $this->postJson("/api/v1/posts/{$post->id}/my-submission/answer", [
            'answer_text' => 'Tarikan atau dorongan pada benda.',
        ])->assertOk()->assertJsonPath('data.answer_text', 'Tarikan atau dorongan pada benda.')->json('data.id');

        Sanctum::actingAs($other);
        $this->getJson("/api/v1/submissions/{$submissionId}")->assertForbidden();

        Sanctum::actingAs($this->course->owner);
        $this->getJson("/api/v1/submissions/{$submissionId}")
            ->assertOk()
            ->assertJsonPath('data.answer_text', 'Tarikan atau dorongan pada benda.');
        $this->patchJson("/api/v1/submissions/{$submissionId}/grade", ['draft_grade' => 8])->assertOk();
        $this->postJson("/api/v1/posts/{$post->id}/return", ['submission_ids' => [$submissionId]])->assertOk();

        Sanctum::actingAs($this->student);
        $this->getJson("/api/v1/posts/{$post->id}/my-submission")
            ->assertJsonPath('data.grade', 8)
            ->assertJsonPath('data.display_status', 'returned');
    }

    public function test_form_is_locked_after_a_student_answers(): void
    {
        $post = $this->question([]);
        Sanctum::actingAs($this->student);
        $this->postJson("/api/v1/posts/{$post->id}/my-submission/answer", ['answer_text' => 'Jawaban'])->assertOk();

        Sanctum::actingAs($this->course->owner);
        $this->putJson("/api/v1/posts/{$post->id}/question", ['options' => ['A', 'B']])
            ->assertConflict()
            ->assertJsonPath('code', 'quiz_locked');
    }
}
