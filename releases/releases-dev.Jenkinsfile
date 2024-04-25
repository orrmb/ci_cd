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
                script{
                     if (IMAGE_NAME.contains('orrmb/bot-app-dev')){
                        sh "sed -i 's#image: .*#image: ${IMAGE_NAME}#' manifests/dev/polybot.yaml"
                        echo "change in polybot"
                        env.FILECHANGE = 'manifests/dev/polybot.yaml'
                    }else{
                        sh "sed -i 's#image: .*#image: ${IMAGE_NAME}#' manifests/dev/yolobot.yaml"
                        echo "change in yolobot"
                        env.FILECHANGE = manifests/dev/yolobot.yaml
                    }
                }

            }
        }
        stage("git commit"){
            steps{
                script{
                    sh 'cd /var/lib/jenkins/workspace/releases/cd-dev'
                    sh "sudo git config --global --add safe.directory /var/lib/jenkins/workspace/releases/cd-dev"
                    sh 'sudo git fetch'
                    sh "sudo git add ${FILECHANGE}"
                    sh 'sudo git commit -m "new version ${IMAGE_NAME}"'
                }
            }
        }
        stage("git push"){
            steps{
               withCredentials([gitUsernamePassword(credentialsId: 'orrmb', gitToolName: 'Default')]) {
                   sh "sudo git push origin HEAD"
                }
            }
        }
    }
}
