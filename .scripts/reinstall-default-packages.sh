#!/usr/bin/env bash

# WordPress is not managed with Composer by default. Likewise, built-in themes and plugs are a part of core when downloaded through Composer,
#   rather than being managed by Composer themselves. Running this script during the build hook removes the upstream downloads, and then reinstalls 
#   so they become Composer-managed.

subdir_remove () {
    printf "\nRemoving the below from $1:\n"
    for directory in `find $1 -type d -maxdepth 1 -mindepth 1`
    do
        echo "  - $directory"
        rm -rf $directory
    done
}

subdir_remove wordpress/wp-content/themes
subdir_remove wordpress/wp-content/plugins

composer install