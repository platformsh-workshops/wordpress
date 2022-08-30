#!/usr/bin/env bash

TMP_BUILD=build
RUNTIME_VERSION=$(yq -r '.type | split(":") | .[1]' .platform.app.yaml)

setup_php_env () {
    # Setup PHP
    # brew install php@7.4
    brew unlink php && brew link --overwrite --force php@$RUNTIME_VERSION
    php -v
}

reset_php_env () {
    # To reset to original php version
    brew unlink php && brew link php
    # To reset to original composer version
    # composer self-update --2
}

#######################################################
setup_php_env

# Create the project
composer create-project johnpbloch/wordpress $TMP_BUILD --no-plugins --no-install
rsync -aP --exclude vendor --exclude README.md $TMP_BUILD/ .
rm -rf $TMP_BUILD

# Composer: allow-plugins
composer config --no-plugins allow-plugins.johnpbloch/wordpress-core-installer true
composer config --no-plugins allow-plugins.composer/installers true

# Composer: name
composer config name platformsh/workshop-wordpress

# Composer: description
composer config description "Platform.sh fundamentals workshop using Composer-based WordPress."

# Composer: repositories
composer config repositories.0 --json '{"type": "composer", "url": "https://wpackagist.org"}'

# Composer: scripts
composer config scripts.subdirComposer.0 "cp wp-config.php wordpress/ && rm -rf wordpress/wp-content/wp-content"
composer config scripts.post-install-cmd "@subdirComposer"

# Composer: install-dir.
composer config extra.wordpress-install-dir "wordpress"

# Composer: extra.installer-paths
composer config extra.installer-paths --json '{"wordpress/wp-content/plugins/{$name}":["type:wordpress-plugin"], "wordpress/wp-content/themes/{$name}":["type:wordpress-theme"], "wordpress/wp-content/mu-plugins/{$name}":["type:wordpress-muplugin"]}'

# Composer: Unpin wordpress-core
UPSTREAM_VERSION=$(cat composer.json | jq -r '.require["johnpbloch/wordpress-core"]')
composer remove johnpbloch/wordpress-core --no-install
composer require johnpbloch/wordpress-core "^$UPSTREAM_VERSION" --no-install

# Composer: additional dependencies
composer require wp-cli/wp-cli-bundle psy/psysh --no-install
composer require platformsh/config-reader --no-install

# Composer: WP Themes
composer require wpackagist-theme/twentynineteen wpackagist-theme/twentytwenty wpackagist-theme/twentytwentyone wpackagist-theme/twentytwentytwo --no-install

# Composer: decoupled dependencies
# composer require wpackagist-plugin/wp-graphql

# composer require wp-graphql wp-graphql-jwt-authentication headless-frontend-preview wp-graphql-jwt-authentication-wp-cli


# Composer: WP Plugins
composer require wpackagist-plugin/akismet --no-install

# Composer: prettify the composer file.
cat composer.json | jq > composer-pretty.json
rm composer.json && mv composer-pretty.json composer.json

# Run a clean composer install with everything.
# rm -rf vendor wordpress & rm composer.lock
composer install

# Get Platform.sh files.
curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/.editorconfig" > .editorconfig
curl -s "https://raw.githubusercontent.com/platformsh-templates/wordpress-composer/master/.gitignore" > .gitignore

# Update .gitignore (ignore .ddev config for now)
printf "\n.ddev" >> .gitignore 

reset_php_env
