<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Course\JoinCourseRequest;
use App\Http\Requests\Course\StoreCourseRequest;
use App\Http\Requests\Course\UpdateCourseRequest;
use App\Http\Resources\CourseResource;
use App\Models\Course;
use App\Services\CourseService;
use App\Services\JoinCourseService;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Gate;

class CourseController extends Controller
{
    public function __construct(private CourseService $courses) {}

    public function index(Request $request): AnonymousResourceCollection
    {
        $courses = $request->user()->courses()
            ->with('owner')
            ->withCount('students')
            ->when(
                $request->boolean('archived'),
                fn ($query) => $query->whereNotNull('archived_at'),
                fn ($query) => $query->whereNull('archived_at'),
            )
            ->orderByPivot('created_at', 'desc')
            ->paginate($this->perPage($request));

        return CourseResource::collection($courses);
    }

    public function store(StoreCourseRequest $request): CourseResource
    {
        $course = $this->courses->create($request->user(), $request->validated());

        return $this->resource($course);
    }

    public function show(Course $course): CourseResource
    {
        Gate::authorize('view', $course);

        return $this->resource($course);
    }

    public function update(UpdateCourseRequest $request, Course $course): CourseResource
    {
        return $this->resource($this->courses->update($course, $request->validated()));
    }

    public function resetCode(Course $course): CourseResource
    {
        Gate::authorize('update', $course);

        return $this->resource($this->courses->resetCode($course));
    }

    public function join(JoinCourseRequest $request, JoinCourseService $joinCourse): CourseResource
    {
        $course = $joinCourse->joinByCode($request->user(), $request->validated('code'));

        return $this->resource($course);
    }

    public function archive(Course $course): CourseResource
    {
        Gate::authorize('archive', $course);

        return $this->resource($this->courses->archive($course));
    }

    public function restore(Course $course): CourseResource
    {
        Gate::authorize('archive', $course);

        return $this->resource($this->courses->restore($course));
    }

    public function destroy(Course $course): Response
    {
        Gate::authorize('delete', $course);
        $this->courses->delete($course);

        return response()->noContent();
    }

    private function resource(Course $course): CourseResource
    {
        return new CourseResource($course->load('owner')->loadCount('students'));
    }
}
