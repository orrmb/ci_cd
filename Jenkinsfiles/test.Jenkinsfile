pipeline {
    agent any

    environment {
        GIT_COMMIT1 = sh(returnStdout: true, script: 'git log -1 --oneline | grep version').trim()

    }
    stages {
        script{
            commit = sh(returnStdout: true, script: 'git log -1 --oneline').trim()
            String commitMsg = ""
            List commitMsgPre = commit.split(" ")
            for(int i=1; i<commitMsgPre.size(); i++){
            commitMsg += commit.substring( commit.indexOf(' ') ).trim()
            print(commitMsg)
        }
        stage('Print') {
            steps {
                echo "GIT_COMMIT: ${GIT_COMMIT1}.spilt(' ')"
            }
        }
    }
}
