<?php

namespace Tests\Feature\Posts;

use App\Enums\PostType;
use App\Models\Course;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\Concerns\BuildsCourses;
use Tests\TestCase;

class AttachmentCommentTest extends TestCase
{
    use BuildsCourses, RefreshDatabase;

    public function test_teacher_adds_and_removes_post_attachments(): void
    {
        Storage::fake('public');
        $course = Course::factory()->create();
        $post = $this->makePost($course, PostType::Material);
        Sanctum::actingAs($course->owner);

        $file = $this->post("/api/v1/posts/{$post->id}/attachments", [
            'file' => UploadedFile::fake()->image('foto.jpg'),
        ], ['Accept' => 'application/json'])->assertCreated()->json('data');
        $this->postJson("/api/v1/posts/{$post->id}/attachments", ['url' => 'https://example.com', 'title' => 'Contoh'])
            ->assertCreated()
            ->assertJsonPath('data.url', 'https://example.com');

        $path = $post->attachments()->whereKey($file['id'])->value('file_path');
        $this->assertStringEndsWith('/storage/'.$path, $file['url']);

        $this->deleteJson("/api/v1/attachments/{$file['id']}")->assertNoContent();
        Storage::disk('public')->assertMissing($path);
    }

    public function test_attachment_needs_file_or_url_and_rejects_bad_types(): void
    {
        $course = Course::factory()->create();
        $post = $this->makePost($course, PostType::Material);
        Sanctum::actingAs($course->owner);

        $this->postJson("/api/v1/posts/{$post->id}/attachments", [])->assertJsonValidationErrors(['file', 'url']);
        $this->post("/api/v1/posts/{$post->id}/attachments", [
            'file' => UploadedFile::fake()->create('virus.exe', 10),
        ], ['Accept' => 'application/json'])->assertJsonValidationErrors('file');
    }

    public function test_student_cannot_attach_to_teacher_post(): void
    {
        $course = Course::factory()->create();
        $post = $this->makePost($course, PostType::Material);
        Sanctum::actingAs($this->addStudent($course));

        $this->postJson("/api/v1/posts/{$post->id}/attachments", ['url' => 'https://x.test'])->assertForbidden();
    }

    public function test_comments_follow_stream_permission(): void
    {
        $course = Course::factory()->create();
        $post = $this->makePost($course, PostType::Announcement);
        $student = Sanctum::actingAs($this->addStudent($course));
        $url = "/api/v1/posts/{$post->id}/comments";

        $this->postJson($url, ['body' => 'Siap, Bu!'])
            ->assertCreated()
            ->assertJsonPath('data.author.id', $student->id);

        $course->update(['stream_permission' => 'comment_only']);
        $this->postJson($url, ['body' => 'Masih boleh'])->assertCreated();

        $course->update(['stream_permission' => 'teacher_only']);
        $this->postJson($url, ['body' => 'Tidak boleh'])->assertForbidden();

        Sanctum::actingAs($course->owner);
        $this->postJson($url, ['body' => 'Guru selalu boleh'])->assertCreated();

        $this->getJson($url)->assertOk()->assertJsonCount(3, 'data')->assertJsonPath('data.0.body', 'Siap, Bu!');
    }

    public function test_cannot_comment_on_drafts(): void
    {
        $course = Course::factory()->create();
        $draft = $this->makePost($course, publish: false);
        Sanctum::actingAs($course->owner);

        $this->postJson("/api/v1/posts/{$draft->id}/comments", ['body' => 'X'])->assertForbidden();
    }

    public function test_comment_deleted_by_author_or_teacher_only(): void
    {
        $course = Course::factory()->create();
        $post = $this->makePost($course, PostType::Announcement);
        $author = $this->addStudent($course);
        $other = $this->addStudent($course);
        $comment = $post->comments()->create(['user_id' => $author->id, 'body' => 'Halo']);
        $second = $post->comments()->create(['user_id' => $author->id, 'body' => 'Lagi']);

        Sanctum::actingAs($other);
        $this->deleteJson("/api/v1/comments/{$comment->id}")->assertForbidden();

        Sanctum::actingAs($author);
        $this->deleteJson("/api/v1/comments/{$comment->id}")->assertNoContent();

        Sanctum::actingAs($course->owner);
        $this->deleteJson("/api/v1/comments/{$second->id}")->assertNoContent();
    }
}
