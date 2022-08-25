#!/usr/bin/env bash

# Install WordPress
ddev wp core install --url="${WP_SITEURL}" --title="Platform.sh Workshop" --admin_user="admin" --admin_password="Admin1234" --admin_email="admin@example.com" --path='wordpress'

# Enable plugins

# Set permalink structure
ddev wp option update "permalink_structure" "/%year%/%monthnum%/%postname%/" --path='wordpress'
ddev wp rewrite flush --path='wordpress'

# Remove the first blog post
ddev wp post delete 1 --path='wordpress'

# Create content
ddev exec 'php .platform/scripts/create-posts.php .platform/scripts/dummy-posts.json 15'
