<?php

namespace App\Services;

use App\Enums\PostType;
use App\Enums\SubmissionStatus;
use App\Exceptions\DomainActionException;
use App\Models\Attachment;
use App\Models\Post;
use App\Models\Submission;
use App\Models\User;
use App\Notifications\SubmissionReturned;
use App\Notifications\SubmissionTurnedIn;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Notification;
use Illuminate\Validation\ValidationException;

/** Transisi status submission; lihat docs/erd.md bagian "Transisi yang diizinkan". */
class SubmissionService
{
    public function __construct(private AttachmentService $attachments) {}

    public function addFile(Submission $submission, User $student, UploadedFile $file): Attachment
    {
        $this->ensureEditable($submission);

        return $this->attachments->addFile($submission, $student, $file);
    }

    public function addLink(Submission $submission, User $student, string $url, ?string $title): Attachment
    {
        $this->ensureEditable($submission);

        return $this->attachments->addLink($submission, $student, $url, $title);
    }

    public function removeAttachment(Submission $submission, Attachment $attachment): void
    {
        $this->ensureEditable($submission);
        $this->attachments->delete($attachment);
    }

    /** assigned atau returned → turned_in. Kuis lewat submitQuiz(), Pertanyaan lewat answerQuestion(). */
    public function turnIn(Submission $submission): Submission
    {
        $this->ensureEditable($submission);

        if ($submission->post->type === PostType::Quiz) {
            throw ValidationException::withMessages([
                'answers' => ['Kuis diserahkan bersama jawabannya.'],
            ]);
        }
        if ($submission->post->type === PostType::Question) {
            throw ValidationException::withMessages([
                'answer_text' => ['Pertanyaan diserahkan bersama jawabannya.'],
            ]);
        }

        $submission->update([
            'status' => SubmissionStatus::TurnedIn,
            'turned_in_at' => now(),
        ]);
        $this->notifyTeachers($submission);

        return $submission;
    }

    /** turned_in → assigned; tidak berlaku untuk kuis. */
    public function unsubmit(Submission $submission): Submission
    {
        $submission->post->course->ensureNotArchived();

        if ($submission->post->type === PostType::Quiz) {
            throw new DomainActionException('quiz_cannot_unsubmit', 'Penyerahan kuis tidak bisa dibatalkan.');
        }

        if ($submission->status === SubmissionStatus::TurnedIn) {
            $submission->update([
                'status' => SubmissionStatus::Assigned,
                'turned_in_at' => null,
            ]);
        }

        return $submission;
    }

    /**
     * Menilai otomatis dan menyerahkan dalam satu langkah; hasilnya masuk draft_grade.
     *
     * @param  array<int, ?int>  $answers  quiz_question_id => quiz_option_id
     */
    public function submitQuiz(Submission $submission, array $answers): Submission
    {
        $submission->post->course->ensureNotArchived();

        if ($submission->status !== SubmissionStatus::Assigned) {
            throw new DomainActionException('already_turned_in', 'Kuis ini sudah diserahkan.');
        }

        DB::transaction(function () use ($submission, $answers) {
            $score = 0;

            foreach ($submission->post->quizQuestions()->with('options')->get() as $question) {
                $option = $question->options->firstWhere('id', $answers[$question->id] ?? null);
                $isCorrect = (bool) $option?->is_correct;

                $submission->quizAnswers()->create([
                    'quiz_question_id' => $question->id,
                    'quiz_option_id' => $option?->id,
                    'is_correct' => $isCorrect,
                ]);
                $score += $isCorrect ? $question->points : 0;
            }

            $submission->update([
                'status' => SubmissionStatus::TurnedIn,
                'turned_in_at' => now(),
                'draft_grade' => $score,
            ]);
        });

        $this->notifyTeachers($submission);

        return $submission;
    }

    /**
     * Menjawab Pertanyaan (stretch) sekaligus menyerahkan. Jawaban lama diganti; boleh
     * menjawab ulang setelah membatalkan penyerahan atau setelah dikembalikan.
     */
    public function answerQuestion(Submission $submission, ?string $answerText, ?int $optionId): Submission
    {
        $this->ensureEditable($submission);
        $question = $submission->post->quizQuestions()->with('options')->firstOrFail();
        $isChoice = $question->options->isNotEmpty();

        $option = $isChoice ? $question->options->firstWhere('id', $optionId) : null;
        if ($isChoice && $option === null) {
            throw ValidationException::withMessages(['option_id' => ['Pilih salah satu opsi.']]);
        }
        $answerText = $isChoice ? null : trim((string) $answerText);
        if (! $isChoice && $answerText === '') {
            throw ValidationException::withMessages(['answer_text' => ['Tulis jawaban Anda.']]);
        }

        DB::transaction(function () use ($submission, $question, $option, $answerText) {
            $submission->quizAnswers()->delete();
            if ($option !== null) {
                $submission->quizAnswers()->create([
                    'quiz_question_id' => $question->id,
                    'quiz_option_id' => $option->id,
                    'is_correct' => false,
                ]);
            }

            $submission->update([
                'answer_text' => $answerText,
                'status' => SubmissionStatus::TurnedIn,
                'turned_in_at' => now(),
            ]);
        });

        $this->notifyTeachers($submission);

        return $submission;
    }

    public function grade(Submission $submission, int|float|string|null $draftGrade, User $teacher): Submission
    {
        $post = $submission->post;
        $post->course->ensureNotArchived();

        if ($draftGrade !== null && ($post->points === null || $draftGrade > $post->points)) {
            throw ValidationException::withMessages([
                'draft_grade' => [$post->points === null
                    ? 'Tugas ini tidak memiliki poin.'
                    : "Nilai maksimal {$post->points}."],
            ]);
        }

        $submission->update([
            'draft_grade' => $draftGrade,
            'graded_by' => $teacher->id,
        ]);

        return $submission;
    }

    /**
     * Mengembalikan satu atau banyak submission; draft_grade disalin ke grade.
     *
     * @param  list<int>  $submissionIds
     */
    public function return(Post $post, array $submissionIds): Collection
    {
        $post->course->ensureNotArchived();

        $submissions = $post->submissions()->whereKey($submissionIds)->with('student')->get();

        DB::transaction(function () use ($submissions) {
            foreach ($submissions as $submission) {
                $submission->update([
                    'status' => SubmissionStatus::Returned,
                    'grade' => $submission->draft_grade,
                    'returned_at' => now(),
                ]);
            }
        });

        foreach ($submissions as $submission) {
            $submission->setRelation('post', $post);
            $submission->student->notify(new SubmissionReturned($submission));
        }

        return $submissions;
    }

    /** Lampiran hanya bisa diubah sebelum diserahkan (atau setelah dikembalikan). */
    private function ensureEditable(Submission $submission): void
    {
        $submission->post->course->ensureNotArchived();

        if ($submission->status === SubmissionStatus::TurnedIn) {
            throw new DomainActionException('already_turned_in', 'Tugas sudah diserahkan. Batalkan penyerahan untuk mengubahnya.');
        }
    }

    private function notifyTeachers(Submission $submission): void
    {
        Notification::send(
            $submission->post->course->teachers()->get(),
            new SubmissionTurnedIn($submission->loadMissing('student')),
        );
    }
}
