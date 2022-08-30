
get_nextjs_frontend () {
    TEMP_DIR=nextjs-frontend

    git clone https://github.com/platformsh-templates/nextjs-wordpress.git $TEMP_DIR

    # Copy over frontend
    rsync -aP $TEMP_DIR/client/ nextjs

    # Cleanup 
    rm -rf $TEMP_DIR

}

# Add dependencies
composer require wpackagist-plugin/wp-graphql

# Enable them locally
ddev wp plugin activate wp-graphql
ddev wp plugin activate wp-graphql-jwt-authentication

# Get the nextjs frontend
get_nextjs_frontend

# Update routes.yaml
# TODO: use subpaths, not subdomains
NEXTJS_APP_NAME=$(yq -r '.name' nextjs/.platform.app.yaml)
printf "
https://www.{default}/:
    type: redirect
    to: \"https://{default}/\"

https://{default}/:
    type: upstream
    primary: true
    id: \"nextjs\"
    upstream: \"$NEXTJS_APP_NAME:http\"
" >> .platform/routes.yaml

# Update the frontend.
cd nextjs
rm first_deploy.js README.md
corepack yarn install

BACKEND_URL=$(ddev wp config get WP_HOME)
STRIPPED_URL=$(echo $BACKEND_URL | awk -F/ '{print $3}')

# Local env vars
printf "WORDPRESS_API_URL=${BACKEND_URL}/graphql
IMAGE_DOMAIN=${STRIPPED_URL}" > .env.local

# Platform.sh vars
# TODO: grab the id from routes.yaml
ENVIRONMENT=$(echo $PLATFORM_ROUTES | base64 --decode | jq -r 'to_entries[] | select(.value.id == "api") | .key')
STRIPPED_ENVIRONMENT=\${ENVIRONMENT%%/}

export WORDPRESS_API_URL="${ENVIRONMENT}graphql"
export IMAGE_DOMAIN=$(echo $STRIPPED_ENVIRONMENT | awk -F/ '{print $3}')
printf "
ENVIRONMENT=\$(echo \$PLATFORM_ROUTES | base64 --decode | jq -r 'to_entries[] | select(.value.id == \"api\") | .key')
STRIPPED_ENVIRONMENT=\${ENVIRONMENT%%/}

export WORDPRESS_API_URL=\"\${ENVIRONMENT}graphql\"
export IMAGE_DOMAIN=\$(echo \$STRIPPED_ENVIRONMENT | awk -F/ '{print \$3}')
" > .environment

# Update next.config.js (https://nextjs.org/docs/messages/generatebuildid-not-a-string)
printf "
module.exports = {
  images: {
    domains: [
	  process.env.IMAGE_DOMAIN,
      'secure.gravatar.com',
    ],
  },
  generateBuildId: async () => {
    return process.env.PLATFORM_TREE_ID || 'some random string'
  }
}
" > next.config.js

# We need to explictly tell Node to trust mkcert CAs.
export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"

corepack yarn build

printf "\nNext.JS has finished building.

Run the built site with the following:

    cd nextjs
    corepack yarn start

"

# Update .gitignore (ignore nextjs app for now)
# printf "\nnextjs" >> ../.gitignore 

