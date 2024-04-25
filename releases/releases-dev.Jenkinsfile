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
                        echo "file modified ${FILECHANGE}"
                    }else{
                        sh "sed -i 's#image: .*#image: ${IMAGE_NAME}#' manifests/dev/yolobot.yaml"
                        echo "change in yolobot"
                        env.FILECHANGE = 'manifests/dev/yolobot.yaml'
                        echo "file modified ${FILECHANGE}"
                    }
                }

            }
        }
        stage("git commit"){
            steps{
                script{
                    sh 'cd /var/lib/jenkins/workspace/releases/cd-dev'
                    sh 'git config --global --add safe.directory /var/lib/jenkins/workspace/releases/cd-dev'
                    sh 'git fetch'
                    sh "git add ${FILECHANGE}"
                    sh '''
                      git config --global user.email "you@example.com"
                      git config --global user.name "orrmb"
                      '''
                    sh 'git commit -m "new version ${IMAGE_NAME}"'

                }
            }
        }
        stage("git push"){
            steps{
                   sh "git push "
                   cleanWs()
            }
        }
    }
}
