<?php

namespace Database\Seeders;

use App\Enums\CourseRole;
use App\Enums\PostStatus;
use App\Enums\PostType;
use App\Enums\SubmissionStatus;
use App\Models\Course;
use App\Models\Invitation;
use App\Models\Post;
use App\Models\PrivateComment;
use App\Models\QuizAnswer;
use App\Models\Submission;
use App\Models\Topic;
use App\Models\User;
use App\Notifications\CourseInvitationReceived;
use App\Notifications\PrivateCommentPosted;
use App\Notifications\SubmissionReturned;
use App\Notifications\SubmissionTurnedIn;
use App\Services\PublishPostService;
use App\Services\QuestionService;
use Illuminate\Database\Seeder;
use Illuminate\Support\Carbon;

/**
 * 1 guru, 5 siswa, 2 kelas, serta tugas dan kuis dengan semua status submission.
 * Semua akun memakai password "password".
 */
class DemoSeeder extends Seeder
{
    private User $teacher;

    /** @var array<string, int> posisi berikutnya per "course:topic" */
    private array $positions = [];

    public function __construct(private PublishPostService $publisher) {}

    public function run(): void
    {
        $this->teacher = $this->user('Rina Wulandari', 'rina@ruangkelasku.test');
        $dimas = $this->user('Dimas Pratama', 'dimas@ruangkelasku.test');
        $sari = $this->user('Sari Lestari', 'sari@ruangkelasku.test');
        $budi = $this->user('Budi Santoso', 'budi@ruangkelasku.test');
        $ayu = $this->user('Ayu Kartika', 'ayu@ruangkelasku.test');
        $rizky = $this->user('Rizky Ramadhan', 'rizky@ruangkelasku.test');

        $this->seedMath([$dimas, $sari, $budi, $ayu, $rizky]);
        $this->seedIndonesian([$sari, $budi, $ayu, $rizky], invitee: $dimas);
        $this->seedNotifications($dimas);
    }

    /**
     * Status di atas diisi langsung, jadi notifikasinya dikirim di sini. Notifikasi
     * "posting baru" lama ditandai sudah dibaca agar lonceng menunjukkan yang penting saja.
     */
    private function seedNotifications(User $dimas): void
    {
        User::query()->each(fn (User $user) => $user->unreadNotifications()->update(['read_at' => now()]));

        $returned = Submission::where('student_id', $dimas->id)
            ->where('status', SubmissionStatus::Returned)
            ->with('post')
            ->firstOrFail();
        $dimas->notify(new SubmissionReturned($returned));
        $dimas->notify(new CourseInvitationReceived(Invitation::with(['course', 'inviter'])->firstOrFail()));

        $turnedIn = Submission::where('student_id', $dimas->id)
            ->where('status', SubmissionStatus::TurnedIn)
            ->whereNull('draft_grade')
            ->with(['post', 'student'])
            ->firstOrFail();
        $this->teacher->notify(new SubmissionTurnedIn($turnedIn));
        $this->teacher->notify(new PrivateCommentPosted(
            PrivateComment::where('user_id', $dimas->id)->with(['user', 'submission.post'])->firstOrFail(),
        ));
    }

