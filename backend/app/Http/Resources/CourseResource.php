<?php

namespace App\Http\Resources;

use App\Enums\CourseRole;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CourseResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $user = $request->user();
        // Daftar kelas dimuat lewat $user->courses() sehingga peran sudah ada di pivot.
        $role = $this->pivot?->role ?? $user->roleIn($this->resource)?->value;

        return [
            'id' => $this->id,
            'name' => $this->name,
            'section' => $this->section,
            'subject' => $this->subject,
            'room' => $this->room,
            'description' => $this->description,
            'theme' => $this->theme,
            'code' => $this->when($role === CourseRole::Teacher->value, $this->code),
            'code_enabled' => $this->code_enabled,
            'stream_permission' => $this->stream_permission,
            'classwork_on_stream' => $this->classwork_on_stream,
            'is_archived' => $this->isArchived(),
            'my_role' => $role,
            'is_owner' => $this->owner_id === $user->id,
            'owner' => new UserSummaryResource($this->whenLoaded('owner')),
            'student_count' => $this->whenCounted('students'),
            'created_at' => $this->created_at?->toIso8601ZuluString(),
        ];
    }
}
