<?php

namespace App\Tests\Functional\Manager;

use App\Entity\Category;
use App\Manager\CategoryManager;
use Doctrine\Persistence\ManagerRegistry;
use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;

class CategoryManagerTest extends KernelTestCase
{
    protected ManagerRegistry $managerRegistry;

    protected function setUp(): void
    {
        $kernel = self::bootKernel();
        $this->managerRegistry = static::getContainer()->get(ManagerRegistry::class);
    }

    public function testSaveCategoryWithManagerService()
    {
        $category = (new Category())->setTitle('Sample');
        $categoryManager = (new CategoryManager($this->managerRegistry));
        $categoryManager->save($category);

        /** @var Category $categoryAdded */
        $categoryAdded = $categoryManager->findOneBy(['title' => 'Sample']);

        $this->assertInstanceOf(Category::class, $categoryAdded);
        $this->assertEquals('Sample', $category->getTitle());
        $this->assertEquals('sample', $category->getSlug());
    }
}
