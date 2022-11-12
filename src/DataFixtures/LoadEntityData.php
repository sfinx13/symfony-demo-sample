<?php

namespace App\DataFixtures;

use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use Symfony\Component\Yaml\Yaml;

abstract class LoadEntityData extends Fixture
{
    abstract protected function loadEntityData(ObjectManager $manager, array $row);

    abstract public function getFilename(): string;

    public function load(ObjectManager $manager): void
    {
        $rowList = Yaml::parseFile(__DIR__.'/File/'.$this->getFilename());
        foreach ($rowList as $rowItem) {
            $this->loadEntityData($manager, $rowItem);
        }
        $manager->flush();
    }
}
