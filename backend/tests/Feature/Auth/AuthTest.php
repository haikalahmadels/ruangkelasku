<?php

namespace Tests\Feature\Auth;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use RefreshDatabase;

    public function test_register_returns_token_and_user(): void
    {
        $response = $this->postJson('/api/v1/auth/register', [
            'name' => 'Dimas Pratama',
            'email' => 'dimas@example.com',
            'password' => 'rahasia123',
            'password_confirmation' => 'rahasia123',
            'device_name' => 'android-emulator',
        ]);

        $response->assertCreated()
            ->assertJsonStructure(['data' => ['token', 'user' => ['id', 'name', 'email', 'avatar_url']]])
            ->assertJsonPath('data.user.email', 'dimas@example.com');
        $this->assertDatabaseHas('personal_access_tokens', ['name' => 'android-emulator']);
    }

    public function test_register_rejects_duplicate_email(): void
    {
        User::factory()->create(['email' => 'dimas@example.com']);

        $this->postJson('/api/v1/auth/register', [
            'name' => 'Dimas',
            'email' => 'dimas@example.com',
            'password' => 'rahasia123',
            'password_confirmation' => 'rahasia123',
            'device_name' => 'chrome',
        ])->assertUnprocessable()->assertJsonValidationErrors('email');
    }

    public function test_login_returns_token(): void
    {
        $user = User::factory()->create();

        $this->postJson('/api/v1/auth/login', [
            'email' => $user->email,
            'password' => 'password',
            'device_name' => 'chrome',
        ])->assertOk()
            ->assertJsonPath('data.user.id', $user->id)
            ->assertJsonStructure(['data' => ['token']]);
    }

    public function test_login_with_wrong_password_returns_422(): void
    {
        $user = User::factory()->create();

        $this->postJson('/api/v1/auth/login', [
            'email' => $user->email,
            'password' => 'salah',
            'device_name' => 'chrome',
        ])->assertUnprocessable()->assertJsonValidationErrors('email');
    }

    public function test_protected_endpoint_requires_token(): void
    {
        $this->getJson('/api/v1/me')
            ->assertUnauthorized()
            ->assertJson(['message' => 'Unauthenticated.']);
    }

    public function test_logout_revokes_only_the_current_token(): void
    {
        $user = User::factory()->create();
        $phoneToken = $user->createToken('android')->plainTextToken;
        $user->createToken('chrome');

        $this->withToken($phoneToken)->postJson('/api/v1/auth/logout')->assertNoContent();

        $this->assertDatabaseMissing('personal_access_tokens', ['name' => 'android']);
        $this->assertDatabaseHas('personal_access_tokens', ['name' => 'chrome']);
    }
}
