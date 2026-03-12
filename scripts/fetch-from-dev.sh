#!/bin/sh
set -e

mkdir -p incoming
rm -rf "incoming/$BCON_FILE"

scp -i "$SSH_KEY_FILE" -o StrictHostKeyChecking=no -r \
  "$DEV_USER@$DEV_HOST:$DEV_SAVE_PATH/$BCON_FILE" \
  incoming/

echo "Fetched folder from DEV into Jenkins workspace"