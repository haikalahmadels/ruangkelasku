<?php

namespace App\Enums;

/** Lima status submission yang tampil di UI; diturunkan dari SubmissionStatus dan waktu. */
enum DisplayStatus: string
{
    case Assigned = 'assigned';
    case Missing = 'missing';
    case TurnedIn = 'turned_in';
    case Graded = 'graded';
    case Returned = 'returned';
}