    /** @param  list<User>  $students  [dimas, sari, budi, ayu, rizky] */
    private function seedMath(array $students): void
    {
        [$dimas, $sari, $budi, $ayu, $rizky] = $students;

        $course = $this->course([
            'name' => 'Matematika Wajib',
            'section' => 'XI IPA 2',
            'subject' => 'Matematika',
            'room' => 'R. 204',
            'theme' => 'ocean',
            'code' => 'mtk11a2',
        ], $students);

        $limit = $this->topic($course, 'Bab 1: Limit Fungsi');
        $derivative = $this->topic($course, 'Bab 2: Turunan');

        $welcome = $this->post($course, [
            'type' => PostType::Announcement,
            'body' => 'Selamat datang di kelas Matematika Wajib! Silakan cek Tugas Kelas untuk materi Bab 1.',
        ], $this->ago(days: 7));
        $this->comment($welcome, $dimas, 'Siap, Bu!');
        $this->comment($welcome, $sari, 'Terima kasih, Bu.');

        $this->post($course, [
            'type' => PostType::Announcement,
            'body' => 'Ulangan harian Bab 1 diundur ke minggu depan. Gunakan waktunya untuk latihan, ya.',
        ], $this->ago(days: 1));

        $this->post($course, [
            'type' => PostType::Announcement,
            'body' => 'Jangan lupa membawa kalkulator untuk praktikum besok.',
            'status' => PostStatus::Scheduled,
            'scheduled_at' => now()->addDay()->setTime(0, 0),
        ]);

        $module = $this->post($course, [
            'type' => PostType::Material,
            'topic_id' => $limit->id,
            'title' => 'Modul Bab 1: Limit Fungsi',
            'body' => 'Baca modul ini sebelum mengerjakan latihan.',
        ], $this->ago(days: 6));
        $this->link($module, 'https://id.wikipedia.org/wiki/Limit_fungsi', 'Limit fungsi - Wikipedia');

        $formulas = $this->post($course, [
            'type' => PostType::Material,
            'topic_id' => $derivative->id,
            'title' => 'Rumus Dasar Turunan',
            'body' => 'Ringkasan rumus turunan yang dipakai di Bab 2.',
        ], $this->ago(days: 3));
        $this->link($formulas, 'https://id.wikipedia.org/wiki/Turunan', 'Turunan - Wikipedia');

        // Tenggat lewat: dikembalikan, dinilai (draf) terlambat, terlewat, diserahkan.
        $limitPractice = $this->post($course, [
            'type' => PostType::Assignment,
            'topic_id' => $limit->id,
            'title' => 'Latihan Limit Fungsi',
            'body' => 'Kerjakan soal 1-10 di halaman 32. Unggah foto jawaban yang jelas.',
            'points' => 100,
            'due_at' => $this->ago(days: 3),
        ], $this->ago(days: 6));
        $dimasLimit = $this->returned($limitPractice, $dimas, 88, $this->ago(days: 4), $this->ago(days: 2));
        $this->graded($limitPractice, $sari, 75, $this->ago(days: 2));
        $this->turnedIn($limitPractice, $ayu, $this->ago(days: 4));
        $this->returned($limitPractice, $rizky, 92, $this->ago(days: 4), $this->ago(days: 2));
        $this->privateComment($dimasLimit, $this->teacher, 'Kerja bagus, Dimas. Perhatikan lagi langkah di soal nomor 7.');
        $this->privateComment($dimasLimit, $dimas, 'Baik, Bu. Terima kasih!');

        $summary = $this->post($course, [
            'type' => PostType::Assignment,
            'topic_id' => $limit->id,
            'title' => 'Rangkuman Bab 1',
            'body' => 'Tulis rangkuman Bab 1 maksimal dua halaman.',
            'points' => 50,
            'due_at' => $this->ago(days: 1),
        ], $this->ago(days: 5));
        $this->turnedIn($summary, $sari, $this->ago(hours: 2));
        $this->turnedIn($summary, $budi, $this->ago(days: 2));
        $this->returned($summary, $ayu, 45, $this->ago(days: 2), $this->ago(hours: 12));

        $this->post($course, [
            'type' => PostType::Assignment,
            'topic_id' => $limit->id,
            'title' => 'Remedial Bab 1',
            'body' => 'Khusus siswa dengan nilai di bawah 75.',
            'points' => 100,
            'status' => PostStatus::Draft,
        ]);

        // Tenggat mendatang: ditugaskan dan diserahkan.
        $derivativePractice = $this->post($course, [
            'type' => PostType::Assignment,
            'topic_id' => $derivative->id,
            'title' => 'Latihan Turunan Fungsi',
            'body' => 'Kerjakan soal 1-10 di halaman 54.',
            'points' => 100,
            'due_at' => now()->addDays(4)->setTime(16, 59),
        ], $this->ago(days: 2));
        $this->turnedIn($derivativePractice, $sari, $this->ago(days: 1));
        $this->comment($derivativePractice, $budi, 'Bu, soal nomor 5 boleh pakai aturan rantai?');
        $this->comment($derivativePractice, $this->teacher, 'Boleh, Budi.');

        $storyProblems = $this->post($course, [
            'type' => PostType::Assignment,
            'topic_id' => $derivative->id,
            'title' => 'Soal Cerita Turunan',
            'body' => 'Selesaikan tiga soal cerita di lembar kerja.',
            'points' => 100,
            'due_at' => now()->addDay()->setTime(16, 59),
        ], $this->ago(days: 2));
        $dimasStory = $this->turnedIn($storyProblems, $dimas, $this->ago(hours: 3));
        $this->link($dimasStory, 'https://docs.example.com/dimas-soal-cerita', 'Jawaban soal cerita Dimas', $dimas);
        $this->turnedIn($storyProblems, $budi, $this->ago(hours: 5));

        // Tanpa tenggat: dinilai (draf).
        $project = $this->post($course, [
            'type' => PostType::Assignment,
            'topic_id' => $derivative->id,
            'title' => 'Proyek Grafik Fungsi',
            'body' => 'Gambar grafik fungsi dan turunannya, lalu jelaskan hubungannya.',
            'points' => 100,
        ], $this->ago(days: 4));
        $this->graded($project, $dimas, 80, $this->ago(days: 1));
        $this->turnedIn($project, $ayu, $this->ago(days: 1));

        $quiz = $this->post($course, [
            'type' => PostType::Quiz,
            'topic_id' => $derivative->id,
            'title' => 'Kuis Turunan Dasar',
            'body' => 'Tiga soal pilihan ganda. Kuis hanya bisa diserahkan sekali.',
            'due_at' => now()->addDays(2)->setTime(16, 59),
        ], $this->ago(days: 1), quiz: [
            ['Turunan dari f(x) = x² adalah ...', ['x', '2x', 'x²', '2'], 1],
            ['Turunan dari fungsi konstanta adalah ...', ['0', '1', 'Konstanta itu sendiri'], 0],
            ['Turunan dari f(x) = 3x + 5 adalah ...', ['3x', '5', '3', '8'], 2],
        ]);
        $this->quizTurnedIn($quiz, $sari, [1, 0, 0], $this->ago(hours: 6));
        $rizkyQuiz = $this->quizTurnedIn($quiz, $rizky, [1, 0, 2], $this->ago(hours: 20));
        $rizkyQuiz->update([
            'status' => SubmissionStatus::Returned,
            'grade' => $rizkyQuiz->draft_grade,
            'returned_at' => $this->ago(hours: 4),
        ]);

        // Pertanyaan (stretch): jawaban singkat sudah dijawab Sari; pilihan ganda masih ditugaskan.
        $meaning = $this->question($course, [
            'topic_id' => $derivative->id,
            'title' => 'Dengan kata-katamu sendiri, apa arti turunan suatu fungsi?',
            'points' => 10,
            'due_at' => now()->addDays(3)->setTime(16, 59),
        ], options: [], publishedAt: $this->ago(hours: 10));
        $this->submission($meaning, $sari)->update([
            'status' => SubmissionStatus::TurnedIn,
            'answer_text' => 'Turunan menunjukkan laju perubahan nilai fungsi terhadap perubahan x.',
            'turned_in_at' => $this->ago(hours: 3),
        ]);
        $this->question($course, [
            'topic_id' => $derivative->id,
            'title' => 'Bagian mana dari Bab 2 yang masih paling membingungkan?',
        ], options: ['Aturan rantai', 'Turunan fungsi trigonometri', 'Soal cerita'], publishedAt: $this->ago(hours: 8));

        $this->post($course, [
            'type' => PostType::Assignment,
            'topic_id' => $derivative->id,
            'title' => 'Ulangan Harian Bab 2',
            'body' => 'Kerjakan secara mandiri.',
            'points' => 100,
            'status' => PostStatus::Scheduled,
            'scheduled_at' => now()->addDay()->setTime(0, 0),
            'due_at' => now()->addDays(3)->setTime(16, 59),
        ]);
    }

