<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            // Memakai host request agar emulator mendapat 10.0.2.2 dan web mendapat localhost.
            'avatar_url' => $this->avatar_path ? asset('storage/'.$this->avatar_path) : null,
        ];
    }
}
