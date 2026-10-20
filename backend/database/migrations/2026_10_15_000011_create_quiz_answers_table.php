<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('quiz_answers', function (Blueprint $table) {
            $table->id();
            $table->foreignId('submission_id')->constrained()->cascadeOnDelete();
            $table->foreignId('quiz_question_id')->constrained()->cascadeOnDelete();
            // NULL = soal tidak dijawab.
            $table->foreignId('quiz_option_id')->nullable()->constrained()->nullOnDelete();
            // Disalin saat penyerahan agar nilai tidak berubah bila kunci diedit.
            $table->boolean('is_correct');
            $table->timestamps();

            $table->unique(['submission_id', 'quiz_question_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('quiz_answers');
    }
};
