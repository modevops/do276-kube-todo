#!/bin/bash
source /etc/profile.d/enable-python34.sh

set -e

APP_FILE="${APP_FILE:-app.py}"
if [[ "$APP_FILE" ]]; then
  if [[ -f "$APP_FILE" ]]; then
    echo "---> Running application from Python script ($APP_FILE) ..."
    exec python -u "$APP_FILE"
  fi
  echo "WARNING: file '$APP_FILE' not found."
fi

>&2 echo "ERROR: don't know how to run your application."
>&2 echo "Please set either APP_MODULE or APP_FILE environment variables, or create a file 'app.py' to launch your application."
exit 1
