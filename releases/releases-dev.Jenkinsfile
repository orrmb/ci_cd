pipeline {
    agent {
        docker {
            image 'orrmb/jenkinsagent'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    parameters { string(name: 'IMAGE_NAME', defaultValue: '', description: '') }
    stages{
        stage("check the change"){
            steps{
                if ('orrmb/bot-app-dev' in ${IMAGE_NAME}){
                    sh "sed -i 's#image: .*#image: ${IMAGE_NAME}#' manifests/dev/polybot.yaml"
                }else{
                    sh "sed -i 's#image: .*#image: ${IMAGE_NAME}#' manifests/dev/yolobot.yaml"
                }
            }
        }
        stage("commit & push"){
            steps{
                script{
                    dir('/var/lib/jenkins/workspace/releases/cd-dev') {
                        sh " git add --all"
                        sh 'git config --global user.email "you@example.com"'
                        sh 'git config --global user.name "update-manifests"'
                        sh 'git commit -m "new version ${IMAGE_NAME}"'
                        sh "git push origin releases"
                    }
                }
            }
        }
    }
}
