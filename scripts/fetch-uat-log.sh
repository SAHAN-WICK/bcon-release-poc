#!/bin/sh
set -e

mkdir -p artifacts/logs

scp -i "$SSH_KEY_FILE" -o StrictHostKeyChecking=no \
  "$UAT_USER@$UAT_HOST:$UAT_LOG_PATH/$BCON_FILE.log" \
  artifacts/logs/

echo "Fetched UAT log into Jenkins workspace"