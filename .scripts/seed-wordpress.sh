#!/usr/bin/env bash

# Remove the first blog post
ddev wp post delete 1 --path='wordpress'

# Create content
ddev exec 'php .platform/scripts/seed/create-posts.php .platform/scripts/seed/dummy-posts.json 15'
