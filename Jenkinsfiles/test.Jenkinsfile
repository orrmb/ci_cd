pipeline {
    agent any

    environment {
        GIT_COMMIT = sh(returnStdout: true, script: 'git log -1 --oneline').trim()
    }
    stages {
        stage('Print') {
            steps {
                echo "GIT_COMMIT: ${GIT_COMMIT}"
            }
        }
    }
}
