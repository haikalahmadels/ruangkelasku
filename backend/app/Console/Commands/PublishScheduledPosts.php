<?php

namespace App\Console\Commands;

use App\Enums\PostStatus;
use App\Models\Post;
use App\Services\PublishPostService;
use Illuminate\Console\Command;
use Illuminate\Validation\ValidationException;

/** Dijalankan tiap menit oleh `php artisan schedule:work`. */
class PublishScheduledPosts extends Command
{
    protected $signature = 'posts:publish-scheduled';

    protected $description = 'Terbitkan posting terjadwal yang waktunya sudah tiba';

    public function handle(PublishPostService $publisher): int
    {
        $published = 0;

        Post::where('status', PostStatus::Scheduled)
            ->where('scheduled_at', '<=', now())
            ->whereHas('course', fn ($query) => $query->whereNull('archived_at'))
            ->with('course')
            ->each(function (Post $post) use ($publisher, &$published) {
                try {
                    $publisher->publish($post);
                    $published++;
                } catch (ValidationException) {
                    // Kuis tanpa soal atau Pertanyaan tanpa bentuk tetap terjadwal sampai guru melengkapinya.
                    $this->warn("Posting #{$post->id} dilewati: soal atau bentuk pertanyaan belum disimpan.");
                }
            });

        $this->info("{$published} posting diterbitkan.");

        return self::SUCCESS;
    }
}
