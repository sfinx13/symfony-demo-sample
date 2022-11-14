<?php

namespace App\Manager;

use App\Entity\Category;
use Doctrine\Persistence\ManagerRegistry;

class CategoryManager extends AbstractManager
{
    public function __construct(ManagerRegistry $managerRegistry, string $entityName = Category::class)
    {
        $this->managerRegistry = $managerRegistry;
        $this->entityName = $entityName;
    }
}
