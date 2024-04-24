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
        stage("commit & push"){
            steps{
                sh "git config --global --add safe.directory /var/lib/jenkins/workspace/releases/cd-dev"
                sh " git add --all"
                sh 'git config --global user.email "you@example.com"'
                sh 'git config --global user.name "update-manifests"'
                sh 'git commit -m "new version ${IMAGE_NAME}"'
                sh "git push --all"
            }
        }
    }
}
