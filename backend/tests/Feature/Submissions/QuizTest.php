<?php

namespace Tests\Feature\Submissions;

use App\Enums\PostStatus;
use App\Enums\PostType;
use App\Enums\SubmissionStatus;
use App\Models\Course;
use App\Models\Post;
use App\Services\PublishPostService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Concerns\BuildsCourses;
use Tests\TestCase;

class QuizTest extends TestCase
{
    use BuildsCourses, RefreshDatabase;

    private function payload(): array
    {
        return ['questions' => [
            ['prompt' => 'Ibu kota Jawa Timur adalah ...', 'points' => 10, 'options' => [
                ['label' => 'Malang', 'is_correct' => false],
                ['label' => 'Surabaya', 'is_correct' => true],
                ['label' => 'Kediri', 'is_correct' => false],
            ]],
            ['prompt' => '2 + 2 = ...', 'points' => 5, 'options' => [
                ['label' => '4', 'is_correct' => true],
                ['label' => '5', 'is_correct' => false],
            ]],
        ]];
    }

    public function test_teacher_saves_questions_and_points_are_recomputed(): void
    {
        $course = Course::factory()->create();
        $quiz = $this->makePost($course, PostType::Quiz, publish: false);
        Sanctum::actingAs($course->owner);

        $this->putJson("/api/v1/posts/{$quiz->id}/quiz", $this->payload())
            ->assertOk()
            ->assertJsonCount(2, 'data')
            ->assertJsonPath('data.0.options.1.is_correct', true);

        $this->assertSame(15, $quiz->fresh()->points);
        $this->assertSame(2, $quiz->quizQuestions()->count());
    }

    public function test_question_rules_from_api_doc(): void
    {
        $course = Course::factory()->create();
        $quiz = $this->makePost($course, PostType::Quiz, publish: false);
        Sanctum::actingAs($course->owner);
        $url = "/api/v1/posts/{$quiz->id}/quiz";

        $twoCorrect = $this->payload();
        $twoCorrect['questions'][0]['options'][0]['is_correct'] = true;
        $this->putJson($url, $twoCorrect)->assertJsonValidationErrors('questions.0.options');

        $oneOption = $this->payload();
        $oneOption['questions'][1]['options'] = [['label' => '4', 'is_correct' => true]];
        $this->putJson($url, $oneOption)->assertJsonValidationErrors('questions.1.options');

        $this->putJson($url, ['questions' => []])->assertJsonValidationErrors('questions');
    }

    public function test_cannot_save_questions_on_non_quiz(): void
    {
        $course = Course::factory()->create();
        $assignment = $this->makePost($course, publish: false);
        Sanctum::actingAs($course->owner);

        $this->putJson("/api/v1/posts/{$assignment->id}/quiz", $this->payload())->assertJsonValidationErrors('questions');
    }

    public function test_quiz_without_questions_cannot_be_published(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs($course->owner);

        $this->postJson("/api/v1/courses/{$course->id}/posts", ['type' => 'quiz', 'title' => 'Kuis', 'status' => 'published'])
            ->assertJsonValidationErrors('status');
        $this->assertSame(0, $course->posts()->count());

        $id = $this->postJson("/api/v1/courses/{$course->id}/posts", ['type' => 'quiz', 'title' => 'Kuis', 'status' => 'draft'])
            ->assertCreated()->json('data.id');
        $this->postJson("/api/v1/posts/{$id}/publish")->assertJsonValidationErrors('status');

        $this->putJson("/api/v1/posts/{$id}/quiz", $this->payload())->assertOk();
        $this->postJson("/api/v1/posts/{$id}/publish")->assertOk();
    }

    public function test_scheduler_skips_quiz_without_questions(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs($course->owner);
        $id = $this->postJson("/api/v1/courses/{$course->id}/posts", [
            'type' => 'quiz', 'title' => 'Kuis', 'status' => 'scheduled', 'scheduled_at' => now()->addMinute()->toIso8601String(),
        ])->assertCreated()->json('data.id');

        $this->travel(2)->minutes();
        $this->artisan('posts:publish-scheduled')->assertSuccessful();

        $this->assertSame(PostStatus::Scheduled, $course->posts()->find($id)->status);
    }

