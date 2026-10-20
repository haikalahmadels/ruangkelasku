<?php

namespace App\Http\Resources;

use App\Models\Submission;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** Muat lewat Post::withViewerDetails() atau loadViewerDetails(). */
class PostResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $hasSubmissions = $this->type->requiresSubmissions();

        return [
            'id' => $this->id,
            'course_id' => $this->course_id,
            // Untuk daftar lintas kelas (To-do, Perlu diperiksa).
            'course' => $this->whenLoaded('course', fn () => [
                'id' => $this->course->id,
                'name' => $this->course->name,
                'theme' => $this->course->theme,
            ]),
            'type' => $this->type,
            'title' => $this->title,
            'body' => $this->body,
            'topic' => $this->whenLoaded('topic', fn () => $this->topic
                ? ['id' => $this->topic->id, 'name' => $this->topic->name]
                : null),
            'points' => $this->points,
            'due_at' => $this->due_at?->toIso8601ZuluString(),
            'status' => $this->status,
            'scheduled_at' => $this->scheduled_at?->toIso8601ZuluString(),
            'published_at' => $this->published_at?->toIso8601ZuluString(),
            'author' => new UserSummaryResource($this->whenLoaded('author')),
            'attachments' => AttachmentResource::collection($this->whenLoaded('attachments')),
            'comment_count' => $this->whenCounted('comments'),
            // Siswa: submission miliknya. Guru: hitungan per status.
            'my_submission' => $this->when(
                $hasSubmissions && $this->relationLoaded('submissions'),
                fn () => $this->mySubmission($this->submissions->first(), $request),
            ),
            'submission_counts' => $this->when(
                $hasSubmissions && isset($this->assigned_count),
                fn () => [
                    'assigned' => $this->assigned_count,
                    'turned_in' => $this->turned_in_count,
                    'graded' => $this->graded_count,
                    'returned' => $this->returned_count,
                ],
            ),
        ];
    }

    private function mySubmission(?Submission $submission, Request $request): ?array
    {
        if ($submission === null) {
            return null;
        }
        $submission->setRelation('post', $this->resource);

        return [
            'id' => $submission->id,
            'status' => $submission->status,
            'display_status' => $submission->displayStatusFor($request->user()),
            'is_late' => $submission->is_late,
            // Nilai draf tidak pernah dikirim ke siswa.
            'grade' => $submission->grade === null ? null : (float) $submission->grade,
        ];
    }
}
