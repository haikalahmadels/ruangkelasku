<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\PostType;
use App\Enums\SubmissionStatus;
use App\Http\Controllers\Controller;
use App\Http\Resources\PostResource;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Validation\Rule;

/** To-do lintas kelas; kelas terarsip tidak ikut. */
class TodoController extends Controller
{
    private const WORK_TYPES = [PostType::Assignment, PostType::Quiz, PostType::Question];

    /** Siswa: ditugaskan, terlewat, atau selesai. */
    public function todo(Request $request): AnonymousResourceCollection
    {
        $request->validate([
            'tab' => ['nullable', Rule::in(['assigned', 'missing', 'done'])],
            'course_id' => ['nullable', 'integer'],
        ]);
        $user = $request->user();
        $tab = $request->input('tab', 'assigned');
        $now = now();

        $posts = $this->baseQuery($request)
            ->whereHas('submissions', fn ($query) => $query
                ->where('student_id', $user->id)
                ->when(
                    $tab === 'done',
                    fn ($q) => $q->whereIn('status', [SubmissionStatus::TurnedIn, SubmissionStatus::Returned]),
                    fn ($q) => $q->where('status', SubmissionStatus::Assigned),
                ))
            ->when($tab === 'assigned', fn ($query) => $query
                ->where(fn ($q) => $q->whereNull('due_at')->orWhere('due_at', '>', $now))
                ->orderByRaw('due_at IS NULL, due_at ASC'))
            ->when($tab === 'missing', fn ($query) => $query
                ->where('due_at', '<=', $now)
                ->orderByDesc('due_at'))
            ->when($tab === 'done', fn ($query) => $query->orderByDesc('published_at'))
            ->withViewerDetails($user, false)
            ->paginate($this->perPage($request));

        return PostResource::collection($posts);
    }

    /** Guru: tugas di kelas tempat ia mengajar, dengan hitungan per status. */
    public function toReview(Request $request): AnonymousResourceCollection
    {
        $request->validate(['course_id' => ['nullable', 'integer']]);
        $user = $request->user();

        $posts = $this->baseQuery($request)
            ->whereHas('course.members', fn ($query) => $query->where('user_id', $user->id)->where('role', 'teacher'))
            ->withViewerDetails($user, true)
            ->orderByDesc('published_at')
            ->paginate($this->perPage($request));

        return PostResource::collection($posts);
    }

    private function baseQuery(Request $request)
    {
        return Post::query()
            ->published()
            ->whereIn('type', self::WORK_TYPES)
            ->whereHas('course', fn ($query) => $query->whereNull('archived_at'))
            ->when($request->filled('course_id'), fn ($query) => $query->where('course_id', $request->integer('course_id')))
            ->with('course');
    }
}
