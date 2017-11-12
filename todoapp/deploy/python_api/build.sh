#!/bin/sh
rm -fr build
mkdir -p build
sudo rm -fr linked/work
cp -a ../../apps/python_api/* build
docker build -t do276/todoapi_python .
