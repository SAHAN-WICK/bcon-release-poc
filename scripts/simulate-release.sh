#!/bin/sh
set -e

LOG_FILE="$UAT_LOG_PATH/$BCON_FILE.log"

echo "INFO: Starting simulated BCON release" > "$LOG_FILE"
echo "INFO: Folder name = $BCON_FILE" >> "$LOG_FILE"
echo "INFO: Executing ETS EX" >> "$LOG_FILE"
echo "INFO: Sending CTRL+U" >> "$LOG_FILE"
echo "SUCCESS: BCON release completed successfully" >> "$LOG_FILE"

echo "Simulated release log created at $LOG_FILE"