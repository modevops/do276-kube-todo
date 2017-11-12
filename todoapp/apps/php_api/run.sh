#!/bin/bash

# XXX front end gets 404 when calling API, can't find the reason

# assume MySQL 5.5 from SCL already has data
echo "Starting MySQL..."
sudo systemctl start mysql55-mysqld

# php app runs inside apachce httpd virtual host to look like a different web server
echo "Configuring api vhost..."
sudo cp php_api.conf /opt/rh/httpd24/root/etc/httpd/conf.d

# html5 front end runs inside apache httpd
echo "Starting httpd"
sudo systemctl start httpd24-httpd


echo "Please visit http://localhost:30000/todo/"
echo "Type [Enter] when finished"
read

echo "Stopping httpd"
sudo systemctl stop httpd24-httpd
echo "Stopping MySQL"
sudo systemctl stop mysql55-mysqld