    public function test_student_submits_quiz_and_is_graded_automatically(): void
    {
        $course = Course::factory()->create();
        $student = $this->addStudent($course);
        $quiz = $this->makePost($course, PostType::Quiz, publish: false);
        $quiz->quizQuestions()->delete();
        $q1 = $this->addQuizQuestion($quiz, points: 10, correct: 1);
        $q2 = $this->addQuizQuestion($quiz, points: 5, correct: 0);
        $q3 = $this->addQuizQuestion($quiz, points: 3, correct: 2);
        $this->publish($quiz);
        Sanctum::actingAs($student);

        // Soal 1 benar, soal 2 salah, soal 3 tidak dijawab.
        $this->postJson("/api/v1/posts/{$quiz->id}/my-submission/quiz", ['answers' => [
            ['question_id' => $q1->id, 'option_id' => $q1->options[1]->id],
            ['question_id' => $q2->id, 'option_id' => $q2->options[2]->id],
            ['question_id' => $q3->id, 'option_id' => null],
        ]])->assertOk()
            ->assertJsonPath('data.status', 'turned_in')
            ->assertJsonPath('data.grade', null)
            ->assertJsonMissingPath('data.draft_grade')
            ->assertJsonPath('data.quiz_answers.0.is_correct', null);

        $submission = $quiz->submissions()->firstOrFail();
        $this->assertSame('10.00', $submission->draft_grade);
        $this->assertSame(3, $submission->quizAnswers()->count());
    }

    public function test_option_from_another_question_counts_as_wrong(): void
    {
        $course = Course::factory()->create();
        $student = $this->addStudent($course);
        $quiz = $this->makePost($course, PostType::Quiz, publish: false);
        $quiz->quizQuestions()->delete();
        $q1 = $this->addQuizQuestion($quiz, correct: 0);
        $q2 = $this->addQuizQuestion($quiz, correct: 0);
        $this->publish($quiz);
        Sanctum::actingAs($student);

        $this->postJson("/api/v1/posts/{$quiz->id}/my-submission/quiz", ['answers' => [
            ['question_id' => $q1->id, 'option_id' => $q2->options[0]->id],
        ]])->assertOk();

        $this->assertSame('0.00', $quiz->submissions()->value('draft_grade'));
    }

    public function test_quiz_rules_after_turn_in(): void
    {
        $course = Course::factory()->create();
        $student = $this->addStudent($course);
        $quiz = $this->makePost($course, PostType::Quiz);
        Sanctum::actingAs($student);
        $url = "/api/v1/posts/{$quiz->id}/my-submission";

        $this->postJson("{$url}/turn-in")->assertJsonValidationErrors('answers');
        $this->postJson("{$url}/quiz", ['answers' => []])->assertOk();
        $this->postJson("{$url}/quiz", ['answers' => []])->assertStatus(409)->assertJson(['code' => 'already_turned_in']);
        $this->postJson("{$url}/unsubmit")->assertStatus(409)->assertJson(['code' => 'quiz_cannot_unsubmit']);

        Sanctum::actingAs($course->owner);
        $this->putJson("/api/v1/posts/{$quiz->id}/quiz", $this->payload())->assertStatus(409)->assertJson(['code' => 'quiz_locked']);
    }

    public function test_students_see_answer_key_only_after_return(): void
    {
        $course = Course::factory()->create();
        $student = $this->addStudent($course);
        $quiz = $this->makePost($course, PostType::Quiz);
        Sanctum::actingAs($student);

        $this->getJson("/api/v1/posts/{$quiz->id}/quiz")->assertOk()->assertJsonMissingPath('data.0.options.0.is_correct');

        $quiz->submissions()->update(['status' => SubmissionStatus::Returned, 'grade' => 10, 'draft_grade' => 10]);
        $this->getJson("/api/v1/posts/{$quiz->id}/quiz")->assertJsonPath('data.0.options.0.is_correct', true);
    }

    private function publish(Post $post): void
    {
        app(PublishPostService::class)->publish($post);
    }
}
