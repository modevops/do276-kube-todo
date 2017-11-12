#!/bin/sh

sudo rm -fr linked/work

rm -fr build
mkdir -p build
cp -a ../../apps/php_api/todo build
# Ugly hack #2: make all app files world-writable so composer can write to app directories
chmod -R a+rwX build
# End of Ugly hack #2

cp approot.sh build
docker build -t do276/todoapi_php .
