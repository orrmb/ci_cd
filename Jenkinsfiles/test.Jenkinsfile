pipeline {
    agent any
    stages {
        stage('Build') {
            environment {
                GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
            }
        }
        stage('Print') {
            steps {
                echo "GIT_COMMIT: ${GIT_COMMIT}"
            }
        }
    }
}
