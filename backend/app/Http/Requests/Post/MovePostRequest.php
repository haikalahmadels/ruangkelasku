<?php

namespace App\Http\Requests\Post;

use App\Enums\PostType;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Validator;

class MovePostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('manageClasswork', $this->route('post')->course);
    }

    /**
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'topic_id' => [
                'present', 'nullable', 'integer',
                Rule::exists('topics', 'id')->where('course_id', $this->route('post')->course_id),
            ],
            'position' => ['required', 'integer', 'min:0'],
        ];
    }

    public function after(): array
    {
        return [
            function (Validator $validator) {
                if ($this->route('post')->type === PostType::Announcement) {
                    $validator->errors()->add('topic_id', 'Pengumuman tidak ada di Tugas Kelas.');
                }
            },
        ];
    }
}
