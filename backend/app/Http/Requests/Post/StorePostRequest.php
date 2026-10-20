<?php

namespace App\Http\Requests\Post;

use App\Enums\PostStatus;
use App\Enums\PostType;
use App\Models\Post;
use App\Services\AttachmentService;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StorePostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('create', [
            Post::class,
            $this->route('course'),
            PostType::tryFrom((string) $this->input('type')),
        ]);
    }

    /**
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $course = $this->route('course');
        // Siswa hanya bisa langsung memposting pengumuman, tanpa draf atau jadwal.
        $statuses = $this->user()->isTeacherOf($course)
            ? array_column(PostStatus::cases(), 'value')
            : [PostStatus::Published->value];

        return [
            'type' => ['required', Rule::enum(PostType::class)],
            'title' => ['nullable', 'required_unless:type,announcement', 'string', 'max:200'],
            'body' => ['nullable', 'required_if:type,announcement', 'string', 'max:10000'],
            'topic_id' => [
                'nullable', 'integer', 'prohibited_if:type,announcement',
                Rule::exists('topics', 'id')->where('course_id', $course->id),
            ],
            'points' => ['nullable', 'integer', 'min:1', 'max:1000', 'prohibited_unless:type,assignment,question'],
            'due_at' => ['nullable', 'date', 'prohibited_unless:type,assignment,quiz,question'],
            'status' => ['required', Rule::in($statuses)],
            'scheduled_at' => ['nullable', 'required_if:status,scheduled', 'prohibited_unless:status,scheduled', 'date', 'after:now'],
            'files' => ['array', 'max:10'],
            'files.*' => AttachmentService::FILE_RULES,
            'links' => ['array', 'max:10'],
            'links.*' => ['url', 'max:2048'],
        ];
    }
}
