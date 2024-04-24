pipeline {
    agent {
        docker {
            image 'orrmb/jenkinsagent'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    parameters { string(name: 'IMAGE_NAME', defaultValue: '', description: '') }
    stages{
        stage("test"){
            steps{
                sh "sed -i 's#image: .*#image: ${IMAGE_NAME}#' manifests/dev/polybot.yaml"
            }
        }
    }
}
