<?php

namespace App\Http\Requests\Quiz;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

/** Soal yang tidak dikirim atau option_id null dihitung tidak dijawab. */
class SubmitQuizRequest extends FormRequest
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
            'answers' => ['present', 'array'],
            'answers.*.question_id' => ['required', 'integer', 'distinct'],
            'answers.*.option_id' => ['nullable', 'integer'],
        ];
    }

    /** @return array<int, ?int> question_id => option_id */
    public function answerMap(): array
    {
        return collect($this->validated('answers'))
            ->mapWithKeys(fn ($answer) => [(int) $answer['question_id'] => $answer['option_id'] ?? null])
            ->all();
    }
}
