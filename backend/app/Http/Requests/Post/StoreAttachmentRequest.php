<?php

namespace App\Http\Requests\Post;

use App\Services\AttachmentService;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

/** Satu lampiran: file, atau url + title. Dipakai untuk posting dan submission. */
class StoreAttachmentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'file' => ['required_without:url', 'prohibits:url', ...AttachmentService::FILE_RULES],
            'url' => ['required_without:file', 'url', 'max:2048'],
            'title' => ['nullable', 'string', 'max:255'],
        ];
    }
}
