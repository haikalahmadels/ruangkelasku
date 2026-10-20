<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\PostType;
use App\Http\Controllers\Controller;
use App\Http\Resources\PostResource;
use App\Http\Resources\UserSummaryResource;
use App\Models\Course;
use App\Models\Post;
use App\Models\User;
use App\Services\GradeExportService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;

class GradeController extends Controller
{
    public function __construct(private GradeExportService $grades) {}

    public function index(Course $course): JsonResponse
    {
        Gate::authorize('manageClasswork', $course);
        ['posts' => $posts, 'students' => $students, 'submissions' => $submissions] = $this->grades->grid($course);

        return response()->json([
            'data' => [
                'posts' => $posts->map(fn (Post $post) => [
                    'id' => $post->id,
                    'type' => $post->type,
                    'title' => $post->title,
                    'points' => $post->points,
                    'due_at' => $post->due_at?->toIso8601ZuluString(),
                ])->values(),
                'students' => $students->map(fn (User $student) => [
                    'user' => new UserSummaryResource($student),
                    'grades' => (object) $posts->mapWithKeys(function (Post $post) use ($student, $submissions) {
                        $submission = $submissions->get($student->id.':'.$post->id);

                        return [$post->id => $submission ? [
                            'display_status' => $submission->display_status,
                            'grade' => $submission->grade === null ? null : (float) $submission->grade,
                            'draft_grade' => $submission->draft_grade === null ? null : (float) $submission->draft_grade,
                        ] : null];
                    })->all(),
                ])->values(),
            ],
        ]);
    }

    public function export(Course $course): Response
    {
        Gate::authorize('manageClasswork', $course);

        return response($this->grades->csv($course), 200, [
            'Content-Type' => 'text/csv; charset=UTF-8',
            'Content-Disposition' => 'attachment; filename="nilai-'.$course->code.'.csv"',
        ]);
    }

    /** Layar "Tugas Anda": semua tugas siswa di kelas ini. */
    public function myWork(Request $request, Course $course): AnonymousResourceCollection
    {
        $user = $request->user();
        abort_unless($user->isStudentOf($course), 403);

        $posts = $course->posts()
            ->published()
            ->whereIn('type', [PostType::Assignment, PostType::Quiz, PostType::Question])
            ->withViewerDetails($user, false)
            ->orderByRaw('due_at IS NULL, due_at DESC')
            ->get();

        return PostResource::collection($posts);
    }
}