    /** @param  list<User>  $students */
    private function seedIndonesian(array $students, User $invitee): void
    {
        $course = $this->course([
            'name' => 'Bahasa Indonesia',
            'section' => 'XI IPA 2',
            'subject' => 'Bahasa Indonesia',
            'room' => 'R. 106',
            'theme' => 'forest',
            'code' => 'bind11b',
        ], $students);

        Invitation::create([
            'course_id' => $course->id,
            'invited_by' => $this->teacher->id,
            'email' => $invitee->email,
            'role' => CourseRole::Student,
        ]);

        $exposition = $this->topic($course, 'Teks Eksposisi');

        $this->post($course, [
            'type' => PostType::Announcement,
            'body' => 'Minggu ini kita mulai materi teks eksposisi.',
        ], $this->ago(days: 3));

        $example = $this->post($course, [
            'type' => PostType::Material,
            'topic_id' => $exposition->id,
            'title' => 'Contoh Teks Eksposisi',
            'body' => 'Perhatikan struktur tesis, argumentasi, dan penegasan ulang.',
        ], $this->ago(days: 3));
        $this->link($example, 'https://id.wikipedia.org/wiki/Eksposisi', 'Eksposisi - Wikipedia');

        $essay = $this->post($course, [
            'type' => PostType::Assignment,
            'topic_id' => $exposition->id,
            'title' => 'Menulis Teks Eksposisi',
            'body' => 'Tulis teks eksposisi 300-500 kata dengan tema lingkungan sekolah.',
            'points' => 100,
            'due_at' => now()->addDays(5)->setTime(16, 59),
        ], $this->ago(days: 2));
        $this->turnedIn($essay, $students[0], $this->ago(hours: 8));
    }

    private function user(string $name, string $email): User
    {
        return User::factory()->create(['name' => $name, 'email' => $email]);
    }

    /** @param  list<User>  $students */
    private function course(array $attributes, array $students): Course
    {
        $course = Course::create([...$attributes, 'owner_id' => $this->teacher->id]);

        $course->users()->attach($this->teacher->id, ['role' => CourseRole::Teacher->value]);
        foreach ($students as $student) {
            $course->users()->attach($student->id, ['role' => CourseRole::Student->value]);
        }

        return $course;
    }

