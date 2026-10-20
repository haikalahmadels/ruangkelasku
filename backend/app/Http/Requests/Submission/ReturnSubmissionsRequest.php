<?php

namespace App\Http\Requests\Submission;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class ReturnSubmissionsRequest extends FormRequest
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
            'submission_ids' => ['required', 'array', 'min:1'],
            'submission_ids.*' => [
                'integer', 'distinct',
                Rule::exists('submissions', 'id')->where('post_id', $this->route('post')->id),
            ],
        ];
    }
}
