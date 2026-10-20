<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\DisplayStatus;
use App\Http\Controllers\Controller;
use App\Http\Requests\Submission\GradeSubmissionRequest;
use App\Http\Requests\Submission\ReturnSubmissionsRequest;
use App\Http\Resources\SubmissionResource;
use App\Models\Post;
use App\Models\Submission;
use App\Services\SubmissionService;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;

/** Endpoint guru: daftar "Tugas siswa", menilai, dan mengembalikan. */
class SubmissionController extends Controller
{
    public function __construct(private SubmissionService $submissions) {}

    public function index(Request $request, Post $post): AnonymousResourceCollection
    {
        Gate::authorize('manageClasswork', $post->course);
        $request->validate(['display_status' => ['nullable', Rule::enum(DisplayStatus::class)]]);

        $all = $post->submissions()
            ->with(['student', 'attachments', 'quizAnswers'])
            ->withCount('privateComments')
            ->get()
            ->each(fn (Submission $submission) => $submission->setRelation('post', $post))
            ->sortBy(fn (Submission $submission) => mb_strtolower($submission->student->name))
            ->values();

        // Hitungan sama dengan submission_counts di PostResource.
        $counts = ['assigned' => 0, 'turned_in' => 0, 'graded' => 0, 'returned' => 0];
        foreach ($all as $submission) {
            $status = $submission->display_status === DisplayStatus::Missing
                ? 'assigned'
                : $submission->display_status->value;
            $counts[$status]++;
        }

        $filtered = $request->filled('display_status')
            ? $all->filter(fn (Submission $s) => $s->display_status->value === $request->input('display_status'))->values()
            : $all;

        return SubmissionResource::collection($filtered)->additional(['meta' => ['counts' => $counts]]);
    }

    public function show(Submission $submission): SubmissionResource
    {
        Gate::authorize('view', $submission);

        return $this->resource($submission);
    }

    public function grade(GradeSubmissionRequest $request, Submission $submission): SubmissionResource
    {
        $graded = $this->submissions->grade($submission, $request->validated('draft_grade'), $request->user());

        return $this->resource($graded);
    }

    public function return(ReturnSubmissionsRequest $request, Post $post): AnonymousResourceCollection
    {
        $returned = $this->submissions->return($post, $request->validated('submission_ids'))
            ->load(['attachments', 'quizAnswers'])
            ->loadCount('privateComments');

        return SubmissionResource::collection($returned);
    }

    private function resource(Submission $submission): SubmissionResource
    {
        return new SubmissionResource(
            $submission->load(['post', 'student', 'attachments', 'quizAnswers'])->loadCount('privateComments'),
        );
    }
}
