<?php

namespace App\Manager;

use App\Entity\Post;
use Doctrine\Persistence\ManagerRegistry;

class PostManager extends AbstractManager
{
    public function __construct(ManagerRegistry $managerRegistry, string $entityName = Post::class)
    {
        $this->managerRegistry = $managerRegistry;
        $this->entityName = $entityName;
    }
}
