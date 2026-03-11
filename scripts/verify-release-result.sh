#!/bin/sh
set -e

LOG_FILE="$UAT_LOG_PATH/$BCON_FILE.log"

if [ ! -f "$LOG_FILE" ]; then
  echo "ERROR: Release log not found: $LOG_FILE"
  exit 1
fi

grep -i "SUCCESS" "$LOG_FILE"

echo "Release result verification passed"