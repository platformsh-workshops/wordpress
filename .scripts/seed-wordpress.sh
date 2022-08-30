#!/usr/bin/env bash

if [[ -z "${PLATFORM_PROJECT_ENTROPY}" ]]; then
    printf "\nNot on a Platform.sh environment.\n"
    # Remove the first blog post
    ddev wp post delete 1 --path='wordpress'

    # Create content
    ddev exec 'php .scripts/seed/create-posts.php .scripts/seed/dummy-posts.json 15'
else
    printf "\nOn a Platform.sh environment.\n"
    # Remove the first blog post
    wp post delete 1 --path='wordpress'

    # Create content
    php .scripts/seed/create-posts.php .scripts/seed/dummy-posts.json 15
fi
