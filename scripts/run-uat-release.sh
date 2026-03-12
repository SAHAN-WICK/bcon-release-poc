#!/bin/sh
set -e

ssh -i "$SSH_KEY_FILE" -o StrictHostKeyChecking=no \
  "$UAT_USER@$UAT_HOST" \
  "mkdir -p '$UAT_LOG_PATH' &&
   LOG_FILE='$UAT_LOG_PATH/$BCON_FILE.log' &&
   echo 'INFO: Starting simulated BCON release' > \"\$LOG_FILE\" &&
   echo 'INFO: Folder name = $BCON_FILE' >> \"\$LOG_FILE\" &&
   echo 'INFO: Executing ETS EX' >> \"\$LOG_FILE\" &&
   echo 'INFO: Sending CTRL+U' >> \"\$LOG_FILE\" &&
   echo 'SUCCESS: BCON release completed successfully' >> \"\$LOG_FILE\""

echo "Executed mocked release on UAT"