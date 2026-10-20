<?php

namespace App\Services;

use App\Exceptions\DomainActionException;
use App\Models\Post;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\DB;

class QuizService
{
    /**
     * Mengganti seluruh soal; posts.points dihitung ulang sebagai jumlah poin soal.
     *
     * @param  list<array{prompt: string, points?: int, options: list<array{label: string, is_correct: bool}>}>  $questions
     */
    public function save(Post $post, array $questions): Collection
    {
        $post->course->ensureNotArchived();

        if ($post->submissions()->whereNotNull('turned_in_at')->exists()) {
            throw new DomainActionException('quiz_locked', 'Soal tidak bisa diubah setelah ada siswa yang menyerahkan.');
        }

        return DB::transaction(function () use ($post, $questions) {
            $post->quizQuestions()->delete();

            foreach (array_values($questions) as $index => $data) {
                $question = $post->quizQuestions()->create([
                    'prompt' => $data['prompt'],
                    'points' => $data['points'] ?? 1,
                    'position' => $index,
                ]);

                foreach (array_values($data['options']) as $position => $option) {
                    $question->options()->create([
                        'label' => $option['label'],
                        'is_correct' => (bool) $option['is_correct'],
                        'position' => $position,
                    ]);
                }
            }

            $post->update(['points' => $post->quizQuestions()->sum('points')]);

            return $post->quizQuestions()->with('options')->get();
        });
    }
}
