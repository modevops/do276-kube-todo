#!/bin/bash

source /opt/rh/rh-php56/enable

cd todo/api
php -r "readfile('https://getcomposer.org/installer');" | php
#./composer.phar install --no-interaction --no-ansi --no-scripts --optimize-autoload
./composer.phar install

cd ../..
sudo cp -r todo /opt/rh/httpd24/root/var/www/html

