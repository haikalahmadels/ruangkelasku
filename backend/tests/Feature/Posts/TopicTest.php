<?php

namespace Tests\Feature\Posts;

use App\Models\Course;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Concerns\BuildsCourses;
use Tests\TestCase;

class TopicTest extends TestCase
{
    use BuildsCourses, RefreshDatabase;

    public function test_teacher_manages_topics_in_order(): void
    {
        $course = Course::factory()->create();
        Sanctum::actingAs($course->owner);

        $a = $this->postJson("/api/v1/courses/{$course->id}/topics", ['name' => 'Bab 1'])->assertCreated()->json('data');
        $b = $this->postJson("/api/v1/courses/{$course->id}/topics", ['name' => 'Bab 2'])->assertCreated()->json('data');
        $this->assertSame([0, 1], [$a['position'], $b['position']]);

        $this->putJson("/api/v1/courses/{$course->id}/topics/order", ['topic_ids' => [$b['id'], $a['id']]])->assertNoContent();
        $this->getJson("/api/v1/courses/{$course->id}/topics")
            ->assertJsonPath('data.0.id', $b['id'])
            ->assertJsonPath('data.1.id', $a['id']);

        $this->patchJson("/api/v1/topics/{$a['id']}", ['name' => 'Bab Satu'])->assertOk()->assertJsonPath('data.name', 'Bab Satu');
    }

    public function test_reorder_must_contain_every_topic(): void
    {
        $course = Course::factory()->create();
        $topic = $course->topics()->create(['name' => 'A', 'position' => 0]);
        $course->topics()->create(['name' => 'B', 'position' => 1]);
        Sanctum::actingAs($course->owner);

        $this->putJson("/api/v1/courses/{$course->id}/topics/order", ['topic_ids' => [$topic->id]])
            ->assertUnprocessable()
            ->assertJsonValidationErrors('topic_ids');
    }

    public function test_deleting_topic_keeps_its_posts_without_topic(): void
    {
        $course = Course::factory()->create();
        $topic = $course->topics()->create(['name' => 'A', 'position' => 0]);
        $post = $this->makePost($course);
        $post->update(['topic_id' => $topic->id]);
        Sanctum::actingAs($course->owner);

        $this->deleteJson("/api/v1/topics/{$topic->id}")->assertNoContent();

        $this->assertNull($post->fresh()->topic_id);
    }

    public function test_students_can_list_but_not_manage_topics(): void
    {
        $course = Course::factory()->create();
        $topic = $course->topics()->create(['name' => 'A', 'position' => 0]);
        Sanctum::actingAs($this->addStudent($course));

        $this->getJson("/api/v1/courses/{$course->id}/topics")->assertOk()->assertJsonCount(1, 'data');
        $this->postJson("/api/v1/courses/{$course->id}/topics", ['name' => 'X'])->assertForbidden();
        $this->patchJson("/api/v1/topics/{$topic->id}", ['name' => 'X'])->assertForbidden();
        $this->deleteJson("/api/v1/topics/{$topic->id}")->assertForbidden();
    }
}
