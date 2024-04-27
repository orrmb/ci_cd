pipeline {
    agent {
        docker {
            image 'orrmb/jenkinsagent'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    stages {
        stage('Lint') {
            steps {
                sh 'pip3 install -r Jenkinsfiles/requirements.txt'
                sh 'python3 -m pylint -f parseable --reports=no k8s/polybot/bot-https/*.py && python3 -m pylint -f parseable --reports=no k8s/yolo5*.py > pylint.log'
            }
            post {
                always {
                    sh 'cat pylint.log'
                    recordIssues (
                        enabledForFailure: true,
                        aggregatingResults: true,
                        tools: [pyLint(name: 'Pylint', pattern: '**/pylint.log')]
                    )
                }
            }
        }
    }
}
