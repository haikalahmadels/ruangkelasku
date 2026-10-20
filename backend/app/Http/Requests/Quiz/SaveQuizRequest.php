<?php

namespace App\Http\Requests\Quiz;

use App\Enums\PostType;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Validator;

class SaveQuizRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('manageClasswork', $this->route('post')->course);
    }

    /**
     * 1–50 soal, 2–5 opsi per soal (docs/api.md).
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'questions' => ['required', 'array', 'min:1', 'max:50'],
            'questions.*.prompt' => ['required', 'string', 'max:5000'],
            'questions.*.points' => ['nullable', 'integer', 'min:1', 'max:100'],
            'questions.*.options' => ['required', 'array', 'min:2', 'max:5'],
            'questions.*.options.*.label' => ['required', 'string', 'max:500'],
            'questions.*.options.*.is_correct' => ['required', 'boolean'],
        ];
    }

    public function after(): array
    {
        return [
            function (Validator $validator) {
                if ($this->route('post')->type !== PostType::Quiz) {
                    $validator->errors()->add('questions', 'Posting ini bukan kuis.');

                    return;
                }

                // Tepat satu jawaban benar per soal.
                foreach ($this->input('questions', []) as $index => $question) {
                    $correct = collect($question['options'] ?? [])->filter(
                        fn ($option) => filter_var($option['is_correct'] ?? false, FILTER_VALIDATE_BOOLEAN),
                    )->count();

                    if ($correct !== 1) {
                        $validator->errors()->add("questions.{$index}.options", 'Pilih tepat satu jawaban benar.');
                    }
                }
            },
        ];
    }
}
