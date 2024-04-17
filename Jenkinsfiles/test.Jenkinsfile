stages {
    Stage('Build') {
        environmnet {
            GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
        }
    }
    Stage('print'){
        steps{
            echo $GIT_COMMIT
        }

    }
}