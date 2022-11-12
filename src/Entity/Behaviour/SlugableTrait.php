<?php

namespace App\Entity\Behaviour;

use Symfony\Component\String\Slugger\SluggerInterface;
use Doctrine\ORM\Mapping as ORM;

trait SlugableTrait
{
    #[ORM\Column(type: 'string', unique: true, nullable: true)]
    private ?string $slug = null;

    public function getSlug(): ?string
    {
        return $this->slug;
    }

    public function computeSlug(SluggerInterface $slugger): void
    {
        if (!$this->slug || '-' === $this->slug) {
            $this->slug = (string) $slugger->slug((string) $this)->lower();
        }
    }
}