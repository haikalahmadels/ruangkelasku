<?php

namespace App\Services;

use App\Exceptions\DomainActionException;
use App\Models\Post;
use App\Models\QuizQuestion;
use Illuminate\Support\Facades\DB;

/**
 * Pertanyaan (stretch) memakai satu baris quiz_questions (docs/erd.md, Skema untuk fitur stretch).
 * Tanpa kunci jawaban: guru menilai manual, jadi is_correct opsi selalu false.
 */
class QuestionService
{
    /** @param  list<string>  $options  kosong = jawaban singkat */
    public function save(Post $post, array $options): QuizQuestion
    {
        $post->course->ensureNotArchived();

        if ($post->submissions()->whereNotNull('turned_in_at')->exists()) {
            throw new DomainActionException('quiz_locked', 'Pertanyaan tidak bisa diubah setelah ada siswa yang menjawab.');
        }

        return DB::transaction(function () use ($post, $options) {
            $post->quizQuestions()->delete();

            $question = $post->quizQuestions()->create([
                'prompt' => (string) $post->title,
                'points' => 1,
                'position' => 0,
            ]);
            foreach (array_values($options) as $position => $label) {
                $question->options()->create(['label' => $label, 'is_correct' => false, 'position' => $position]);
            }

            return $question->load('options');
        });
    }
}
