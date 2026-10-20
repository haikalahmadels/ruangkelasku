<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class InvitationResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'course_id' => $this->course_id,
            'email' => $this->email,
            'role' => $this->role,
            'status' => $this->status,
            'invited_by' => new UserSummaryResource($this->whenLoaded('inviter')),
            // Ringkasan kelas untuk kartu undangan di beranda penerima.
            'course' => $this->whenLoaded('course', fn () => [
                'id' => $this->course->id,
                'name' => $this->course->name,
                'section' => $this->course->section,
                'theme' => $this->course->theme,
                'owner' => new UserSummaryResource($this->course->owner),
            ]),
            'created_at' => $this->created_at?->toIso8601ZuluString(),
        ];
    }
}
