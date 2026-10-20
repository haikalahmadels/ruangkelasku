<?php

namespace App\Http\Requests\Quiz;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

/** Jawaban Pertanyaan: `answer_text` untuk jawaban singkat, `option_id` untuk pilihan ganda. */
class AnswerQuestionRequest extends FormRequest
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
            'answer_text' => ['nullable', 'required_without:option_id', 'string', 'max:10000'],
            'option_id' => ['nullable', 'required_without:answer_text', 'integer'],
        ];
    }
}
