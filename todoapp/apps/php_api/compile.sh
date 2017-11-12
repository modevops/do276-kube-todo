#!/bin/bash

echo "Assumes you first compiled the html5 front end"

source /opt/rh/rh-php56/enable

cd todo/api
php -r "readfile('https://getcomposer.org/installer');" | php
#./composer.phar install --no-interaction --no-ansi --no-scripts --optimize-autoload
./composer.phar install

cd ../..
sudo rm -rf /opt/rh/httpd24/root/var/www/php_api
sudo mkdir /opt/rh/httpd24/root/var/www/php_api
sudo chcon -t httpd_sys_content_t /opt/rh/httpd24/root/var/www/php_api
sudo cp -r todo /opt/rh/httpd24/root/var/www/php_api

