<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\MemberResource;
use App\Models\Course;
use App\Models\User;
use App\Services\JoinCourseService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;

class MemberController extends Controller
{
    public function __construct(private JoinCourseService $joinCourse) {}

    public function index(Request $request, Course $course): JsonResponse
    {
        Gate::authorize('view', $course);

        $viewerIsTeacher = $request->user()->isTeacherOf($course);
        $toMembers = fn ($users) => $users
            ->map(fn (User $user) => new MemberResource($user, $course->owner_id, $viewerIsTeacher))
            ->values();

        // Pemilik selalu di urutan pertama daftar guru.
        $teachers = $course->teachers()->orderBy('name')->get()
            ->sortByDesc(fn (User $user) => $user->id === $course->owner_id);

        return response()->json([
            'data' => [
                'teachers' => $toMembers($teachers),
                'students' => $toMembers($course->students()->orderBy('name')->get()),
            ],
        ]);
    }

    public function destroy(Course $course, User $user): Response
    {
        abort_unless($user->isMemberOf($course), 404, 'Anggota tidak ditemukan.');
        Gate::authorize('removeMember', [$course, $user]);
        $course->ensureNotArchived();

        $this->joinCourse->removeMember($course, $user);

        return response()->noContent();
    }

    public function leave(Request $request, Course $course): Response
    {
        Gate::authorize('leave', $course);

        $this->joinCourse->removeMember($course, $request->user());

        return response()->noContent();
    }
}
