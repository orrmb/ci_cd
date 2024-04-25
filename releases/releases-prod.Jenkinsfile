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
                     if (IMAGE_NAME.contains('orrmb/bot-app-prod')){
                        sh "sed -i 's#image: .*#image: ${IMAGE_NAME}#' manifests/prod/polybot.yaml"
                        echo "change in polybot"
                        env.FILECHANGE = 'manifests/prod/polybot.yaml'
                        echo "file modified ${FILECHANGE}"
                        sh "echo ${IMAGE_NAME} >> versions"
                    }else{
                        sh "sed -i 's#image: .*#image: ${IMAGE_NAME}#' manifests/prod/yolobot.yaml"
                        echo "change in yolobot"
                        env.FILECHANGE = 'manifests/prod/yolobot.yaml'
                        echo "file modified ${FILECHANGE}"
                        sh "echo ${IMAGE_NAME} >> versions"
                    }
                }

            }
        }
        stage("git commit"){
            steps{
                script{
                    sh 'cd /var/lib/jenkins/workspace/releases/cd-prod'
                    sh 'git config --global --add safe.directory /var/lib/jenkins/workspace/releases/cd-prod'
                    sh 'git fetch'
                    sh "git add ${FILECHANGE} versions"
                    sh '''
                      git config --global user.email "you@example.com"
                      git config --global user.name "orrmb"
                      '''
                    sh 'git commit -m "new version ${IMAGE_NAME}"'

                }
            }
        }
        stage("Push to Git Repository") {
            steps {
                    withCredentials([gitUsernamePassword(credentialsId: 'Jenkins TOKEN', gitToolName: 'Default')]) {
                    sh 'git push origin HEAD:releases'
                }
            }
        }
    }
    post{
        always{
            cleanWs()
        }
    }
}
