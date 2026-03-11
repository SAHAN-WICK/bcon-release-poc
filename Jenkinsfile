pipeline {
    agent any

    parameters {
        string(name: 'BCON_FILE', defaultValue: 'BCON.TEST.001', description: 'Name of the BCON package folder')
    }

    environment {
        DEV_SAVE_PATH = '/lab/DEV/F.BCON.DATA/SAVE'
        UAT_RELEASE_PATH = '/lab/UAT/F.BCON.DATA/RELEASE'
        UAT_LOG_PATH = '/lab/UAT/logs'
    }

    stages {
        stage('Validate Input') {
            steps {
                script {
                    if (!params.BCON_FILE?.trim()) {
                        error("BCON_FILE is required")
                    }
                }
            }
        }

        stage('Check Folder in DEV SAVE') {
            steps {
                sh '''
                    if [ ! -d "$DEV_SAVE_PATH/$BCON_FILE" ]; then
                      echo "ERROR: Folder not found in DEV SAVE path"
                      exit 1
                    fi
                    echo "Folder found in DEV SAVE path"
                '''
            }
        }

        stage('Copy Folder to UAT RELEASE') {
            steps {
                sh '''
                    rm -rf "$UAT_RELEASE_PATH/$BCON_FILE"
                    cp -r "$DEV_SAVE_PATH/$BCON_FILE" "$UAT_RELEASE_PATH/"
                    echo "Folder copied to UAT RELEASE path"
                '''
            }
        }

        stage('Verify Copied Folder Structure and Content') {
            steps {
                sh '''
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
                      find "$BCON_FILE" -type f -exec sha256sum "{}" \\; | sort > "$WORKSPACE/dev_checksums.txt"
                    )

                    (
                      cd "$UAT_RELEASE_PATH"
                      find "$BCON_FILE" -type f -exec sha256sum "{}" \\; | sort > "$WORKSPACE/uat_checksums.txt"
                    )

                    diff -u "$WORKSPACE/dev_checksums.txt" "$WORKSPACE/uat_checksums.txt"

                    echo "Folder structure and content verification passed"
                '''
            }
        }

        stage('Simulate T24 Release') {
            steps {
                sh '''
                    LOG_FILE="$UAT_LOG_PATH/$BCON_FILE.log"
                    echo "INFO: Starting simulated BCON release" > "$LOG_FILE"
                    echo "INFO: Folder name = $BCON_FILE" >> "$LOG_FILE"
                    echo "INFO: Executing ETS EX" >> "$LOG_FILE"
                    echo "INFO: Sending CTRL+U" >> "$LOG_FILE"
                    echo "SUCCESS: BCON release completed successfully" >> "$LOG_FILE"
                    echo "Simulated release log created at $LOG_FILE"
                '''
            }
        }

        stage('Verify Release Result') {
            steps {
                sh '''
                    LOG_FILE="$UAT_LOG_PATH/$BCON_FILE.log"
                    grep -i "SUCCESS" "$LOG_FILE"
                '''
            }
        }

        stage('Copy Evidence to Workspace') {
            steps {
                sh '''
                    mkdir -p artifacts/release artifacts/logs artifacts/verification
                    cp -r "$UAT_RELEASE_PATH/$BCON_FILE" artifacts/release/
                    cp "$UAT_LOG_PATH/$BCON_FILE.log" artifacts/logs/

                    cp "$WORKSPACE/dev_dirs.txt" artifacts/verification/
                    cp "$WORKSPACE/uat_dirs.txt" artifacts/verification/
                    cp "$WORKSPACE/dev_files.txt" artifacts/verification/
                    cp "$WORKSPACE/uat_files.txt" artifacts/verification/
                    cp "$WORKSPACE/dev_checksums.txt" artifacts/verification/
                    cp "$WORKSPACE/uat_checksums.txt" artifacts/verification/
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'artifacts/**/*', allowEmptyArchive: true
        }
        success {
            echo 'BCON POC release completed successfully'
        }
        failure {
            echo 'BCON POC release failed'
        }
    }
}