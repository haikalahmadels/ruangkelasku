<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

abstract class Controller
{
    /** `?per_page=`: default 20, maksimal 50 (docs/api.md). */
    protected function perPage(Request $request): int
    {
        return min(max($request->integer('per_page', 20), 1), 50);
    }
}
