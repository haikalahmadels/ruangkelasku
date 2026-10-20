<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('posts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('course_id')->constrained()->cascadeOnDelete();
            $table->foreignId('author_id')->constrained('users');
            // Selalu NULL untuk announcement.
            $table->foreignId('topic_id')->nullable()->constrained()->nullOnDelete();
            $table->enum('type', ['announcement', 'material', 'assignment', 'quiz', 'question']);
            $table->string('title', 200)->nullable();
            $table->text('body')->nullable();
            // NULL = tanpa nilai; untuk quiz = jumlah poin soal.
            $table->unsignedSmallInteger('points')->nullable();
            $table->dateTime('due_at')->nullable();
            $table->enum('status', ['draft', 'scheduled', 'published']);
            $table->dateTime('scheduled_at')->nullable();
            $table->dateTime('published_at')->nullable();
            $table->unsignedInteger('position');
            $table->timestamps();
            $table->softDeletes();

            $table->index(['course_id', 'status', 'published_at']);
            $table->index(['course_id', 'topic_id', 'position']);
            $table->index(['status', 'scheduled_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('posts');
    }
};
