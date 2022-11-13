<?php

namespace App\DoctrineType;

use App\Entity\Enum\Status;

class StatusType extends AbstractEnumType
{
    public const NAME = 'status';

    public function getName(): string
    {
        return self::NAME;
    }

    public static function getEnumsClass(): string
    {
        return Status::class;
    }
}
