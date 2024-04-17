stages {
    Stage('Build') {
        environmnet {
            GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
        }
    }
    Stage('print'){
        echo $GIT_COMMIT
    }
}