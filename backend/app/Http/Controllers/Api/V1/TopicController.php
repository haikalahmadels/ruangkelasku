<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Topic\ReorderTopicsRequest;
use App\Http\Requests\Topic\TopicRequest;
use App\Http\Resources\TopicResource;
use App\Models\Course;
use App\Models\Topic;
use App\Services\TopicService;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;

class TopicController extends Controller
{
    public function __construct(private TopicService $topics) {}

    public function index(Course $course): AnonymousResourceCollection
    {
        Gate::authorize('view', $course);

        return TopicResource::collection($course->topics()->get());
    }

    public function store(TopicRequest $request, Course $course): TopicResource
    {
        return new TopicResource($this->topics->create($course, $request->validated('name')));
    }

    public function update(TopicRequest $request, Topic $topic): TopicResource
    {
        return new TopicResource($this->topics->rename($topic, $request->validated('name')));
    }

    public function destroy(Topic $topic): Response
    {
        Gate::authorize('manageClasswork', $topic->course);
        $this->topics->delete($topic);

        return response()->noContent();
    }

    public function reorder(ReorderTopicsRequest $request, Course $course): Response
    {
        $this->topics->reorder($course, $request->validated('topic_ids'));

        return response()->noContent();
    }
}
