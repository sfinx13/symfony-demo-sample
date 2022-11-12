<?php

namespace App\Entity\Behaviour;

use Symfony\Component\String\Slugger\SluggerInterface;

interface EntitySlugableInterface
{
    public function computeSlug(SluggerInterface $slugger);

    public function getSlug(): ?string;
}