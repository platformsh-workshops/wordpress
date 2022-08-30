#!/usr/bin/env bash

TEMP_DIR=nextjs-frontend

git clone https://github.com/platformsh-templates/nextjs-wordpress.git $TEMP_DIR

# Copy over frontend
rsync -aP $TEMP_DIR/client/ nextjs

# Cleanup 
rm -rf $TEMP_DIR
