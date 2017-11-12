#!/bin/sh

rm -fr build
mkdir -p build
sudo rm -fr linked/work
cp -a ../../apps/jee_api/* build
cd build
mvn clean install
if [ $? -eq 0 ]; then
  cd ..
  docker build -t do276/todoapi_jee .
fi
