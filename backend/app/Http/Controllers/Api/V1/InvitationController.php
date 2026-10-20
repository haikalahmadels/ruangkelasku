<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\CourseRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Course\StoreInvitationRequest;
use App\Http\Resources\CourseResource;
use App\Http\Resources\InvitationResource;
use App\Models\Course;
use App\Models\Invitation;
use App\Services\InvitationService;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;

class InvitationController extends Controller
{
    public function __construct(private InvitationService $invitations) {}

    public function index(Course $course): AnonymousResourceCollection
    {
        Gate::authorize('update', $course);

        return InvitationResource::collection(
            $course->invitations()->where('status', 'pending')->with('inviter')->latest()->get(),
        );
    }

    public function store(StoreInvitationRequest $request, Course $course): InvitationResource
    {
        $invitation = $this->invitations->invite(
            $course,
            $request->user(),
            $request->validated('email'),
            CourseRole::from($request->validated('role')),
        );

        return new InvitationResource($invitation->load('inviter'));
    }

    public function destroy(Invitation $invitation): Response
    {
        Gate::authorize('delete', $invitation);
        $invitation->delete();

        return response()->noContent();
    }

    public function mine(Request $request): AnonymousResourceCollection
    {
        $invitations = Invitation::where('email', $request->user()->email)
            ->where('status', 'pending')
            ->whereHas('course', fn ($query) => $query->whereNull('archived_at'))
            ->with(['inviter', 'course.owner'])
            ->latest()
            ->get();

        return InvitationResource::collection($invitations);
    }

    public function accept(Request $request, Invitation $invitation): CourseResource
    {
        Gate::authorize('respond', $invitation);

        $course = $this->invitations->accept($invitation, $request->user());

        return new CourseResource($course->load('owner')->loadCount('students'));
    }

    public function decline(Invitation $invitation): Response
    {
        Gate::authorize('respond', $invitation);
        $this->invitations->decline($invitation);

        return response()->noContent();
    }
}
