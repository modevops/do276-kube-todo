<?php

namespace model;

class Item
{
    public $id;
    public $description;
    public $done;
    
    public function __construct($id, $description, $done) {
        if($id)           
            $this->id = (int)$id;
        $this->description = $description;
        $this->done = $done ? true : false;
    }
}

?>
