<?php

namespace App\Http\Requests\Topic;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class ReorderTopicsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('manageClasswork', $this->route('course'));
    }

    /**
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'topic_ids' => ['present', 'array'],
            'topic_ids.*' => ['integer', 'distinct'],
        ];
    }
}
