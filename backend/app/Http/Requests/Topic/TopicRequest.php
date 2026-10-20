<?php

namespace App\Http\Requests\Topic;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

/** Membuat atau mengganti nama topik. */
class TopicRequest extends FormRequest
{
    public function authorize(): bool
    {
        $course = $this->route('course') ?? $this->route('topic')->course;

        return $this->user()->can('manageClasswork', $course);
    }

    /**
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:100'],
        ];
    }
}
