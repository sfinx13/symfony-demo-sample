<?php

namespace App\EventListener;

use App\Entity\Behaviour\EntitySlugableInterface;
use Doctrine\ORM\Event\LifecycleEventArgs;
use Symfony\Component\String\Slugger\SluggerInterface;

class EntitySlugableListener
{
    public function __construct(private SluggerInterface $slugger)
    {
    }

    public function prePersist(EntitySlugableInterface $entity, LifecycleEventArgs $event)
    {
        $entity->computeSlug($this->slugger);
    }

    public function preUpdate(EntitySlugableInterface $entity, LifecycleEventArgs $event)
    {
        $entity->computeSlug($this->slugger);
    }
}
