#!/bin/bash -x

cd test
docker build -t do276/test-php .
docker run -d --name test-php -p 30080:8080 do276/test-php
sleep 3
# Expected result is "Hello there" no HTML formatting
curl http://127.0.0.1:30080/hello.php
echo
docker stop test-php
docker rm test-php
