<?php

namespace Tests\Feature\Posts;

use App\Enums\PostType;
use App\Enums\SubmissionStatus;
use App\Models\Course;
use App\Models\Post;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\Concerns\BuildsCourses;
use Tests\TestCase;

class PostTest extends TestCase
{
    use BuildsCourses, RefreshDatabase;

    public function test_teacher_publishes_assignment_with_file_and_link(): void
    {
        Storage::fake('public');
        $course = Course::factory()->create();
        $this->addStudent($course);
        $topic = $course->topics()->create(['name' => 'Bab 1', 'position' => 0]);
        Sanctum::actingAs($course->owner);

        $response = $this->post("/api/v1/courses/{$course->id}/posts", [
            'type' => 'assignment',
            'title' => 'Latihan',
            'body' => 'Kerjakan soal 1–10.',
            'topic_id' => (string) $topic->id,
            'points' => '100',
            'due_at' => '2030-10-20T23:59:00+07:00',
            'status' => 'published',
            'files' => [UploadedFile::fake()->create('soal.pdf', 200, 'application/pdf')],
            'links' => ['https://example.com/materi'],
        ], ['Accept' => 'application/json']);

        $response->assertCreated()
            ->assertJsonPath('data.status', 'published')
            ->assertJsonPath('data.topic.id', $topic->id)
            ->assertJsonPath('data.due_at', '2030-10-20T16:59:00Z')
            ->assertJsonPath('data.submission_counts', ['assigned' => 1, 'turned_in' => 0, 'graded' => 0, 'returned' => 0])
            ->assertJsonCount(2, 'data.attachments');
        $this->assertNotNull($response->json('data.published_at'));
        Storage::disk('public')->assertExists(Post::first()->attachments()->where('kind', 'file')->value('file_path'));
    }

    public function test_validation_rules_from_api_doc(): void
    {
        $course = Course::factory()->create();
        $otherTopic = Course::factory()->create()->topics()->create(['name' => 'X', 'position' => 0]);
        Sanctum::actingAs($course->owner);
        $url = "/api/v1/courses/{$course->id}/posts";

        $this->postJson($url, ['type' => 'assignment', 'status' => 'draft'])->assertJsonValidationErrors('title');
        $this->postJson($url, ['type' => 'material', 'title' => 'M', 'due_at' => '2030-01-01', 'status' => 'draft'])
            ->assertJsonValidationErrors('due_at');
        $this->postJson($url, ['type' => 'assignment', 'title' => 'T', 'status' => 'scheduled'])
            ->assertJsonValidationErrors('scheduled_at');
        $this->postJson($url, ['type' => 'assignment', 'title' => 'T', 'status' => 'scheduled', 'scheduled_at' => now()->subHour()->toIso8601String()])
            ->assertJsonValidationErrors('scheduled_at');
        $this->postJson($url, ['type' => 'assignment', 'title' => 'T', 'topic_id' => $otherTopic->id, 'status' => 'draft'])
            ->assertJsonValidationErrors('topic_id');
        $this->postJson($url, ['type' => 'announcement', 'status' => 'published'])->assertJsonValidationErrors('body');
    }

    public function test_file_over_10mb_is_rejected(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs($course->owner);

        $this->post("/api/v1/courses/{$course->id}/posts", [
            'type' => 'material', 'title' => 'M', 'status' => 'draft',
            'files' => [UploadedFile::fake()->create('besar.pdf', 10241, 'application/pdf')],
        ], ['Accept' => 'application/json'])->assertJsonValidationErrors('files.0');
    }

    public function test_student_announcements_follow_stream_permission(): void
    {
        $course = Course::factory()->create();
        $student = Sanctum::actingAs($this->addStudent($course));
        $url = "/api/v1/courses/{$course->id}/posts";

        $this->postJson($url, ['type' => 'announcement', 'body' => 'Halo', 'status' => 'published'])->assertCreated();
        $this->postJson($url, ['type' => 'announcement', 'body' => 'Halo', 'status' => 'draft'])->assertJsonValidationErrors('status');
        $this->postJson($url, ['type' => 'assignment', 'title' => 'T', 'status' => 'published'])->assertForbidden();

        $course->update(['stream_permission' => 'comment_only']);
        $this->postJson($url, ['type' => 'announcement', 'body' => 'Halo', 'status' => 'published'])->assertForbidden();
    }

    public function test_students_cannot_see_drafts_or_scheduled_posts(): void
    {
        $course = Course::factory()->create();
        $student = $this->addStudent($course);
        $draft = $this->makePost($course, publish: false);
        $published = $this->makePost($course);
        Sanctum::actingAs($student);

        $this->getJson("/api/v1/posts/{$draft->id}")->assertNotFound();
        $this->getJson("/api/v1/posts/{$published->id}")
            ->assertOk()
            ->assertJsonPath('data.my_submission.display_status', 'assigned')
            ->assertJsonMissingPath('data.submission_counts');

        $classwork = $this->getJson("/api/v1/courses/{$course->id}/classwork")->assertOk()->json('data.no_topic');
        $this->assertSame([$published->id], array_column($classwork, 'id'));
    }

