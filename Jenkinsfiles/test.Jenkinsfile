pipeline {
    agent any

    environment {
        GIT_COMMIT1 = sh(returnStdout: true, script: 'git log -1 --oneline').trim()
        GIT_COMMIT2 = GIT_COMMIT1.substring( commit.indexOf(' ') ).trim()
    }
    stages {
        stage('Print') {
            steps {
                echo "GIT_COMMIT: ${GIT_COMMIT2}"
            }
        }
    }
}
