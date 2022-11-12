<?php

namespace App\DataFixtures\Loader;

use App\DataFixtures\LoadEntityData;
use App\Entity\Category;
use Doctrine\Common\DataFixtures\OrderedFixtureInterface;
use Doctrine\Persistence\ObjectManager;

class LoadCategoryData extends LoadEntityData implements OrderedFixtureInterface
{
    public const FILENAME = 'Category.yml';

    protected function loadEntityData(ObjectManager $manager, array $row)
    {
        $category = (new Category())->setTitle($row['title']);

        $manager->persist($category);
    }

    public function getFilename(): string
    {
        return self::FILENAME;
    }

    public function getOrder()
    {
        return 1;
    }
}
