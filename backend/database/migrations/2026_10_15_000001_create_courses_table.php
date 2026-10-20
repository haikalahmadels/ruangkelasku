<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('courses', function (Blueprint $table) {
            $table->id();
            $table->foreignId('owner_id')->constrained('users');
            $table->string('name', 100);
            $table->string('section', 100)->nullable();
            $table->string('subject', 100)->nullable();
            $table->string('room', 50)->nullable();
            $table->text('description')->nullable();
            $table->char('code', 7)->unique();
            $table->boolean('code_enabled')->default(true);
            $table->string('theme', 30);
            $table->enum('stream_permission', ['all', 'comment_only', 'teacher_only'])->default('all');
            $table->enum('classwork_on_stream', ['show', 'compact', 'hide'])->default('compact');
            $table->timestamp('archived_at')->nullable();
            // Disiapkan untuk multi-sekolah; tanpa FK di Fase UTS.
            $table->unsignedBigInteger('institution_id')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('courses');
    }
};
