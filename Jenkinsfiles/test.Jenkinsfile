pipeline {
    agent any

    environment {
        GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
    }
    stages {
        stage('Print') {
            steps {
                echo "GIT_COMMIT: ${GIT_COMMIT}"
            }
        }
    }
}
