<?php

namespace App\Providers;

use App\Models\Post;
use App\Models\Submission;
use App\Models\User;
use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Relation::enforceMorphMap([
            'post' => Post::class,
            'submission' => Submission::class,
            // Dipakai Sanctum (tokenable) dan notifikasi (notifiable).
            'user' => User::class,
        ]);
    }
}
