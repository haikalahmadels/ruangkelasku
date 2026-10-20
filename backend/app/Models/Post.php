<?php

namespace App\Models;

use App\Enums\PostStatus;
use App\Enums\PostType;
use App\Enums\SubmissionStatus;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Scope;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\MorphMany;
use Illuminate\Database\Eloquent\SoftDeletes;

#[Fillable([
    'course_id', 'author_id', 'topic_id', 'type', 'title', 'body', 'points', 'due_at',
    'status', 'scheduled_at', 'published_at', 'position',
])]
class Post extends Model
{
    use SoftDeletes;

    protected function casts(): array
    {
        return [
            'type' => PostType::class,
            'status' => PostStatus::class,
            'points' => 'integer',
            'due_at' => 'datetime',
            'scheduled_at' => 'datetime',
            'published_at' => 'datetime',
        ];
    }

    public function course(): BelongsTo
    {
        return $this->belongsTo(Course::class);
    }

    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class, 'author_id');
    }

    public function topic(): BelongsTo
    {
        return $this->belongsTo(Topic::class);
    }

    public function attachments(): MorphMany
    {
        return $this->morphMany(Attachment::class, 'attachable');
    }

    public function comments(): HasMany
    {
        return $this->hasMany(PostComment::class);
    }

    public function quizQuestions(): HasMany
    {
        return $this->hasMany(QuizQuestion::class)->orderBy('position');
    }

    public function submissions(): HasMany
    {
        return $this->hasMany(Submission::class);
    }

    #[Scope]
    protected function published(Builder $query): void
    {
        $query->where('status', PostStatus::Published);
    }

    /** Relasi yang dibutuhkan PostResource: submission milik siswa, atau hitungan untuk guru. */
    #[Scope]
    protected function withViewerDetails(Builder $query, User $viewer, bool $isTeacher): void
    {
        $query->with(['author', 'topic', 'attachments'])->withCount('comments');

        $isTeacher
            ? $query->withCount(self::submissionCountQueries())
            : $query->with(['submissions' => fn ($q) => $q->where('student_id', $viewer->id)]);
    }

    public function loadViewerDetails(User $viewer, bool $isTeacher): static
    {
        $this->load(['author', 'topic', 'attachments'])->loadCount('comments');

        return $isTeacher
            ? $this->loadCount(self::submissionCountQueries())
            : $this->load(['submissions' => fn ($q) => $q->where('student_id', $viewer->id)]);
    }

    /** Empat kelompok yang jumlahnya sama dengan jumlah siswa (docs/api.md, submission_counts). */
    private static function submissionCountQueries(): array
    {
        return [
            'submissions as assigned_count' => fn ($q) => $q->where('status', SubmissionStatus::Assigned),
            'submissions as turned_in_count' => fn ($q) => $q->where('status', SubmissionStatus::TurnedIn)->whereNull('draft_grade'),
            'submissions as graded_count' => fn ($q) => $q->where('status', SubmissionStatus::TurnedIn)->whereNotNull('draft_grade'),
            'submissions as returned_count' => fn ($q) => $q->where('status', SubmissionStatus::Returned),
        ];
    }
}
