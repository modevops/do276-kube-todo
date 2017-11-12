<?php

namespace service;

class ItemsService
{

    private $app;
    private $dao;

    public function __construct($app, $dao) {
        $this->app = $app;
        $this->dao = $dao;
        //XXX initialize $app here failed because $this not available in constructor for closures
    }

    public function findItems($page, $maxResults, $start, $pageSize, $sortFields, $sortDirections) {
        $items = $this->dao->findItems($start, $maxResults, $sortFields, $sortDirections);
        $data = array (
            "currentPage" => $page,
            "list" => $items,
            "pageSize" => $pageSize,
            "sortDirections" => $sortDirections,
            "sortFields" => $sortFields,
            "totalResults" => count($this->dao->listAll())
        );
        // Not needed, CORS done by .htaccess
        //$response = $this->app->response();
        //$response->header('Access-Control-Allow-Origin', '*');
        $this->app->response->write(json_encode($data));
    }


    public function listAll() {
        $items = $this->dao->listAll();
        $data = array (
            "currentPage" => 1,
            "list" => $items,
            "pageSize" => 10,
            "sortDirections" => "asc",
            "sortFields" => "id",
            "totalResults" => count($items)
        );
        // Not needed, CORS done by .htaccess
        //$response = $this->app->response();
        //$response->header('Access-Control-Allow-Origin', '*');
        $this->app->response->write(json_encode($data));
    }

    public function read($id) {
        $item = $this->dao->read($id);
        $this->app->response->write(json_encode($item));
    }

    public function save() {
        //TODO: how to get JSON body request and parse into Item instance?
        $item = json_decode($this->app->request->getBody());
        if (!property_exists($item, 'done')) {
            $item->done = false;
        }
        if (property_exists($item, 'id')) {
            $this->dao->update($item);
        }
        else {
            $this->dao->create($item);
        }
        $this->app->response->write(json_encode($item));
    }

    public function delete($id) {
        $this->dao->delete($id);
        //TODO: how to return HTTP 200 without data? [do nothing?]
    }

}

?>
