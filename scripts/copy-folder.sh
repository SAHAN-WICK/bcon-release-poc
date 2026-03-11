#!/bin/sh
set -e

rm -rf "$UAT_RELEASE_PATH/$BCON_FILE"
cp -r "$DEV_SAVE_PATH/$BCON_FILE" "$UAT_RELEASE_PATH/"

echo "Folder copied to UAT RELEASE path"