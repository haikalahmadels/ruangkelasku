<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class AttachmentResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $isFile = $this->kind === 'file';

        return [
            'id' => $this->id,
            'kind' => $this->kind,
            'original_name' => $this->original_name,
            'mime_type' => $this->mime_type,
            'size_bytes' => $this->size_bytes,
            'title' => $this->title,
            // File memakai host request agar emulator mendapat 10.0.2.2.
            'url' => $isFile ? asset('storage/'.$this->file_path) : $this->url,
        ];
    }
}
