pipeline {
    agent any

    parameters {
        string(name: 'BCON_FILE', defaultValue: 'BCON.TEST.001.txt', description: 'Name of the BCON package file')
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

        stage('Check File in DEV SAVE') {
            steps {
                sh '''
                    if [ ! -f "$DEV_SAVE_PATH/$BCON_FILE" ]; then
                      echo "ERROR: File not found in DEV SAVE path"
                      exit 1
                    fi
                    echo "File found in DEV SAVE path"
                '''
            }
        }

        stage('Copy File to UAT RELEASE') {
            steps {
                sh '''
                    cp "$DEV_SAVE_PATH/$BCON_FILE" "$UAT_RELEASE_PATH/$BCON_FILE"
                    echo "File copied to UAT RELEASE path"
                '''
            }
        }

        stage('Simulate T24 Release') {
            steps {
                sh '''
                    LOG_FILE="$UAT_LOG_PATH/$BCON_FILE.log"
                    echo "INFO: Starting simulated BCON release" > "$LOG_FILE"
                    echo "INFO: File name = $BCON_FILE" >> "$LOG_FILE"
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
                    mkdir -p artifacts/release artifacts/logs
                    cp "$UAT_RELEASE_PATH/$BCON_FILE" artifacts/release/
                    cp "$UAT_LOG_PATH/$BCON_FILE.log" artifacts/logs/
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