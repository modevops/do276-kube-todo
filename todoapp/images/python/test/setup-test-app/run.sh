#!/bin/bash
source /etc/profile.d/enable-python34.sh
source /opt/app-root/etc/generate_container_user

function is_gunicorn_installed() {
  hash gunicorn &>/dev/null
}

function is_django_installed() {
  python -c "import django" &>/dev/null
}

function should_migrate() {
  is_django_installed && [[ -z "$DISABLE_MIGRATE" ]]
}

set -e

# Find shallowest manage.py script, either ./manage.py or <project>/manage.py
manage_file=$(find . -maxdepth 2 -type f -name 'manage.py' -printf '%d\t%P\n' | sort -nk1 | cut -f2 | head -1)

if should_migrate; then
  if [[ -f "$manage_file" ]]; then
    echo "---> Migrating database ..."
    python "$manage_file" migrate --noinput
  else
    echo "WARNING: seems that you're using Django, but we could not find a 'manage.py' file."
    echo "Skipped 'python manage.py migrate'."
  fi
fi

if is_gunicorn_installed; then
  if [[ -z "$APP_MODULE" ]]; then
    # Find shallowest wsgi.py file, one of ./wsgi.py, <project>/wsgi.py or <project>/<project>/wsgi.py,
    # replace "/" with "." and remove ".py" suffix
    APP_MODULE=$(find . -maxdepth 3 -type f -name 'wsgi.py' -printf '%d\t%P\n' | sort -nk1 | cut -f2 | head -1 | sed 's:/:.:;s:.py$::')
  fi

  if [[ -z "$APP_MODULE" && -f setup.py ]]; then
    APP_MODULE="$(python setup.py --name)"
  fi

  if [[ "$APP_MODULE" ]]; then
    echo "---> Serving application with gunicorn ($APP_MODULE) ..."
    exec gunicorn "$APP_MODULE" --bind=0.0.0.0:8080 --access-logfile=- --config "$APP_CONFIG"
  fi
fi

if is_django_installed; then
  if [[ -f "$manage_file" ]]; then
    echo "---> Serving application with 'manage.py runserver' ..."
    echo "WARNING: this is NOT a recommended way to run you application in production!"
    echo "Consider using gunicorn or some other production web server."
    exec python "$manage_file" runserver 0.0.0.0:8080
  else
    echo "WARNING: seems that you're using Django, but we could not find a 'manage.py' file."
    echo "Skipped 'python manage.py runserver'."
  fi
fi

APP_FILE="${APP_FILE:-app.py}"
if [[ "$APP_FILE" ]]; then
  if [[ -f "$APP_FILE" ]]; then
    echo "---> Running application from Python script ($APP_FILE) ..."
    exec python "$APP_FILE"
  fi
  echo "WARNING: file '$APP_FILE' not found."
fi

>&2 echo "ERROR: don't know how to run your application."
>&2 echo "Please set either APP_MODULE or APP_FILE environment variables, or create a file 'app.py' to launch your application."
exit 1
