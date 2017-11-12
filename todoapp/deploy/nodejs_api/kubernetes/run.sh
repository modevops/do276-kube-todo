#!/bin/bash

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
kubectl create -f nodejs.yaml
kubectl create -f nodejs-service.yaml
kubectl create -f ui.yaml
kubectl create -f ui-service.yaml
