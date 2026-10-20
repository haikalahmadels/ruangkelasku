<?php

namespace Database\Factories;

use App\Enums\CourseRole;
use App\Models\Course;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Course>
 */
class CourseFactory extends Factory
{
    public function definition(): array
    {
        return [
            'owner_id' => User::factory(),
            'name' => fake()->randomElement(['Matematika', 'Fisika', 'Biologi', 'Sejarah']),
            'section' => 'XI IPA '.fake()->numberBetween(1, 4),
            'code' => Course::generateUniqueCode(),
            'theme' => fake()->randomElement(Course::THEMES),
        ];
    }

    /** Pemilik juga tercatat sebagai teacher di course_members. */
    public function configure(): static
    {
        return $this->afterCreating(function (Course $course) {
            $course->users()->attach($course->owner_id, ['role' => CourseRole::Teacher->value]);
        });
    }

    public function archived(): static
    {
        return $this->state(fn () => ['archived_at' => now()]);
    }
}