    private function topic(Course $course, string $name): Topic
    {
        return $course->topics()->create([
            'name' => $name,
            'position' => $course->topics()->count(),
        ]);
    }

    /**
     * Membuat posting; bila $publishedAt diisi, diterbitkan lewat PublishPostService
     * lalu waktunya dimundurkan agar urutan Stream terlihat wajar.
     *
     * @param  list<array{0: string, 1: list<string>, 2: int}>  $quiz  [soal, opsi, indeks benar]
     */
    private function post(Course $course, array $attributes, ?Carbon $publishedAt = null, array $quiz = []): Post
    {
        $key = $course->id.':'.($attributes['topic_id'] ?? 'none');
        $this->positions[$key] = ($this->positions[$key] ?? -1) + 1;

        $post = $course->posts()->create([
            'author_id' => $this->teacher->id,
            'status' => PostStatus::Draft,
            'position' => $this->positions[$key],
            ...$attributes,
        ]);

        foreach ($quiz as $index => [$prompt, $options, $correct]) {
            $question = $post->quizQuestions()->create([
                'prompt' => $prompt,
                'points' => 10,
                'position' => $index,
            ]);
            foreach ($options as $position => $label) {
                $question->options()->create([
                    'label' => $label,
                    'is_correct' => $position === $correct,
                    'position' => $position,
                ]);
            }
        }
        if ($quiz !== []) {
            $post->update(['points' => $post->quizQuestions()->sum('points')]);
        }

        if ($publishedAt !== null) {
            $this->publisher->publish($post);
            $post->update(['published_at' => $publishedAt]);
        }

        return $post;
    }

    /** Pertanyaan: bentuk disimpan lewat service yang sama dengan API, lalu diterbitkan. */
    private function question(Course $course, array $attributes, array $options, Carbon $publishedAt): Post
    {
        $post = $this->post($course, ['type' => PostType::Question, ...$attributes]);
        app(QuestionService::class)->save($post, $options);
        $this->publisher->publish($post);
        $post->update(['published_at' => $publishedAt]);

        return $post;
    }

    private function submission(Post $post, User $student): Submission
    {
        return $post->submissions()->where('student_id', $student->id)->firstOrFail();
    }

    private function turnedIn(Post $post, User $student, Carbon $at): Submission
    {
        $submission = $this->submission($post, $student);
        $submission->update([
            'status' => SubmissionStatus::TurnedIn,
            'turned_in_at' => $at,
        ]);

        return $submission;
    }

    private function graded(Post $post, User $student, int $grade, Carbon $turnedInAt): Submission
    {
        $submission = $this->turnedIn($post, $student, $turnedInAt);
        $submission->update([
            'draft_grade' => $grade,
            'graded_by' => $this->teacher->id,
        ]);

        return $submission;
    }

    private function returned(Post $post, User $student, int $grade, Carbon $turnedInAt, Carbon $returnedAt): Submission
    {
        $submission = $this->graded($post, $student, $grade, $turnedInAt);
        $submission->update([
            'status' => SubmissionStatus::Returned,
            'grade' => $grade,
            'returned_at' => $returnedAt,
        ]);

        return $submission;
    }

    /** @param  list<int>  $choices  indeks opsi yang dipilih per soal */
    private function quizTurnedIn(Post $quiz, User $student, array $choices, Carbon $at): Submission
    {
        $submission = $this->turnedIn($quiz, $student, $at);
        $score = 0;

        foreach ($quiz->quizQuestions()->with('options')->get() as $index => $question) {
            $option = $question->options[$choices[$index]];
            QuizAnswer::create([
                'submission_id' => $submission->id,
                'quiz_question_id' => $question->id,
                'quiz_option_id' => $option->id,
                'is_correct' => $option->is_correct,
            ]);
            $score += $option->is_correct ? $question->points : 0;
        }

        $submission->update(['draft_grade' => $score]);

        return $submission;
    }

    private function link(Post|Submission $attachable, string $url, string $title, ?User $uploader = null): void
    {
        $attachable->attachments()->create([
            'uploaded_by' => ($uploader ?? $this->teacher)->id,
            'kind' => 'link',
            'url' => $url,
            'title' => $title,
        ]);
    }

    private function comment(Post $post, User $user, string $body): void
    {
        $post->comments()->create(['user_id' => $user->id, 'body' => $body]);
    }

    private function privateComment(Submission $submission, User $user, string $body): void
    {
        PrivateComment::create([
            'submission_id' => $submission->id,
            'user_id' => $user->id,
            'body' => $body,
        ]);
    }

    private function ago(int $days = 0, int $hours = 0): Carbon
    {
        return now()->subDays($days)->subHours($hours);
    }
}
