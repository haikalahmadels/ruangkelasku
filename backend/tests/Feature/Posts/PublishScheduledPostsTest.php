<?php

namespace Tests\Feature\Posts;

use App\Enums\PostStatus;
use App\Models\Course;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\Concerns\BuildsCourses;
use Tests\TestCase;

class PublishScheduledPostsTest extends TestCase
{
    use BuildsCourses, RefreshDatabase;

    public function test_publishes_only_posts_whose_time_has_come(): void
    {
        $course = Course::factory()->create();
        $this->addStudent($course);
        $due = $this->makePost($course, publish: false);
        $due->update(['status' => PostStatus::Scheduled, 'scheduled_at' => now()->addMinutes(5)]);
        $later = $this->makePost($course, publish: false);
        $later->update(['status' => PostStatus::Scheduled, 'scheduled_at' => now()->addHour()]);

        $this->travel(6)->minutes();
        $this->artisan('posts:publish-scheduled')->expectsOutput('1 posting diterbitkan.')->assertSuccessful();

        $this->assertSame(PostStatus::Published, $due->fresh()->status);
        $this->assertSame(1, $due->submissions()->count());
        $this->assertSame(PostStatus::Scheduled, $later->fresh()->status);
    }

    public function test_skips_archived_courses(): void
    {
        $course = Course::factory()->archived()->create();
        $post = $this->makePost($course, publish: false);
        $post->update(['status' => PostStatus::Scheduled, 'scheduled_at' => now()->subMinute()]);

        $this->artisan('posts:publish-scheduled')->assertSuccessful();

        $this->assertSame(PostStatus::Scheduled, $post->fresh()->status);
    }

    public function test_command_is_scheduled_every_minute(): void
    {
        $this->artisan('schedule:list')->expectsOutputToContain('posts:publish-scheduled')->assertSuccessful();
    }
}
