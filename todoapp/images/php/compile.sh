#!/bin/bash 

set -e

if [ -r ./approot.sh ]; then
  source ./approot.sh
else
  APPROOT=.
fi
cd $APPROOT

if [ -f ./composer.json ]; then
  echo "Found 'composer.json', installing dependencies using composer.phar... "

  # Install Composer
  php -r "readfile('https://getcomposer.org/installer');" | php

  # Install App dependencies using Composer
  ./composer.phar install --no-interaction --no-ansi --no-scripts --optimize-autoloader

  if [ -f composer.phar ]; then
    echo -e "\nConsider adding a 'composer.lock' file into your source repository.\n"
  fi
fi
