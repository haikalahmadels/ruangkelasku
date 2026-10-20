<?php

namespace App\Exceptions;

use RuntimeException;

/** Aksi bertentangan dengan status data; dirender sebagai 409 dengan kode dari docs/api.md. */
class DomainActionException extends RuntimeException
{
    public function __construct(public readonly string $errorCode, string $message)
    {
        parent::__construct($message);
    }
}
