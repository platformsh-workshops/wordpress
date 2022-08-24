#!/usr/bin/env bash

RUNTIME_VERSION='8.1'
HTTP_PORT='8080'

composer install
ddev config --project-type=wordpress --docroot=wordpress --php-version=$RUNTIME_VERSION --http-port=$HTTP_PORT

ddev start
ddev composer install
ddev restart






# ddev config --web-environment-add="PLATFORM_PROJECT=nf4amudfn23bi,PLATFORM_ENVIRONMENT=main"
