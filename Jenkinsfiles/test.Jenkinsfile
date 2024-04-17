pipeline {
    agent any

    environment {
        GIT_COMMIT1 = sh(returnStdout: true, script: 'git log -1 --oneline | grep version').trim()
    }

    stages {
        stage('Print') {
            steps {
                script {
                    commit = sh(returnStdout: true, script: 'git log -1 --oneline').trim()
                    def version = commit = /polybot version (\d+\.\d+\.\d+)/
                    if (version) {
                        env.VERSION = "${version[1][1]}"
                        echo "${VERSION}"
                    } else {
                        echo "Version not found"
                    }
                }
            }
        }
    }
}
