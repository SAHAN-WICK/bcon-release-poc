#!/bin/sh
set -e

mkdir -p artifacts/manifest

RESULT="${RELEASE_RESULT:-SUCCESS}"

cat > artifacts/manifest/release.json <<EOF
{
  "releaseId": "BCON-${BUILD_NUMBER}",
  "bconFolder": "$BCON_FILE",
  "sourcePath": "$DEV_SAVE_PATH/$BCON_FILE",
  "targetPath": "$UAT_RELEASE_PATH/$BCON_FILE",
  "logPath": "$UAT_LOG_PATH/$BCON_FILE.log",
  "buildNumber": "$BUILD_NUMBER",
  "jobName": "$JOB_NAME",
  "buildUrl": "$BUILD_URL",
  "result": "$RESULT"
}
EOF

echo "Release manifest generated at artifacts/manifest/release.json"