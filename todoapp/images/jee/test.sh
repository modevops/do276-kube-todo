#!/bin/bash -x

cd test
docker build -t do276/test-jee .
docker run -d --name test-jee -p 30080:8080 do276/test-jee
sleep 8
# Expected result is Hello, world with no HTML formatting
curl http://127.0.0.1:30080/hello/
