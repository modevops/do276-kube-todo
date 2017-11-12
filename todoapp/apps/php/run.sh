#!/bin/bash

# assume MySQL 5.5 from SCL already has data
echo "Starting MySQL..."
sudo systemctl start mysql55-mysqld

# php app runs inside apachce httpd
echo "Changing Apache httpd to listen port 30080 instead of 30000..."
sudo sed -i 's/Listen 30000/Listen 30080/' /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf
echo "Starting httpd"
sudo systemctl start httpd24-httpd

echo "Please visit http://localhost:30080/todo/"
echo "Type [Enter] when finished"
read

echo "Stopping httpd"
sudo systemctl stop httpd24-httpd
echo "Changing Apache httpd back to listen port 30000..."
sudo sed -i 's/Listen 30080/Listen 30000/' /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf
echo "Stopping MySQL"
sudo systemctl stop mysql55-mysqld

