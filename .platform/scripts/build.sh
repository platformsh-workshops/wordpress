#!/usr/bin/env bash

TMP_BUILD=build
RUNTIME_VERSION=$(yq -r '.type | split(":") | .[1]' .platform.app.yaml)

# Setup PHP
# brew install php@7.4
brew unlink php && brew link --overwrite --force php@$RUNTIME_VERSION
php -v

# Create the project
composer create-project johnpbloch/wordpress $TMP_BUILD --no-plugins
cd $TMP_BUILD

# Composer: allow-plugins
composer config --no-plugins allow-plugins.johnpbloch/wordpress-core-installer true
composer config --no-plugins allow-plugins.composer/installers true

# Composer: name
composer config name platformsh/workshop-wordpress

# Composer: description
composer config description "Platform.sh fundamentals workshop using Composer-based WordPress."

# Composer: platform
composer config platform.php $RUNTIME_VERSION

# Composer: repositories
composer config repositories.0 --json '{"type": "composer", "url": "https://wpackagist.org"}'

# Composer: scripts
composer config scripts.subdirComposer.0 "cp wp-config.php wordpress/ && rm -rf wordpress/wp-content/wp-content"
composer config scripts.post-install-cmd "@subdirComposer"

# Composer: extra.installer-paths
composer config extra.installer-paths --json '{"wordpress/wp-content/plugins/{$name}":["type:wordpress-plugin"], "wordpress/wp-content/themes/{$name}":["type:wordpress-theme"], "wordpress/wp-content/mu-plugins/{$name}":["type:wordpress-muplugin"]}'

# Composer: Additional dependencies
# - Unpin johnpblock/wordpress-core
UPSTREAM_VERSION=$(cat composer.json | jq -r '.require["johnpbloch/wordpress-core"]')
composer require johnpbloch/wordpress-core "^$UPSTREAM_VERSION"
# - P.sh specific
# * TODO: Remove config-reader requirement.
# * TODO: inlude P.sh script.
composer require platformsh/config-reader wp-cli/wp-cli-bundle psy/psysh
# - Themes
composer require wpackagist-theme/twentynineteen wpackagist-theme/twentytwentyone wpackagist-theme/twentytwenty
# - Plugins
composer require wpackagist-plugin/akismet

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

# mkdir plugins
# curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/plugins/README.txt" > plugins/README.txt

# mkdir .platform
# curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/.platform.app.yaml" > .platform.app.yaml
# curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/.platform/services.yaml" > .platform/services.yaml
# curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/.platform/routes.yaml" > .platform/routes.yaml

# Copy over files
cd ..
rsync -aP --exclude .git --exclude README.md --exclude wp-config.php $TMP_BUILD/ .

# Cleanup
rm -rf $TMP_BUILD

# Final composer update
composer update

# Commit the changes
# git add .
# git commit -m "Update workshop base."

# To reset to original php version
brew unlink php && brew link php
# To reset to original composer version
# composer self-update --2
