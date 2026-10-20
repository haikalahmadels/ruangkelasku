<?php

namespace App\Enums;

enum SubmissionStatus: string
{
    case Assigned = 'assigned';
    case TurnedIn = 'turned_in';
    case Returned = 'returned';
}
