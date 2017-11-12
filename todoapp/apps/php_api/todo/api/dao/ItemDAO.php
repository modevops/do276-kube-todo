<?php

namespace dao;

require_once 'model/Item.php';


class ItemDAO
{

    private $dsn;
    private $user;
    private $pass;

    private $con;

    public function __construct($dsn, $user, $pass) {
        $this->dsn = $dsn;
        $this->user = $user;
        $this->pass = $pass;
    }

    private function open() {
        $this->con = new \PDO($this->dsn, $this->user, $this->pass, array(
            \PDO::ATTR_PERSISTENT => true
        ));
    }

    private function close() {
        $this->con = null;
    }

    public function listAll() {
        $this->open();
        $result = array();
        foreach ($this->con->query('select id, description, done from Item') as $row) {
            $result[] = new \model\Item($row[0], $row[1], $row[2]);
        }
        $this->close();
        return $result;
    }

    public function findItems($start, $maxResults, $sortFields, $sortDirections) {
        $this->open();
        $result = array();
        foreach ($this->con->query('select * from Item order by ' . $sortFields . ' ' . $sortDirections . ' limit ' . $start . ',' . $maxResults) as $row) {
            $result[] = new \model\Item($row[0], $row[1], $row[2]);
        }
        $this->close();
        return $result;
    }

    public function read($id) {
        $this->open();
        $item = null;
        $stmt = $this->con->prepare('select description, done from Item where id = ?');
        $stmt->execute(array($id));
        $row = $stmt->fetch();
        if ($row) {
            $item = new \model\Item($id, $row[0], $row[1]);
        }
        //XXX can create connection leaks if there is an SQL error?
        $stmt = null;
        $this->close();
        return $item;
    }

    public function create($item) {
        $this->open();
        $stmt = $this->con->prepare('insert into Item (description, done) values (?, ?)');
        $stmt->execute(array($item->description, $item->done));
        //XXX use PDOStatement::rowCount to generate errors?
        $item->id = $this->con->lastInsertId();
        $stmt = null;
        $this->close();
        return $item;
    }

    public function update($item) {
        $this->open();
        $stmt = $this->con->prepare('update Item set description = ?, done = ? where id = ?');
        $stmt->execute(array($item->description, $item->done, $item->id));
        $stmt = null;
        $this->close();
        return $item;
    }

    public function delete($id) {
        if ($id instanceof \model\Item)
            $id = $id->id;
        $this->open();
        $stmt = $this->con->prepare('delete from Item where id = ?');
        $stmt->execute(array($id));
        $stmt = null;
        $this->close();
    }

}

?>
