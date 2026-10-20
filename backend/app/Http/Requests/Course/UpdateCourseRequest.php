<?php

namespace App\Http\Requests\Course;

use App\Models\Course;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateCourseRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('update', $this->route('course'));
    }

    /**
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'name' => ['sometimes', 'required', 'string', 'max:100'],
            'section' => ['sometimes', 'nullable', 'string', 'max:100'],
            'subject' => ['sometimes', 'nullable', 'string', 'max:100'],
            'room' => ['sometimes', 'nullable', 'string', 'max:50'],
            'description' => ['sometimes', 'nullable', 'string'],
            'theme' => ['sometimes', 'required', Rule::in(Course::THEMES)],
            'stream_permission' => ['sometimes', 'required', Rule::in(['all', 'comment_only', 'teacher_only'])],
            'classwork_on_stream' => ['sometimes', 'required', Rule::in(['show', 'compact', 'hide'])],
            'code_enabled' => ['sometimes', 'required', 'boolean'],
        ];
    }
}
