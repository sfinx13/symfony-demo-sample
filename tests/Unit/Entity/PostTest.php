<?php

namespace App\Tests\Unit\Entity;

use App\Entity\Behaviour\EntitySlugableInterface;
use App\Entity\Enum\Status;
use App\Entity\Post;
use PHPUnit\Framework\TestCase;

class PostTest extends TestCase
{
    public function testPostIsStringable()
    {
        $post = (new Post())
            ->setTitle('Title')
            ->setContent('Content')
            ->setStatus(Status::DRAFT)
            ->setPublishedAt(new \DateTimeImmutable());

        $this->assertEquals('Title', $post);
        $this->assertInstanceOf(EntitySlugableInterface::class, $post);
    }
}
