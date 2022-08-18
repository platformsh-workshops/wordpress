#!/usr/bin/env bash

UPSTREAM_REPO=https://github.com/johnpbloch/wordpress.git
UPSTREAM_REMOTE=upstream

UPSTREAM_CHECKOUT=6.0.1

RUNTIME_VERSION='8.1'

CURRENT_BRANCH=$(git branch --show-current)

# Create build dir
mkdir build && cd build
git init

# Upstream repo
git remote add upstream $UPSTREAM_REPO
git remote -v

# Upstream fetch
git fetch $UPSTREAM_REMOTE --depth=2
git fetch $UPSTREAM_REMOTE --tags
git checkout $UPSTREAM_CHECKOUT
# git switch -c $CURRENT_BRANCH

# Composer: name
composer config name platformsh/fundamentals-wordpress

# Composer: description
composer config description "Platform.sh fundamentals workshop using Composer-based WordPress."

# Composer: allow-plugins
composer config --no-plugins allow-plugins.johnpbloch/wordpress-core-installer true
composer config --no-plugins allow-plugins.composer/installers true

# Composer: platform
# composer config platform.php $RUNTIME_VERSION

# Composer: repositories
composer config repositories.0 --json '{"type": "composer", "url": "https://wpackagist.org"}'

# Composer: scripts
composer config scripts.subdirComposer.0 "cp wp-config.php wordpress/ && rm -rf wordpress/wp-content/wp-content"
composer config scripts.post-install-cmd "@subdirComposer"

# Composer: extra.installer-paths
composer config extra.installer-paths --json '{"wordpress/wp-content/plugins/{$name}":["type:wordpress-plugin"], "wordpress/wp-content/themes/{$name}":["type:wordpress-themes"], "wordpress/wp-content/mu-plugins/{$name}":["type:wordpress-muplugin"]}'

# Composer dependencies
composer install
# Unpin johnpblock/wordpress-core
composer require johnpbloch/wordpress-core "^$UPSTREAM_CHECKOUT"
composer require platformsh/config-reader wp-cli/wp-cli-bundle psy/psysh

# Prettify
cat composer.json | jq > composer-pretty.json
rm composer.json && mv composer-pretty.json composer.json

# Composer: update
composer update

# Get files
curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/wp-config.php" > wp-config.php
curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/wp-cli.yml"  > wp-cli.yml
curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/.editorconfig" > .editorconfig
curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/.gitignore" > .gitignore
curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/.lando.upstream.yml" > .lando.upstream.yml
curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/example.wp-config-local.php" > example.wp-config-local.php

mkdir plugins
curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/plugins/README.txt" > plugins/README.txt

mkdir .platform
curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/.platform.app.yaml" > .platform.app.yaml
curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/.platform/services.yaml" > .platform/services.yaml
curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/.platform/routes.yaml" > .platform/routes.yaml

# Copy over files
cd ..
rsync -aP --exclude .git --exclude vendor --exclude README.md build/ .
rm -rf build

# Final composer update
composer update

# Commit the changes
git add .
git commit -m "Update workshop base."
