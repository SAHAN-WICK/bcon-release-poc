#!/bin/sh
set -e

mkdir -p artifacts/release artifacts/logs artifacts/verification

cp -r "$UAT_RELEASE_PATH/$BCON_FILE" artifacts/release/
cp "$UAT_LOG_PATH/$BCON_FILE.log" artifacts/logs/

cp "$WORKSPACE/dev_dirs.txt" artifacts/verification/
cp "$WORKSPACE/uat_dirs.txt" artifacts/verification/
cp "$WORKSPACE/dev_files.txt" artifacts/verification/
cp "$WORKSPACE/uat_files.txt" artifacts/verification/
cp "$WORKSPACE/dev_checksums.txt" artifacts/verification/
cp "$WORKSPACE/uat_checksums.txt" artifacts/verification/

echo "Evidence copied into workspace artifacts folder"