#!/usr/bin/env bash

if [[ -z "${PLATFORM_PROJECT_ENTROPY}" ]]; then
    ddev wp plugin activate wp-graphql
    ddev wp plugin activate wp-graphql-jwt-authentication
    # ddev wp plugin activate headless-frontend-preview
    # ddev wp plugin activate wp-graphql-jwt-authentication-wp-cli
else
    wp plugin activate wp-graphql
    wp plugin activate wp-graphql-jwt-authentication
    # wp plugin activate headless-frontend-preview
    # wp plugin activate wp-graphql-jwt-authentication-wp-cli
fi