    public function test_teacher_classwork_groups_by_topic_and_includes_drafts(): void
    {
        $course = Course::factory()->create();
        $topic = $course->topics()->create(['name' => 'Bab 1', 'position' => 0]);
        $inTopic = $this->makePost($course, publish: false);
        $inTopic->update(['topic_id' => $topic->id]);
        $loose = $this->makePost($course, PostType::Material);
        $this->makePost($course, PostType::Announcement);
        Sanctum::actingAs($course->owner);

        $this->getJson("/api/v1/courses/{$course->id}/classwork")
            ->assertOk()
            ->assertJsonPath('data.topics.0.topic.id', $topic->id)
            ->assertJsonPath('data.topics.0.posts.0.id', $inTopic->id)
            ->assertJsonPath('data.topics.0.posts.0.status', 'draft')
            ->assertJsonCount(1, 'data.no_topic')
            ->assertJsonPath('data.no_topic.0.id', $loose->id);

        $this->getJson("/api/v1/courses/{$course->id}/classwork?type=material")
            ->assertJsonCount(0, 'data.topics.0.posts')
            ->assertJsonCount(1, 'data.no_topic');
    }

    public function test_stream_respects_classwork_on_stream(): void
    {
        $course = Course::factory()->create();
        $announcement = $this->makePost($course, PostType::Announcement);
        $this->makePost($course, PostType::Assignment);
        $this->makePost($course, PostType::Announcement, publish: false);
        Sanctum::actingAs($course->owner);

        $this->getJson("/api/v1/courses/{$course->id}/stream")
            ->assertOk()
            ->assertJsonCount(2, 'data')
            ->assertJsonStructure(['meta' => ['total']]);

        $course->update(['classwork_on_stream' => 'hide']);
        $this->getJson("/api/v1/courses/{$course->id}/stream")
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', $announcement->id);
    }

    public function test_upcoming_lists_three_nearest_unsubmitted_for_student(): void
    {
        $course = Course::factory()->create();
        $student = $this->addStudent($course);
        $posts = collect(range(1, 5))->map(function (int $days) use ($course) {
            $post = $this->makePost($course);
            $post->update(['due_at' => now()->addDays($days)]);

            return $post;
        });
        $this->makePost($course)->update(['due_at' => now()->subDay()]);
        $posts[0]->submissions()->where('student_id', $student->id)->update(['status' => SubmissionStatus::TurnedIn]);
        Sanctum::actingAs($student);

        $ids = array_column($this->getJson("/api/v1/courses/{$course->id}/posts/upcoming")->assertOk()->json('data'), 'id');

        $this->assertSame([$posts[1]->id, $posts[2]->id, $posts[3]->id], $ids);
    }

    public function test_publishing_draft_creates_submissions_and_cannot_unpublish(): void
    {
        $course = Course::factory()->create();
        $this->addStudent($course);
        $post = $this->makePost($course, publish: false);
        Sanctum::actingAs($course->owner);

        $this->postJson("/api/v1/posts/{$post->id}/publish")->assertOk()->assertJsonPath('data.status', 'published');
        $this->assertSame(1, $post->submissions()->count());

        $this->patchJson("/api/v1/posts/{$post->id}", ['status' => 'draft'])->assertJsonValidationErrors('status');
    }

    public function test_scheduling_and_unscheduling_a_draft(): void
    {
        $course = Course::factory()->create();
        $post = $this->makePost($course, publish: false);
        Sanctum::actingAs($course->owner);
        $at = now()->addDay()->startOfMinute();

        $this->patchJson("/api/v1/posts/{$post->id}", ['status' => 'scheduled', 'scheduled_at' => $at->toIso8601String()])
            ->assertOk()
            ->assertJsonPath('data.status', 'scheduled')
            ->assertJsonPath('data.scheduled_at', $at->toIso8601ZuluString());

        $this->patchJson("/api/v1/posts/{$post->id}", ['status' => 'draft'])
            ->assertOk()
            ->assertJsonPath('data.scheduled_at', null);
    }

    public function test_only_teacher_or_author_edits_and_deletes(): void
    {
        $course = Course::factory()->create();
        $post = $this->makePost($course);
        $student = $this->addStudent($course);
        $own = Post::create([
            'course_id' => $course->id, 'author_id' => $student->id, 'type' => PostType::Announcement,
            'body' => 'Halo', 'status' => 'published', 'published_at' => now(), 'position' => 0,
        ]);
        Sanctum::actingAs($student);

        $this->patchJson("/api/v1/posts/{$post->id}", ['title' => 'X'])->assertForbidden();
        $this->deleteJson("/api/v1/posts/{$post->id}")->assertForbidden();
        $this->patchJson("/api/v1/posts/{$own->id}", ['body' => 'Diubah'])->assertOk();
        $this->deleteJson("/api/v1/posts/{$own->id}")->assertNoContent();
        $this->assertSoftDeleted($own);
    }

    public function test_move_post_between_topics_renumbers_positions(): void
    {
        $course = Course::factory()->create();
        $topic = $course->topics()->create(['name' => 'Bab 1', 'position' => 0]);
        [$a, $b, $c] = collect(range(0, 2))->map(fn ($i) => tap($this->makePost($course))->update(['position' => $i]))->all();
        Sanctum::actingAs($course->owner);

        $this->putJson("/api/v1/posts/{$c->id}/position", ['topic_id' => null, 'position' => 0])->assertNoContent();
        $this->assertSame([$c->id, $a->id, $b->id], $course->posts()->orderBy('position')->pluck('id')->all());

        $this->putJson("/api/v1/posts/{$a->id}/position", ['topic_id' => $topic->id, 'position' => 0])->assertNoContent();
        $this->assertSame($topic->id, $a->fresh()->topic_id);
        $this->assertSame([0, 1], [$c->fresh()->position, $b->fresh()->position]);
    }

    public function test_archived_course_rejects_new_posts(): void
    {
        $course = Course::factory()->archived()->create();
        Sanctum::actingAs($course->owner);

        $this->postJson("/api/v1/courses/{$course->id}/posts", ['type' => 'announcement', 'body' => 'X', 'status' => 'published'])
            ->assertStatus(409)
            ->assertJson(['code' => 'course_archived']);
    }
}
