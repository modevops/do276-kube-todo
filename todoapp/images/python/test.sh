#!/bin/bash -x

cd test/standalone-test-app
docker build -t do276/test-python .
docker run -d --name test-python -p 30080:8080 do276/test-python
sleep 3
# Expected result is "Hello there" no HTML formatting
curl http://127.0.0.1:30080/
echo
docker stop test-python
docker rm test-python
