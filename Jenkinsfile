pipeline {
    agent any

    parameters {
        string(name: 'BCON_FILE', defaultValue: 'NTBL001-MANTIS.2307', description: 'BCON package folder name')
    }

    environment {
        DEV_HOST = '20.40.59.60'
        UAT_HOST = '4.240.91.47'
        //DEV_USER = 'ndbpsit'	//saved in credentials w/ ssh key
        //UAT_USER = 't24isb'	//saved in credentials w/ ssh key

        DEV_SAVE_PATH = '/u02/T24/UD/F.BCON.DATA/SAVE'
        UAT_RELEASE_PATH = '/u02/T24/UD/F.BCON.DATA/RELEASE'
        UAT_LOG_PATH = '/u02/T24/UD/LOG'

        RELEASE_RESULT = 'SUCCESS'
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

        stage('Prepare Scripts') {
            steps {
                sh '''
                    chmod +x scripts/*.sh
                    mkdir -p incoming artifacts/logs artifacts/release artifacts/verification artifacts/manifest
                '''
            }
        }

        stage('Fetch Folder from DEV') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'dev-ssh-key',
                        keyFileVariable: 'DEV_KEY',
                        usernameVariable: 'DEV_CRED_USER'
                    )
                ]) {
                    sh '''
                        export SSH_KEY_FILE="$DEV_KEY"
                        export DEV_USER="$DEV_CRED_USER"
                        export BCON_FILE="$BCON_FILE"
                        export DEV_HOST="$DEV_HOST"
                        export DEV_SAVE_PATH="$DEV_SAVE_PATH"

                        ./scripts/fetch-from-dev.sh
                    '''
                }
            }
        }

        stage('Verify Folder in Jenkins Workspace') {
            steps {
                sh '''
                    if [ ! -d "incoming/$BCON_FILE" ]; then
                      echo "ERROR: Folder was not fetched from DEV"
                      exit 1
                    fi

                    echo "Folder successfully fetched into Jenkins workspace"
                    ls -la incoming
                '''
            }
        }

        stage('Push Folder to UAT') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'uat-ssh-key',
                        keyFileVariable: 'UAT_KEY',
                        usernameVariable: 'UAT_CRED_USER'
                    )
                ]) {
                    sh '''
                        export SSH_KEY_FILE="$UAT_KEY"
                        export UAT_USER="$UAT_CRED_USER"
                        export BCON_FILE="$BCON_FILE"
                        export UAT_HOST="$UAT_HOST"
                        export UAT_RELEASE_PATH="$UAT_RELEASE_PATH"

                        ./scripts/push-to-uat.sh
                    '''
                }
            }
        }

        stage('Verify Folder in UAT') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'uat-ssh-key',
                        keyFileVariable: 'UAT_KEY',
                        usernameVariable: 'UAT_CRED_USER'
                    )
                ]) {
                    sh '''
                        export SSH_KEY_FILE="$UAT_KEY"
                        export UAT_USER="$UAT_CRED_USER"
                        export BCON_FILE="$BCON_FILE"
                        export UAT_HOST="$UAT_HOST"
                        export UAT_RELEASE_PATH="$UAT_RELEASE_PATH"

                        ssh -i "$SSH_KEY_FILE" -o StrictHostKeyChecking=no \
                          "$UAT_USER@$UAT_HOST" \
                          "test -d '$UAT_RELEASE_PATH/$BCON_FILE'"

                        echo "Folder verified in UAT RELEASE path"
                    '''
                }
            }
        }

        stage('Run Mock Release on UAT') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'uat-ssh-key',
                        keyFileVariable: 'UAT_KEY',
                        usernameVariable: 'UAT_CRED_USER'
                    )
                ]) {
                    sh '''
                        export SSH_KEY_FILE="$UAT_KEY"
                        export UAT_USER="$UAT_CRED_USER"
                        export BCON_FILE="$BCON_FILE"
                        export UAT_HOST="$UAT_HOST"
                        export UAT_LOG_PATH="$UAT_LOG_PATH"

                        ./scripts/run-uat-release.sh
                    '''
                }
            }
        }

        stage('Fetch UAT Log') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'uat-ssh-key',
                        keyFileVariable: 'UAT_KEY',
                        usernameVariable: 'UAT_CRED_USER'
                    )
                ]) {
                    sh '''
                        export SSH_KEY_FILE="$UAT_KEY"
                        export UAT_USER="$UAT_CRED_USER"
                        export BCON_FILE="$BCON_FILE"
                        export UAT_HOST="$UAT_HOST"
                        export UAT_LOG_PATH="$UAT_LOG_PATH"

                        ./scripts/fetch-uat-log.sh
                    '''
                }
            }
        }

        stage('Verify Release Result') {
            steps {
                sh '''
                    LOG_FILE="artifacts/logs/$BCON_FILE.log"

                    if [ ! -f "$LOG_FILE" ]; then
                      echo "ERROR: Log file not found in artifacts/logs"
                      exit 1
                    fi

                    grep -i "SUCCESS" "$LOG_FILE"
                    echo "Release result verification passed"
                '''
            }
        }

        stage('Collect Evidence') {
            steps {
                sh '''
                    cp -r "incoming/$BCON_FILE" "artifacts/release/" || true
                    echo "Evidence collection completed"
                '''
            }
        }

        stage('Generate Release Manifest') {
            steps {
                sh '''
                    cat > artifacts/manifest/release.json <<EOF
{
  "releaseId": "BCON-${BUILD_NUMBER}",
  "bconFolder": "${BCON_FILE}",
  "devHost": "${DEV_HOST}",
  "uatHost": "${UAT_HOST}",
  "sourcePath": "${DEV_SAVE_PATH}/${BCON_FILE}",
  "targetPath": "${UAT_RELEASE_PATH}/${BCON_FILE}",
  "logPath": "${UAT_LOG_PATH}/${BCON_FILE}.log",
  "buildNumber": "${BUILD_NUMBER}",
  "jobName": "${JOB_NAME}",
  "buildUrl": "${BUILD_URL}",
  "result": "${RELEASE_RESULT}"
}
EOF
                    echo "Release manifest generated"
                '''
            }
        }
    }

    post {
        failure {
            echo 'Remote BCON flow failed'
        }

        success {
            echo 'Remote BCON flow completed successfully'
        }

        always {
            archiveArtifacts artifacts: 'artifacts/**/*, incoming/**/*', allowEmptyArchive: true
        }
    }
}