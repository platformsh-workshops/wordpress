# Steps

## Fundamentals

### Setup local

1. Clone the repo
1. `composer install`
1. `.scripts/configure-ddev.sh`
1. `ddev start`
1. `.scripts/install-wordpress.sh`
1. `.scripts/seed-wordpress.sh`
1. Verify local

### Deploy to P.sh

1. platform create
1. Add platform config
1. Create GitHub repo?
1. Create integration?
1. git push platform main
1. `platform ssh`
1. `.scripts/install-wordpress.sh`

### Re-sync local

1. PROJECT_ID=$(platform project:info id)
1. ddev config --web-environment-add="PLATFORM_PROJECT=${PROJECT_ID}"
1. ddev config --web-environment-add="PLATFORM_ENVIRONMENT=main"
1. Sync data to P.sh (no data): `ddev pull platform -y`
1. `platform ssh`
1. `.scripts/seed-wordpress.sh`
1. Restore local data: `ddev pull platform -y`

### Variables, data, environments, inheritance

1. Something

### New features

1. Something

### Next steps

1. Something

### Adding features

## Decoupled

Repeated from above

## Setup local

Repeated from above

## Deploy to P.sh

Repeated from above


