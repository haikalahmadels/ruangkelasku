<?php

namespace App\Services;

use App\Enums\CourseRole;
use App\Exceptions\DomainActionException;
use App\Models\Course;
use App\Models\Invitation;
use App\Models\User;
use App\Notifications\CourseInvitationReceived;
use Illuminate\Support\Facades\DB;

/** Undangan di dalam aplikasi; tidak ada email sungguhan yang dikirim. */
class InvitationService
{
    public function __construct(private JoinCourseService $joinCourse) {}

    public function invite(Course $course, User $inviter, string $email, CourseRole $role): Invitation
    {
        $course->ensureNotArchived();
        $email = strtolower(trim($email));

        $invitee = User::where('email', $email)->first();
        if ($invitee?->isMemberOf($course)) {
            throw new DomainActionException('already_member', 'Pengguna ini sudah menjadi anggota kelas.');
        }

        $alreadyInvited = $course->invitations()
            ->where('email', $email)
            ->where('status', 'pending')
            ->exists();
        if ($alreadyInvited) {
            throw new DomainActionException('already_invited', 'Email ini sudah diundang ke kelas ini.');
        }

        $invitation = $course->invitations()->create([
            'invited_by' => $inviter->id,
            'email' => $email,
            'role' => $role,
            'status' => 'pending',
        ]);

        // Email yang belum terdaftar melihat undangannya setelah mendaftar.
        $invitee?->notify(new CourseInvitationReceived($invitation));

        return $invitation;
    }

    public function accept(Invitation $invitation, User $user): Course
    {
        $this->ensurePending($invitation);
        $course = $invitation->course;
        $course->ensureNotArchived();

        if ($user->isMemberOf($course)) {
            $invitation->update(['status' => 'accepted']);
            throw new DomainActionException('already_member', 'Anda sudah menjadi anggota kelas ini.');
        }

        DB::transaction(function () use ($invitation, $course, $user) {
            $this->joinCourse->addMember($course, $user, $invitation->role);
            $invitation->update(['status' => 'accepted']);
        });

        return $course;
    }

    public function decline(Invitation $invitation): void
    {
        $this->ensurePending($invitation);
        $invitation->update(['status' => 'declined']);
    }

    private function ensurePending(Invitation $invitation): void
    {
        if ($invitation->status !== 'pending') {
            abort(404, 'Undangan tidak ditemukan.');
        }
    }
}
