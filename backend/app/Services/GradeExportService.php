<?php

namespace App\Services;

use App\Enums\PostType;
use App\Models\Course;
use App\Models\Post;
use App\Models\Submission;
use App\Models\User;
use Illuminate\Support\Collection;

/** Grid Tab Nilai (siswa × tugas) dan ekspor CSV-nya. */
class GradeExportService
{
    /** @return array{posts: Collection<int, Post>, students: Collection<int, User>, submissions: Collection<string, Submission>} */
    public function grid(Course $course): array
    {
        $posts = $course->posts()
            ->published()
            ->whereIn('type', [PostType::Assignment, PostType::Quiz, PostType::Question])
            ->orderByDesc('published_at')
            ->orderByDesc('id')
            ->get();

        $students = $course->students()->orderBy('name')->get();

        $submissions = Submission::whereIn('post_id', $posts->pluck('id'))
            ->get()
            ->each(fn (Submission $submission) => $submission->setRelation('post', $posts->firstWhere('id', $submission->post_id)))
            ->keyBy(fn (Submission $submission) => $submission->student_id.':'.$submission->post_id);

        return compact('posts', 'students', 'submissions');
    }

    /** Satu baris per siswa, satu kolom per tugas; nilai draf dipakai bila belum dikembalikan. */
    public function csv(Course $course): string
    {
        ['posts' => $posts, 'students' => $students, 'submissions' => $submissions] = $this->grid($course);

        $rows = [
            ['Nama', 'Email', ...$posts->map(fn (Post $post) => $post->title)],
            ['Poin maksimal', '', ...$posts->map(fn (Post $post) => $post->points ?? '')],
        ];

        foreach ($students as $student) {
            $rows[] = [
                $student->name,
                $student->email,
                ...$posts->map(function (Post $post) use ($student, $submissions) {
                    $submission = $submissions->get($student->id.':'.$post->id);
                    $value = $submission?->grade ?? $submission?->draft_grade;

                    return $value === null ? '' : rtrim(rtrim($value, '0'), '.');
                }),
            ];
        }

        $handle = fopen('php://temp', 'r+');
        fwrite($handle, "\xEF\xBB\xBF"); // BOM agar Excel membaca UTF-8
        foreach ($rows as $row) {
            fputcsv($handle, $row, escape: '');
        }
        rewind($handle);
        $csv = stream_get_contents($handle);
        fclose($handle);

        return $csv;
    }
}
