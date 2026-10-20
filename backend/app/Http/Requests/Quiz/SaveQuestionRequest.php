<?php

namespace App\Http\Requests\Quiz;

use App\Enums\PostType;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Validator;

/** Bentuk Pertanyaan (stretch): tanpa opsi = jawaban singkat, 2–5 opsi = pilihan ganda. */
class SaveQuestionRequest extends FormRequest
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
            'options' => ['present', 'array', 'max:5'],
            'options.*' => ['required', 'string', 'max:500'],
        ];
    }

    public function after(): array
    {
        return [
            function (Validator $validator) {
                if ($this->route('post')->type !== PostType::Question) {
                    $validator->errors()->add('options', 'Posting ini bukan pertanyaan.');
                }
                if (count($this->input('options', [])) === 1) {
                    $validator->errors()->add('options', 'Pilihan ganda butuh minimal dua opsi.');
                }
            },
        ];
    }
}
