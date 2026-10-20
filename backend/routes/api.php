<?php

use App\Http\Controllers\Api\V1\AttachmentController;
use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\CommentController;
use App\Http\Controllers\Api\V1\CourseController;
use App\Http\Controllers\Api\V1\GradeController;
use App\Http\Controllers\Api\V1\InvitationController;
use App\Http\Controllers\Api\V1\MemberController;
use App\Http\Controllers\Api\V1\MySubmissionController;
use App\Http\Controllers\Api\V1\NotificationController;
use App\Http\Controllers\Api\V1\PostController;
use App\Http\Controllers\Api\V1\PrivateCommentController;
use App\Http\Controllers\Api\V1\ProfileController;
use App\Http\Controllers\Api\V1\QuizController;
use App\Http\Controllers\Api\V1\SubmissionController;
use App\Http\Controllers\Api\V1\TodoController;
use App\Http\Controllers\Api\V1\TopicController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::post('auth/register', [AuthController::class, 'register']);
    Route::post('auth/login', [AuthController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('auth/logout', [AuthController::class, 'logout']);

        Route::get('me', [ProfileController::class, 'show']);
        Route::patch('me', [ProfileController::class, 'update']);
        Route::post('me/avatar', [ProfileController::class, 'updateAvatar']);
        Route::get('me/invitations', [InvitationController::class, 'mine']);

        // Kelas
        Route::post('courses/join', [CourseController::class, 'join']);
        Route::get('courses', [CourseController::class, 'index']);
        Route::post('courses', [CourseController::class, 'store']);
        Route::get('courses/{course}', [CourseController::class, 'show']);
        Route::patch('courses/{course}', [CourseController::class, 'update']);
        Route::delete('courses/{course}', [CourseController::class, 'destroy']);
        Route::post('courses/{course}/code/reset', [CourseController::class, 'resetCode']);
        Route::post('courses/{course}/archive', [CourseController::class, 'archive']);
        Route::post('courses/{course}/restore', [CourseController::class, 'restore']);

        // Anggota
        Route::get('courses/{course}/members', [MemberController::class, 'index']);
        Route::delete('courses/{course}/members/{user}', [MemberController::class, 'destroy']);
        Route::delete('courses/{course}/membership', [MemberController::class, 'leave']);

        // Undangan
        Route::get('courses/{course}/invitations', [InvitationController::class, 'index']);
        Route::post('courses/{course}/invitations', [InvitationController::class, 'store']);
        Route::delete('invitations/{invitation}', [InvitationController::class, 'destroy']);
        Route::post('invitations/{invitation}/accept', [InvitationController::class, 'accept']);
        Route::post('invitations/{invitation}/decline', [InvitationController::class, 'decline']);

        // Topik
        Route::get('courses/{course}/topics', [TopicController::class, 'index']);
        Route::post('courses/{course}/topics', [TopicController::class, 'store']);
        Route::put('courses/{course}/topics/order', [TopicController::class, 'reorder']);
        Route::patch('topics/{topic}', [TopicController::class, 'update']);
        Route::delete('topics/{topic}', [TopicController::class, 'destroy']);

        // Posting: Stream dan Tugas Kelas membaca tabel posts yang sama
        Route::get('courses/{course}/stream', [PostController::class, 'stream']);
        Route::get('courses/{course}/classwork', [PostController::class, 'classwork']);
        Route::get('courses/{course}/posts/upcoming', [PostController::class, 'upcoming']);
        Route::post('courses/{course}/posts', [PostController::class, 'store']);
        Route::get('posts/{post}', [PostController::class, 'show']);
        Route::patch('posts/{post}', [PostController::class, 'update']);
        Route::delete('posts/{post}', [PostController::class, 'destroy']);
        Route::post('posts/{post}/publish', [PostController::class, 'publish']);
        Route::put('posts/{post}/position', [PostController::class, 'move']);

        // Lampiran dan komentar kelas
        Route::post('posts/{post}/attachments', [AttachmentController::class, 'store']);
        Route::delete('attachments/{attachment}', [AttachmentController::class, 'destroy']);
        Route::get('posts/{post}/comments', [CommentController::class, 'index']);
        Route::post('posts/{post}/comments', [CommentController::class, 'store']);
        Route::delete('comments/{comment}', [CommentController::class, 'destroy']);

        // Kuis
        Route::get('posts/{post}/quiz', [QuizController::class, 'show']);
        Route::put('posts/{post}/quiz', [QuizController::class, 'update']);
        Route::put('posts/{post}/question', [QuizController::class, 'updateQuestion']); // stretch: Pertanyaan

        // Pengumpulan: sisi siswa
        Route::get('posts/{post}/my-submission', [MySubmissionController::class, 'show']);
        Route::post('posts/{post}/my-submission/attachments', [MySubmissionController::class, 'storeAttachment']);
        Route::delete('posts/{post}/my-submission/attachments/{attachment}', [MySubmissionController::class, 'destroyAttachment']);
        Route::post('posts/{post}/my-submission/turn-in', [MySubmissionController::class, 'turnIn']);
        Route::post('posts/{post}/my-submission/unsubmit', [MySubmissionController::class, 'unsubmit']);
        Route::post('posts/{post}/my-submission/quiz', [MySubmissionController::class, 'submitQuiz']);
        Route::post('posts/{post}/my-submission/answer', [MySubmissionController::class, 'answerQuestion']); // stretch

        // Pengumpulan: sisi guru
        Route::get('posts/{post}/submissions', [SubmissionController::class, 'index']);
        Route::post('posts/{post}/return', [SubmissionController::class, 'return']);
        Route::get('submissions/{submission}', [SubmissionController::class, 'show']);
        Route::patch('submissions/{submission}/grade', [SubmissionController::class, 'grade']);
        Route::get('submissions/{submission}/comments', [PrivateCommentController::class, 'index']);
        Route::post('submissions/{submission}/comments', [PrivateCommentController::class, 'store']);

        // Nilai
        Route::get('courses/{course}/grades', [GradeController::class, 'index']);
        Route::get('courses/{course}/grades/export', [GradeController::class, 'export']);
        Route::get('courses/{course}/my-work', [GradeController::class, 'myWork']);

        // To-do dan notifikasi
        Route::get('todo', [TodoController::class, 'todo']);
        Route::get('to-review', [TodoController::class, 'toReview']);
        Route::get('notifications', [NotificationController::class, 'index']);
        Route::get('notifications/unread-count', [NotificationController::class, 'unreadCount']);
        Route::post('notifications/read-all', [NotificationController::class, 'readAll']);
        Route::post('notifications/{id}/read', [NotificationController::class, 'read']);
    });
});
