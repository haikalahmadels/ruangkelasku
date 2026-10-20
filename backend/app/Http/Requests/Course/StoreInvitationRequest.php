<?php

namespace App\Http\Requests\Course;

use App\Enums\CourseRole;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreInvitationRequest extends FormRequest
{
    /** Guru boleh mengundang siswa; hanya pemilik yang boleh mengundang co-teacher. */
    public function authorize(): bool
    {
        $course = $this->route('course');
        $ability = $this->input('role') === CourseRole::Teacher->value ? 'inviteTeacher' : 'update';

        return $this->user()->can($ability, $course);
    }

    /**
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'email' => ['required', 'string', 'email', 'max:191'],
            'role' => ['required', Rule::enum(CourseRole::class)],
        ];
    }
}
