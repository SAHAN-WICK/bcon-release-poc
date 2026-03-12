#!/bin/sh
set -e

ssh -i "$SSH_KEY_FILE" -o StrictHostKeyChecking=no \
  "$UAT_USER@$UAT_HOST" \
  "rm -rf '$UAT_RELEASE_PATH/$BCON_FILE' && mkdir -p '$UAT_RELEASE_PATH'"

scp -i "$SSH_KEY_FILE" -o StrictHostKeyChecking=no -r \
  "incoming/$BCON_FILE" \
  "$UAT_USER@$UAT_HOST:$UAT_RELEASE_PATH/"

echo "Pushed folder from Jenkins workspace to UAT"