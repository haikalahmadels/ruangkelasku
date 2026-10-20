<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\PostType;
use App\Enums\SubmissionStatus;
use App\Http\Controllers\Controller;
use App\Http\Requests\Post\MovePostRequest;
use App\Http\Requests\Post\StorePostRequest;
use App\Http\Requests\Post\UpdatePostRequest;
use App\Http\Resources\PostResource;
use App\Http\Resources\TopicResource;
use App\Models\Course;
use App\Models\Post;
use App\Services\PostService;
use App\Services\PublishPostService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;

class PostController extends Controller
{
    public function __construct(private PostService $posts) {}

    /** Posting terbit, terbaru di atas; item Tugas Kelas mengikuti classwork_on_stream. */
    public function stream(Request $request, Course $course): AnonymousResourceCollection
    {
        Gate::authorize('view', $course);
        $user = $request->user();

        $posts = $course->posts()
            ->published()
            ->when(
                $course->classwork_on_stream === 'hide',
                fn ($query) => $query->where('type', PostType::Announcement),
            )
            ->withViewerDetails($user, $user->isTeacherOf($course))
            ->orderByDesc('published_at')
            ->orderByDesc('id')
            ->paginate($this->perPage($request));

        return PostResource::collection($posts);
    }

    public function classwork(Request $request, Course $course): JsonResponse
    {
        Gate::authorize('view', $course);
        $request->validate(['type' => ['nullable', Rule::enum(PostType::class)->except([PostType::Announcement])]]);
        $user = $request->user();
        $isTeacher = $user->isTeacherOf($course);

        $posts = $course->posts()
            ->where('type', '!=', PostType::Announcement)
            ->when(! $isTeacher, fn ($query) => $query->published())
            ->when($request->filled('type'), fn ($query) => $query->where('type', $request->input('type')))
            ->withViewerDetails($user, $isTeacher)
            ->orderBy('position')
            ->get()
            ->groupBy(fn (Post $post) => $post->topic_id ?? 'none');

        return response()->json([
            'data' => [
                'topics' => $course->topics()->get()->map(fn ($topic) => [
                    'topic' => new TopicResource($topic),
                    'posts' => PostResource::collection($posts->get($topic->id, collect())),
                ]),
                'no_topic' => PostResource::collection($posts->get('none', collect())),
            ],
        ]);
    }

    /** Kartu "Mendatang": maksimal 3 tenggat terdekat; untuk siswa hanya yang belum diserahkan. */
    public function upcoming(Request $request, Course $course): AnonymousResourceCollection
    {
        Gate::authorize('view', $course);
        $user = $request->user();
        $isTeacher = $user->isTeacherOf($course);

        $posts = $course->posts()
            ->published()
            ->whereIn('type', [PostType::Assignment, PostType::Quiz, PostType::Question])
            ->where('due_at', '>', now())
            ->when(! $isTeacher, fn ($query) => $query->whereHas(
                'submissions',
                fn ($q) => $q->where('student_id', $user->id)->where('status', SubmissionStatus::Assigned),
            ))
            ->withViewerDetails($user, $isTeacher)
            ->orderBy('due_at')
            ->limit(3)
            ->get();

        return PostResource::collection($posts);
    }

    public function store(StorePostRequest $request, Course $course): PostResource
    {
        $post = $this->posts->create(
            $course,
            $request->user(),
            $request->safe()->except(['files', 'links']),
            $request->file('files', []),
            $request->validated('links', []),
        );

        return $this->resource($request, $post);
    }

    public function show(Request $request, Post $post): PostResource
    {
        Gate::authorize('view', $post);

        return $this->resource($request, $post);
    }

    public function update(UpdatePostRequest $request, Post $post): PostResource
    {
        return $this->resource($request, $this->posts->update($post, $request->validated()));
    }

    public function destroy(Post $post): Response
    {
        Gate::authorize('delete', $post);
        $this->posts->delete($post);

        return response()->noContent();
    }

    public function publish(Request $request, Post $post, PublishPostService $publisher): PostResource
    {
        Gate::authorize('publish', $post);
        $post->course->ensureNotArchived();

        return $this->resource($request, $publisher->publish($post));
    }

    public function move(MovePostRequest $request, Post $post): Response
    {
        $this->posts->move($post, $request->validated('topic_id'), $request->validated('position'));

        return response()->noContent();
    }

    private function resource(Request $request, Post $post): PostResource
    {
        $user = $request->user();

        return new PostResource($post->loadViewerDetails($user, $user->isTeacherOf($post->course)));
    }
}
