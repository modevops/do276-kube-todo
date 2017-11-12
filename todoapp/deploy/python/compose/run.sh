#!/bin/sh 
if [ ! -d "data" ]; then
  echo "Create database volume..."
  mkdir -p data initdb
  chcon -Rt svirt_sandbox_file_t data initdb
  chmod o+rwx data
  cp db.sql initdb 
else
  rm -fr initdb/*
fi

scl enable python34 "docker-compose up -d"
