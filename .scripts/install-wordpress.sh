#!/usr/bin/env bash

# if [[ -z "${PLATFORM_PROJECT_ENTROPY}" ]]; then
#     printf "\nNot on a Platform.sh environment.\n"
#     # Install WordPress
#     ddev wp core install --url="${WP_SITEURL}" --title="Platform.sh Workshop" --admin_user="admin" --admin_password="Admin1234" --admin_email="admin@example.com" --path='wordpress'

#     # Set permalink structure
#     ddev wp option update "permalink_structure" "/%year%/%monthnum%/%postname%/" --path='wordpress'
#     ddev wp rewrite flush --path='wordpress'
# else
#     printf "\nOn a Platform.sh environment.\n"
#     # Install WordPress
#     wp core install --url="${WP_SITEURL}" --title="Platform.sh Workshop" --admin_user="admin" --admin_password="Admin1234" --admin_email="admin@example.com" --path='wordpress'

#     # Set permalink structure
#     wp option update "permalink_structure" "/%year%/%monthnum%/%postname%/" --path='wordpress'
#     wp rewrite flush --path='wordpress'
# fi

if [[ -z "${PLATFORM_PROJECT_ENTROPY}" ]]; then
    printf "\nNot on a Platform.sh environment.\n"
    # Install WordPress
    ddev wp core install --url="${WP_SITEURL}" --title="Platform.sh Workshop" --admin_user="admin" --admin_password="Admin1234" --admin_email="admin@example.com"

    # Set permalink structure
    ddev wp option update "permalink_structure" "/%year%/%monthnum%/%postname%/"
    ddev wp rewrite flush
else
    printf "\nOn a Platform.sh environment.\n"
    # Install WordPress
    wp core install --url="${WP_SITEURL}" --title="Platform.sh Workshop" --admin_user="admin" --admin_password="Admin1234" --admin_email="admin@example.com"

    # Set permalink structure
    wp option update "permalink_structure" "/%year%/%monthnum%/%postname%/"
    wp rewrite flush
fi
