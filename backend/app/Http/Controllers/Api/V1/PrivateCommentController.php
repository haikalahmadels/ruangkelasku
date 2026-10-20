<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Post\StoreCommentRequest;
use App\Http\Resources\CommentResource;
use App\Models\Submission;
use App\Services\PrivateCommentService;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Facades\Gate;

class PrivateCommentController extends Controller
{
    public function index(Submission $submission): AnonymousResourceCollection
    {
        Gate::authorize('view', $submission);

        return CommentResource::collection(
            $submission->privateComments()->with('user')->oldest()->oldest('id')->get(),
        );
    }

    public function store(StoreCommentRequest $request, Submission $submission, PrivateCommentService $comments): CommentResource
    {
        Gate::authorize('view', $submission);

        return new CommentResource($comments->create($submission, $request->user(), $request->validated('body')));
    }
}
