pipeline {
    agent {
        docker {
            image 'orrmb/jenkinsagent'
            args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        IMAGE_NAME = 'orrmb/bot-app-dev'
        IMAGE_TAG  = "cicd-0.0.${BUILD_NUMBER}"
    }

    stages {
        stage('Docker Hub login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker_Hub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh "docker login -u $USER -p $PASS"
                }
            }
        }

        stage('Check Change') {
            when {
                changeset "k8s/polybot/**"
            }
            steps {
                    echo "Start build image $IMAGE_NAME"
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} . -f k8s/polybot/bot-https/Dockerfile"
                    echo "The image $IMAGE_NAME built"
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    echo "Push the $IMAGE_NAME"
                    cleanWs()
                }
            }
        }
    }

    post {
        always {
            sh 'docker image prune -a --force --filter "until=1h"'
        }
    }
    options {
        timestamps()
    }
}
