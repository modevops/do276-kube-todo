#!/bin/sh 

# only works if delete /tmp/work else mysql pod keeps restarting
sudo rm -rf /tmp/work

if [ ! -d "/tmp/work" ]; then
  echo "Create database volume..."
  mkdir -p /tmp/work/init /tmp/work/data
  cp db.sql /tmp/work/init
  sudo chown -R 27:27 /tmp/work
  sudo chcon -Rt svirt_sandbox_file_t /tmp/work
else
  rm -fr /tmp/work/init/*
fi

kubectl create -f pv.yaml
sleep 15
kubectl create -f dbclaim.yaml
sleep 15
kubectl create -f dbinit.yaml
sleep 15
kubectl create -f mysql.yaml
sleep 15
kubectl create -f mysql-service.yaml
sleep 15
kubectl create -f wildfly.yaml
kubectl create -f wildfly-service.yaml
