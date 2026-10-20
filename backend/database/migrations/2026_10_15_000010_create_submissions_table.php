<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('submissions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('post_id')->constrained()->cascadeOnDelete();
            $table->foreignId('student_id')->constrained('users')->cascadeOnDelete();
            $table->enum('status', ['assigned', 'turned_in', 'returned'])->default('assigned');
            // Belum dikembalikan; hanya terlihat guru.
            $table->decimal('draft_grade', 5, 2)->nullable();
            // Sudah dikembalikan; terlihat siswa.
            $table->decimal('grade', 5, 2)->nullable();
            $table->dateTime('turned_in_at')->nullable();
            $table->dateTime('returned_at')->nullable();
            $table->foreignId('graded_by')->nullable()->constrained('users')->nullOnDelete();
            // Disiapkan untuk stretch Pertanyaan jawaban singkat.
            $table->text('answer_text')->nullable();
            $table->timestamps();

            $table->unique(['post_id', 'student_id']);
            $table->index(['student_id', 'status']);
            $table->index(['post_id', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('submissions');
    }
};
