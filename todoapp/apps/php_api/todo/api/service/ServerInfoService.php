<?php

namespace service;

class ServerInfoService
{

    private $app;

    public function __construct($app) {
        $this->app = $app;
    }

    public function hostnameAndIP() {
        $data = array(
            "hostname" => getHostName(),
            "ip" => getHostByName(getHostName()) //
        );
        $this->app->response->write(json_encode($data));
    }

}

?>
