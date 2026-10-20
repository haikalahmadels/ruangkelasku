<?php

namespace Tests\Feature;

use App\Enums\DisplayStatus;
use App\Models\Course;
use App\Models\User;
use Database\Seeders\DemoSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class DemoSeederTest extends TestCase
{
    use RefreshDatabase;

    public function test_demo_data_covers_every_display_status_for_dimas(): void
    {
        $this->seed(DemoSeeder::class);

        $this->assertSame(6, User::count());
        $this->assertSame(2, Course::count());

        $statuses = User::where('email', 'dimas@ruangkelasku.test')->firstOrFail()
            ->submissions()->with('post')->get()
            ->map(fn ($submission) => $submission->display_status)
            ->unique()
            ->values();

        foreach (DisplayStatus::cases() as $status) {
            $this->assertContains($status, $statuses, "Status {$status->value} tidak ada di data demo.");
        }
    }
}
