<?php

namespace App\Tests\Unit\Entity;

use App\Entity\Behaviour\EntitySlugableInterface;
use App\Entity\Category;
use PHPUnit\Framework\TestCase;

class CategoryTest extends TestCase
{
    public function testCategoryIsStringableAndSluggable()
    {
        $category = (new Category())->setTitle('Category');

        $this->assertEquals('Category', $category);
        $this->assertInstanceOf(EntitySlugableInterface::class, $category);
    }
}