<?php

namespace App\DataFixtures\Loader;

use App\DataFixtures\LoadEntityData;
use App\Entity\Category;
use App\Entity\Enum\Status;
use App\Entity\Post;
use Doctrine\Common\DataFixtures\OrderedFixtureInterface;
use Doctrine\Persistence\ObjectManager;
use Faker\Factory;

class LoadPostData extends LoadEntityData implements OrderedFixtureInterface
{
    public const FILENAME = 'Post.yml';

    protected function loadEntityData(ObjectManager $manager, array $row)
    {
        $faker = Factory::create();
        $post = (new Post())
            ->setTitle($row['title'])
            ->setContent($faker->realText())
            ->setPublishedAt(new \DateTimeImmutable())
            ->setStatus(Status::from($row['status']))
            ->setCategory(
                $manager->getRepository(Category::class)->findOneBy(['slug' => $row['category']])
            );


        $manager->persist($post);
    }

    public function getFilename(): string
    {
        return self::FILENAME;
    }

    public function getOrder()
    {
        return 2;
    }
}
