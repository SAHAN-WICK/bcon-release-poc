#!/bin/sh
set -e

if [ ! -d "$UAT_RELEASE_PATH/$BCON_FILE" ]; then
  echo "ERROR: Folder not found in UAT RELEASE path after copy"
  exit 1
fi

(
  cd "$DEV_SAVE_PATH"
  find "$BCON_FILE" -type d | sort > "$WORKSPACE/dev_dirs.txt"
  find "$BCON_FILE" -type f | sort > "$WORKSPACE/dev_files.txt"
)

(
  cd "$UAT_RELEASE_PATH"
  find "$BCON_FILE" -type d | sort > "$WORKSPACE/uat_dirs.txt"
  find "$BCON_FILE" -type f | sort > "$WORKSPACE/uat_files.txt"
)

diff -u "$WORKSPACE/dev_dirs.txt" "$WORKSPACE/uat_dirs.txt"
diff -u "$WORKSPACE/dev_files.txt" "$WORKSPACE/uat_files.txt"

(
  cd "$DEV_SAVE_PATH"
  find "$BCON_FILE" -type f -exec sha256sum "{}" \; | sort > "$WORKSPACE/dev_checksums.txt"
)

(
  cd "$UAT_RELEASE_PATH"
  find "$BCON_FILE" -type f -exec sha256sum "{}" \; | sort > "$WORKSPACE/uat_checksums.txt"
)

diff -u "$WORKSPACE/dev_checksums.txt" "$WORKSPACE/uat_checksums.txt"

echo "Folder structure and content verification passed"