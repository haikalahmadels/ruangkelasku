<?php

namespace App\Services;

use App\Models\Attachment;
use App\Models\Post;
use App\Models\Submission;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

class AttachmentService
{
    /** Maksimal 10 MB; tipe sesuai docs/api.md. */
    public const FILE_RULES = ['file', 'max:10240', 'mimes:pdf,doc,docx,ppt,pptx,xls,xlsx,jpg,jpeg,png,zip'];

    public function addFile(Post|Submission $attachable, User $uploader, UploadedFile $file): Attachment
    {
        return $attachable->attachments()->create([
            'uploaded_by' => $uploader->id,
            'kind' => 'file',
            'file_path' => $file->store('attachments', 'public'),
            'original_name' => $file->getClientOriginalName(),
            'mime_type' => $file->getMimeType(),
            'size_bytes' => $file->getSize(),
        ]);
    }

    public function addLink(Post|Submission $attachable, User $uploader, string $url, ?string $title = null): Attachment
    {
        return $attachable->attachments()->create([
            'uploaded_by' => $uploader->id,
            'kind' => 'link',
            'url' => $url,
            'title' => $title,
        ]);
    }

    public function delete(Attachment $attachment): void
    {
        $attachment->delete();

        if ($attachment->file_path) {
            Storage::disk('public')->delete($attachment->file_path);
        }
    }
}
