#!/bin/sh 

sudo rm -rf work

if [ ! -d "work" ]; then
  echo "Create database volume..."

  mkdir -p work/init work/data
  cp db.sql work/init
  sudo chcon -Rt svirt_sandbox_file_t work
  sudo chown -R 27:27 work
else
  sudo rm -fr work/init
fi

docker run -d --name mysql -e MYSQL_DATABASE=items -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 -e MYSQL_ROOT_PASSWORD=r00tpa55 -v $PWD/work/data:/var/lib/mysql/data -v $PWD/work/init:/var/lib/mysql/init -p 30306:3306 do276/mysql-55-rhel7

sleep 9

docker run -d --name=todoapi --link mysql:mysql -p 30080:8080 do276/todoapi_php

sleep 9

docker run -d --name=todoui -p 30000:80 do276/todo_frontend

sleep 9
