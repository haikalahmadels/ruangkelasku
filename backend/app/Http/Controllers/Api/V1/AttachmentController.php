<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Post\StoreAttachmentRequest;
use App\Http\Resources\AttachmentResource;
use App\Models\Attachment;
use App\Models\Post;
use App\Services\AttachmentService;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;

class AttachmentController extends Controller
{
    public function __construct(private AttachmentService $attachments) {}

    public function store(StoreAttachmentRequest $request, Post $post): AttachmentResource
    {
        Gate::authorize('update', $post);
        $post->course->ensureNotArchived();

        $attachment = $request->hasFile('file')
            ? $this->attachments->addFile($post, $request->user(), $request->file('file'))
            : $this->attachments->addLink($post, $request->user(), $request->validated('url'), $request->validated('title'));

        return new AttachmentResource($attachment);
    }

    public function destroy(Attachment $attachment): Response
    {
        Gate::authorize('delete', $attachment);
        $attachment->attachable->course->ensureNotArchived();

        $this->attachments->delete($attachment);

        return response()->noContent();
    }
}
