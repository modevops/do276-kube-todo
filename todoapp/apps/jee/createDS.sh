#!/bin/bash

# First download Wildfly from wildfly.org and untar/unzip on the home folder
# Automate this step on the Vagrantfile?

source ./env.sh

# Initialize the MySQL database

sudo systemctl start mysql55-mysqld
#sudo systemctl enable mysql55-mysqld

sudo scl enable mysql55 -- mysql <<EOF
    create database items;
    grant all on items* to user1@"127.0.0.1" identified by 'mypa55';
EOF
source /opt/rh/mysql55/enable
mysql -h127.0.0.1 -utodo -predhat todo < src/main/resources/sql/create.sql
mysql -h127.0.0.1 -utodo -predhat todo < src/main/resources/sql/load.sql


# Create the Datasource

ln -s /usr/share/java/mysql-connector-java.jar $WILDFLY_HOME/standalone/deployments/

cd $WILDFLY_HOME/bin
# using local auth
./jboss-cli.sh --connect --controller=localhost:31990 <<EOF2
    data-source add --driver-name=mysql-connector-java.jar --name=MySQLDS --jndi-name=java:jboss/datasources/MySQLDS --user-name=user1 --password=mypa55 --connection-url=jdbc:mysql://127.0.0.1/items
    ./subsystem=datasources/data-source=MySQLDS:test-connection-in-pool
EOF2

