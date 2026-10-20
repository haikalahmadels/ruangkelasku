<?php

namespace App\Http\Requests\Submission;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class GradeSubmissionRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('grade', $this->route('submission'));
    }

    /**
     * Batas atas (posts.points) diperiksa di SubmissionService.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'draft_grade' => ['present', 'nullable', 'numeric', 'min:0', 'decimal:0,2'],
        ];
    }
}
