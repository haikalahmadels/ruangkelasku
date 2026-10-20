<?php

namespace App\Notifications;

use App\Enums\CourseRole;
use App\Models\Invitation;

class CourseInvitationReceived extends AppNotification
{
    public function __construct(private Invitation $invitation) {}

    public function databaseType(object $notifiable): string
    {
        return 'course_invitation';
    }

    public function toArray(object $notifiable): array
    {
        $role = $this->invitation->role === CourseRole::Teacher ? 'pengajar' : 'siswa';

        return [
            'title' => 'Undangan kelas',
            'message' => "{$this->invitation->inviter->name} mengundang Anda ke {$this->invitation->course->name} sebagai {$role}",
            'course_id' => $this->invitation->course_id,
            'post_id' => null,
        ];
    }
}
