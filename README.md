# WordPress for Platform.sh workshop

## Examples

https://github.com/platformsh-workshops/nodecongress

## Outline

1. [Platform.sh fundamentals](docs/01-fundamentals.md)
    - Introduction
    - Configuration & deploys
    - Data & services
    - Rolling back changes
    - Next steps
2. Profiling best practices 
3. [Decoupling monoliths and frontend interchangeability](03-multiapp.md)
    - Introduction
    - Deploying the backend
    - Deploying the frontend
    - Inheritance and editorial workflows
    - Next steps
4. [Managing a fleet of WordPress applications](04-fleet.md)
    - Introduction
    - Organizations
    - Managing multiple projects
    - Growing the fleet
    - Managing the fleet
    - Next steps

## Fundamentals

- Setup ddev
- brew install mkcert nss
- ddev composer install
- ddev wp core install --url="${WP_SITEURL}" --title="Deploy Friday" --admin_user="admin" --admin_password="Admin1234" --admin_email="admin@example.com" --path='wordpress'