<?php

namespace App\Manager;

interface ManagerInterface
{
    public function getRepository();

    public function save($entity, bool $flush = true);

    public function remove($entity, bool $flush = true);

    public function persist($entity);

    public function flush();
}
