<?php

$dsn = 'mysql:host=' . getenv('MYSQL_PORT_3306_TCP_ADDR') . ':' . getenv('MYSQL_PORT_3306_TCP_PORT') . ';dbname='. getenv('MYSQL_ENV_MYSQL_DATABASE');
$user = getenv('MYSQL_ENV_MYSQL_USER');
$pass = getenv('MYSQL_ENV_MYSQL_PASSWORD');

?>
