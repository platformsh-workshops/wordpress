
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
cd nextjs
rm first_deploy.js README.md
corepack yarn install

BACKEND_URL=$(ddev wp config get WP_HOME)
STRIPPED_URL=$(echo $BACKEND_URL | awk -F/ '{print $3}')

# Local env vars
printf "WORDPRESS_API_URL=${BACKEND_URL}/graphql
IMAGE_DOMAIN=${STRIPPED_URL}" > .env.local

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

export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"

corepack yarn build

printf "\nNext.JS has finished building.

Run the built site with the following:

    cd nextjs
    corepack yarn start

"

# Update .gitignore (ignore nextjs app for now)
printf "\nnextjs" >> ../.gitignore 

