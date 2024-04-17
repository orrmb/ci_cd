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
                    String commitMsg = ""
                    List commitMsgPre = commit.split(" ")
                    for (int i = 1; i < commitMsgPre.size(); i++) {
                        commitMsg=commit.substring(commit.indexOf(' ')).trim()
                    print(commitMsg.split(" ")
                    }
                }
            }
        }
    }
}
