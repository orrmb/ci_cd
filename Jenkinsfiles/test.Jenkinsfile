pipeline {
    agent any

    environment {
        GIT_COMMIT1 = sh(returnStdout: true, script: 'git log -1 --oneline | grep version').trim()

    }
    stages {
        stage('Print') {
            steps {
                echo "GIT_COMMIT: ${GIT_COMMIT1}"
            }
        }
    }
}
