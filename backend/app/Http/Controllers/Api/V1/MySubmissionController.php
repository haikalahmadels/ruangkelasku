<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Post\StoreAttachmentRequest;
use App\Http\Requests\Quiz\AnswerQuestionRequest;
use App\Http\Requests\Quiz\SubmitQuizRequest;
use App\Http\Resources\AttachmentResource;
use App\Http\Resources\SubmissionResource;
use App\Models\Attachment;
use App\Models\Post;
use App\Models\Submission;
use App\Services\SubmissionService;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;

/** Endpoint siswa: Flutter tidak perlu tahu ID submission miliknya. */
class MySubmissionController extends Controller
{
    public function __construct(private SubmissionService $submissions) {}

    public function show(Request $request, Post $post): SubmissionResource
    {
        return $this->resource($this->mine($request, $post));
    }

    public function storeAttachment(StoreAttachmentRequest $request, Post $post): AttachmentResource
    {
        $submission = $this->mine($request, $post);

        $attachment = $request->hasFile('file')
            ? $this->submissions->addFile($submission, $request->user(), $request->file('file'))
            : $this->submissions->addLink($submission, $request->user(), $request->validated('url'), $request->validated('title'));

        return new AttachmentResource($attachment);
    }

    public function destroyAttachment(Request $request, Post $post, Attachment $attachment): Response
    {
        $submission = $this->mine($request, $post);
        abort_unless(
            $attachment->attachable_type === 'submission' && $attachment->attachable_id === $submission->id,
            404,
            'Lampiran tidak ditemukan.',
        );

        $this->submissions->removeAttachment($submission, $attachment);

        return response()->noContent();
    }

    public function turnIn(Request $request, Post $post): SubmissionResource
    {
        return $this->resource($this->submissions->turnIn($this->mine($request, $post)));
    }

    public function unsubmit(Request $request, Post $post): SubmissionResource
    {
        return $this->resource($this->submissions->unsubmit($this->mine($request, $post)));
    }

    public function submitQuiz(SubmitQuizRequest $request, Post $post): SubmissionResource
    {
        $submission = $this->mine($request, $post);

        return $this->resource($this->submissions->submitQuiz($submission, $request->answerMap()));
    }

    /** Pertanyaan (stretch): menjawab sekaligus menyerahkan. */
    public function answerQuestion(AnswerQuestionRequest $request, Post $post): SubmissionResource
    {
        $submission = $this->mine($request, $post);

        return $this->resource($this->submissions->answerQuestion(
            $submission,
            $request->validated('answer_text'),
            $request->validated('option_id'),
        ));
    }

    private function mine(Request $request, Post $post): Submission
    {
        Gate::authorize('view', $post);
        $user = $request->user();
        abort_unless($user->isStudentOf($post->course), 403, 'Hanya siswa kelas ini yang punya tugas.');

        $submission = $post->submissions()->where('student_id', $user->id)->first();
        abort_if($submission === null, 404, 'Tugas tidak ditemukan.');

        return $submission->setRelation('post', $post);
    }

    private function resource(Submission $submission): SubmissionResource
    {
        return new SubmissionResource(
            $submission->load(['attachments', 'quizAnswers'])->loadCount('privateComments'),
        );
    }
}
