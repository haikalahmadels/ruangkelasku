<?php

namespace App\Policies;

use App\Models\Invitation;
use App\Models\User;

class InvitationPolicy
{
    public function delete(User $user, Invitation $invitation): bool
    {
        return $user->isTeacherOf($invitation->course);
    }

    /** Menerima atau menolak: hanya pengguna yang email-nya diundang. */
    public function respond(User $user, Invitation $invitation): bool
    {
        return strcasecmp($user->email, $invitation->email) === 0;
    }
}
