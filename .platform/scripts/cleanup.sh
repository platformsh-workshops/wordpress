#!/usr/bin/env bash

ddev delete -y
ddev poweroff
rm -rf .ddev
rm -rf wordpress
rm -rf vendor
rm composer.json composer.lock
rm wp-config-ddev.php