#!/usr/bin/env bash

.scripts/cleanup.sh
.scripts/build.sh
.scripts/configure-ddev.sh

.scripts/reinstall-default-packages.sh

ddev start

.scripts/install-wordpress.sh
.scripts/seed-wordpress.sh
.scripts/decouple/modify.sh
