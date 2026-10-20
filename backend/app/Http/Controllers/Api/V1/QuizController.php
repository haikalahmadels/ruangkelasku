<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\PostType;
use App\Enums\SubmissionStatus;
use App\Http\Controllers\Controller;
use App\Http\Requests\Quiz\SaveQuestionRequest;
use App\Http\Requests\Quiz\SaveQuizRequest;
use App\Http\Resources\QuizQuestionResource;
use App\Models\Post;
use App\Services\QuestionService;
use App\Services\QuizService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Gate;

class QuizController extends Controller
{
    /**
     * Soal kuis, atau satu soal Pertanyaan (stretch) beserta opsinya. Guru melihat kunci
     * jawaban kuis; siswa hanya setelah submission-nya dikembalikan. Pertanyaan tidak punya kunci.
     */
    public function show(Request $request, Post $post): JsonResponse
    {
        Gate::authorize('view', $post);
        abort_unless(in_array($post->type, [PostType::Quiz, PostType::Question], true), 404, 'Posting ini bukan kuis.');
        $user = $request->user();

        $showAnswers = $post->type === PostType::Quiz && (
            $user->isTeacherOf($post->course)
            || $post->submissions()
                ->where('student_id', $user->id)
                ->where('status', SubmissionStatus::Returned)
                ->exists()
        );

        return $this->questions($post->quizQuestions()->with('options')->get(), $showAnswers);
    }

    public function update(SaveQuizRequest $request, Post $post, QuizService $quiz): JsonResponse
    {
        return $this->questions($quiz->save($post, $request->validated('questions')), showAnswers: true);
    }

    /** PUT /posts/{post}/question (stretch): menyimpan bentuk Pertanyaan. */
    public function updateQuestion(SaveQuestionRequest $request, Post $post, QuestionService $questions): JsonResponse
    {
        $question = $questions->save($post, $request->validated('options'));

        return $this->questions(collect([$question]), showAnswers: false);
    }

    private function questions(Collection $questions, bool $showAnswers): JsonResponse
    {
        return response()->json([
            'data' => $questions->map(fn ($question) => new QuizQuestionResource($question, $showAnswers))->values(),
        ]);
    }
}
