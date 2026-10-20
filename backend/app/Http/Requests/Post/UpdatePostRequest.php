<?php

namespace App\Http\Requests\Post;

use App\Enums\PostStatus;
use App\Enums\PostType;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdatePostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('update', $this->route('post'));
    }

    /**
     * Jenis posting tidak bisa diubah, jadi aturan bergantung pada jenis posting yang ada.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $post = $this->route('post');
        $type = $post->type;
        $isTeacher = $this->user()->isTeacherOf($post->course);
        $isClasswork = in_array($type, [PostType::Assignment, PostType::Quiz, PostType::Question], true);

        return [
            'title' => [
                'sometimes', $type === PostType::Announcement ? 'nullable' : 'required', 'string', 'max:200',
            ],
            'body' => [
                'sometimes', $type === PostType::Announcement ? 'required' : 'nullable', 'string', 'max:10000',
            ],
            'topic_id' => [
                'sometimes', 'nullable', 'integer',
                $type === PostType::Announcement ? 'prohibited' : Rule::exists('topics', 'id')->where('course_id', $post->course_id),
            ],
            'points' => [
                'sometimes', 'nullable', 'integer', 'min:1', 'max:1000',
                in_array($type, [PostType::Assignment, PostType::Question], true) ? 'present' : 'prohibited',
            ],
            'due_at' => ['sometimes', 'nullable', 'date', $isClasswork ? 'present' : 'prohibited'],
            'status' => [
                'sometimes', 'required',
                Rule::in($isTeacher ? array_column(PostStatus::cases(), 'value') : [PostStatus::Published->value]),
            ],
            'scheduled_at' => ['nullable', 'required_if:status,scheduled', 'prohibited_unless:status,scheduled', 'date', 'after:now'],
        ];
    }
}
