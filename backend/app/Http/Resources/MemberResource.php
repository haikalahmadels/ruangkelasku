<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** Pengguna di daftar Anggota; email hanya terlihat oleh guru kelas. */
class MemberResource extends JsonResource
{
    public function __construct($resource, private int $ownerId = 0, private bool $viewerIsTeacher = false)
    {
        parent::__construct($resource);
    }

    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->when($this->viewerIsTeacher, $this->email),
            'avatar_url' => $this->avatar_path ? asset('storage/'.$this->avatar_path) : null,
            'is_owner' => $this->id === $this->ownerId,
        ];
    }
}
