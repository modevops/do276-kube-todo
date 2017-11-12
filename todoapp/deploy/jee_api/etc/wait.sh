#!/bin/sh

set -e

host=$(env | grep MYSQL.*_TCP_ADDR | cut -d = -f 2)
port=$(env | grep MYSQL.*_TCP_PORT | cut -d = -f 2)

echo "improved wait for kube."
echo "waiting for TCP connection to $host:$port..."

while [ "$(echo X | nc -w 1 $host $port 2>/dev/null | grep -c mysql_native_password)" = "0" ]
do
  echo -n .
  sleep 1
done

echo 'ok'
