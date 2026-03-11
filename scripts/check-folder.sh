#!/bin/sh
set -e

if [ -z "$DEV_SAVE_PATH" ] || [ -z "$BCON_FILE" ]; then
  echo "ERROR: DEV_SAVE_PATH or BCON_FILE is missing"
  exit 1
fi

if [ ! -d "$DEV_SAVE_PATH/$BCON_FILE" ]; then
  echo "ERROR: Folder not found in DEV SAVE path: $DEV_SAVE_PATH/$BCON_FILE"
  exit 1
fi

echo "Folder found in DEV SAVE path"