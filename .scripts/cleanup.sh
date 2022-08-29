#!/usr/bin/env bash

cleanup () {
    clear
    ddev delete -y
    ddev poweroff
    rm -rf .ddev
    rm -rf wordpress
    rm -rf vendor
    rm composer.json composer.lock
}

cleanup
