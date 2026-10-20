<?php

namespace App\Models;

use App\Enums\CourseRole;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable(['course_id', 'invited_by', 'email', 'role', 'status'])]
class Invitation extends Model
{
    protected function casts(): array
    {
        return [
            'role' => CourseRole::class,
        ];
    }

    public function course(): BelongsTo
    {
        return $this->belongsTo(Course::class);
    }

    public function inviter(): BelongsTo
    {
        return $this->belongsTo(User::class, 'invited_by');
    }
}
