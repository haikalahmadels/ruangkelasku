<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Post\StoreCommentRequest;
use App\Http\Resources\CommentResource;
use App\Models\Post;
use App\Models\PostComment;
use App\Services\CommentService;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;

/** Komentar kelas: terlihat semua anggota. */
class CommentController extends Controller
{
    public function __construct(private CommentService $comments) {}

    public function index(Post $post): AnonymousResourceCollection
    {
        Gate::authorize('view', $post);

        return CommentResource::collection($post->comments()->with('user')->oldest()->oldest('id')->get());
    }

    public function store(StoreCommentRequest $request, Post $post): CommentResource
    {
        Gate::authorize('comment', $post);

        $comment = $this->comments->create($post, $request->user(), $request->validated('body'));

        return new CommentResource($comment->load('user'));
    }

    public function destroy(PostComment $comment): Response
    {
        Gate::authorize('delete', $comment);
        $this->comments->delete($comment);

        return response()->noContent();
    }
}
