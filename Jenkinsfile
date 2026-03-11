pipeline {
    agent any

    parameters {
        string(name: 'BCON_FILE', defaultValue: 'BCON.TEST.001', description: 'Name of the BCON package folder')
    }

    environment {
        DEV_SAVE_PATH = '/lab/DEV/F.BCON.DATA/SAVE'
        UAT_RELEASE_PATH = '/lab/UAT/F.BCON.DATA/RELEASE'
        UAT_LOG_PATH = '/lab/UAT/logs'
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
                '''
            }
        }

        stage('Check Folder in DEV SAVE') {
            steps {
                sh './scripts/check-folder.sh'
            }
        }

        stage('Copy Folder to UAT RELEASE') {
            steps {
                sh './scripts/copy-folder.sh'
            }
        }

        stage('Verify Copied Folder Structure and Content') {
            steps {
                sh './scripts/verify-folder.sh'
            }
        }

        stage('Simulate T24 Release') {
            steps {
                sh './scripts/simulate-release.sh'
            }
        }

        stage('Verify Release Result') {
            steps {
                sh './scripts/verify-release-result.sh'
            }
        }

        stage('Collect Evidence') {
            steps {
                sh './scripts/collect-evidence.sh'
            }
        }

        stage('Generate Release Manifest') {
            steps {
                sh './scripts/generate-manifest.sh'
            }
        }
    }

    post {
        failure {
            script {
                env.RELEASE_RESULT = 'FAILURE'
            }
            echo 'BCON POC release failed'
        }

        success {
            echo 'BCON POC release completed successfully'
        }

        always {
            archiveArtifacts artifacts: 'artifacts/**/*', allowEmptyArchive: true
        }
    }
}