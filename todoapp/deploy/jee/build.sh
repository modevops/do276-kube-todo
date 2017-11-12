#!/bin/sh

rm -fr build
mkdir -p build
cp -a ../../apps/jee/* build
cd build
mvn clean install
if [ $? -eq 0 ]; then
  cd ..
  # docker build complains if he cannot read the database folder even if not needed for building the image
  sudo rm -rf {linked,kubernetes}/work
  docker build -t do276/todojee .
fi
