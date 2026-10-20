<?php

namespace App\Models;

use App\Enums\DisplayStatus;
use App\Enums\SubmissionStatus;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\MorphMany;

#[Fillable([
    'post_id', 'student_id', 'status', 'draft_grade', 'grade', 'turned_in_at', 'returned_at',
    'graded_by', 'answer_text',
])]
class Submission extends Model
{
    protected function casts(): array
    {
        return [
            'status' => SubmissionStatus::class,
            'draft_grade' => 'decimal:2',
            'grade' => 'decimal:2',
            'turned_in_at' => 'datetime',
            'returned_at' => 'datetime',
        ];
    }

    public function post(): BelongsTo
    {
        return $this->belongsTo(Post::class);
    }

    public function student(): BelongsTo
    {
        return $this->belongsTo(User::class, 'student_id');
    }

    public function grader(): BelongsTo
    {
        return $this->belongsTo(User::class, 'graded_by');
    }

    public function attachments(): MorphMany
    {
        return $this->morphMany(Attachment::class, 'attachable');
    }

    public function quizAnswers(): HasMany
    {
        return $this->hasMany(QuizAnswer::class);
    }

    public function privateComments(): HasMany
    {
        return $this->hasMany(PrivateComment::class);
    }

    /** Pemetaan status di docs/erd.md; butuh relasi post untuk due_at. */
    protected function displayStatus(): Attribute
    {
        return Attribute::get(function (): DisplayStatus {
            $dueAt = $this->post->due_at;

            return match ($this->status) {
                SubmissionStatus::Assigned => $dueAt !== null && $dueAt->lessThanOrEqualTo(now())
                    ? DisplayStatus::Missing
                    : DisplayStatus::Assigned,
                SubmissionStatus::TurnedIn => $this->draft_grade === null
                    ? DisplayStatus::TurnedIn
                    : DisplayStatus::Graded,
                SubmissionStatus::Returned => DisplayStatus::Returned,
            };
        });
    }

    /**
     * Nilai draf hanya terlihat guru, termasuk keberadaannya: bagi siswa pemilik,
     * "Dinilai (draf)" tampil sebagai "Diserahkan" sampai dikembalikan.
     */
    public function displayStatusFor(User $viewer): DisplayStatus
    {
        $status = $this->display_status;

        return $status === DisplayStatus::Graded && $viewer->id === $this->student_id
            ? DisplayStatus::TurnedIn
            : $status;
    }

    protected function isLate(): Attribute
    {
        return Attribute::get(function (): bool {
            $dueAt = $this->post->due_at;

            return $dueAt !== null
                && $this->turned_in_at !== null
                && $this->turned_in_at->greaterThan($dueAt);
        });
    }
}
