<?php

namespace Tests\Feature\Auth;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ProfileTest extends TestCase
{
    use RefreshDatabase;

    public function test_me_returns_current_user(): void
    {
        $user = Sanctum::actingAs(User::factory()->create());

        $this->getJson('/api/v1/me')
            ->assertOk()
            ->assertJsonPath('data.id', $user->id)
            ->assertJsonMissingPath('data.password');
    }

    public function test_update_name(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $this->patchJson('/api/v1/me', ['name' => 'Nama Baru'])
            ->assertOk()
            ->assertJsonPath('data.name', 'Nama Baru');
    }

    public function test_upload_avatar_replaces_old_file(): void
    {
        Storage::fake('public');
        $user = Sanctum::actingAs(User::factory()->create());

        $this->post('/api/v1/me/avatar', [
            'avatar' => UploadedFile::fake()->image('a.jpg'),
        ], ['Accept' => 'application/json'])->assertOk();
        $firstPath = $user->fresh()->avatar_path;

        $response = $this->post('/api/v1/me/avatar', [
            'avatar' => UploadedFile::fake()->image('b.png'),
        ], ['Accept' => 'application/json'])->assertOk();

        $newPath = $user->fresh()->avatar_path;
        Storage::disk('public')->assertMissing($firstPath);
        Storage::disk('public')->assertExists($newPath);
        $this->assertStringEndsWith('/storage/'.$newPath, $response->json('data.avatar_url'));
    }

    public function test_avatar_must_be_image_under_2mb(): void
    {
        Storage::fake('public');
        Sanctum::actingAs(User::factory()->create());

        $this->post('/api/v1/me/avatar', [
            'avatar' => UploadedFile::fake()->image('besar.jpg')->size(3000),
        ], ['Accept' => 'application/json'])->assertUnprocessable()->assertJsonValidationErrors('avatar');

        $this->post('/api/v1/me/avatar', [
            'avatar' => UploadedFile::fake()->create('dok.pdf', 10, 'application/pdf'),
        ], ['Accept' => 'application/json'])->assertUnprocessable()->assertJsonValidationErrors('avatar');
    }
}
