<?php

namespace App\Models;

use App\Enums\CourseRole;
use App\Exceptions\DomainActionException;
use Database\Factories\CourseFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;

#[Fillable([
    'owner_id', 'name', 'section', 'subject', 'room', 'description', 'code', 'code_enabled',
    'theme', 'stream_permission', 'classwork_on_stream', 'archived_at',
])]
class Course extends Model
{
    /** @use HasFactory<CourseFactory> */
    use HasFactory, SoftDeletes;

    /** Kunci tema header kelas; lihat docs/design.md bagian Tema kelas. */
    public const THEMES = ['forest', 'ocean', 'sunset', 'grape', 'rose', 'lagoon', 'mango', 'slate'];

    protected function casts(): array
    {
        return [
            'code_enabled' => 'boolean',
            'archived_at' => 'datetime',
        ];
    }

    public function owner(): BelongsTo
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    public function members(): HasMany
    {
        return $this->hasMany(CourseMember::class);
    }

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'course_members')
            ->withPivot('role')
            ->withTimestamps();
    }

    public function teachers(): BelongsToMany
    {
        return $this->users()->wherePivot('role', CourseRole::Teacher->value);
    }

    public function students(): BelongsToMany
    {
        return $this->users()->wherePivot('role', CourseRole::Student->value);
    }

    public function invitations(): HasMany
    {
        return $this->hasMany(Invitation::class);
    }

    public function topics(): HasMany
    {
        return $this->hasMany(Topic::class)->orderBy('position');
    }

    public function posts(): HasMany
    {
        return $this->hasMany(Post::class);
    }

    public function isArchived(): bool
    {
        return $this->archived_at !== null;
    }

    /** Kelas terarsip bersifat baca-saja. */
    public function ensureNotArchived(): void
    {
        if ($this->isArchived()) {
            throw new DomainActionException('course_archived', 'Kelas ini sudah diarsipkan.');
        }
    }

    /** Kode 7 karakter huruf kecil dan angka, seperti Google Classroom. */
    public static function generateUniqueCode(): string
    {
        do {
            $code = Str::lower(Str::random(7));
        } while (static::withTrashed()->where('code', $code)->exists());

        return $code;
    }
}
