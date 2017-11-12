#!/bin/sh

sudo rm -fr linked/work

rm -fr build
mkdir -p build
cp -a ../../apps/php/todo build
cp -p ../../apps/php_api/todo/api/db.php build/todo/api
# Ugly hack #2: make all app files world-writable so composer can write to app directories
chmod -R a+rwX build
# End of Ugly hack #2

cp approot.sh build
docker build -t do276/todophp .
