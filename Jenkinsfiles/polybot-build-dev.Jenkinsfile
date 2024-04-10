pipeline {
    agent {
        docker {
        label 'general'
        image 'orrmb/jenkinsagent'
        args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        IMAGE_NAME = 'orrmb/bot-app'
        IMAGE_TAG  = "cicd-0.0.$BUILD_NUMBER"
    }
    stages {
        stage('Docker Hub login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker_Hub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh "docker login -u $USER -p $PASS"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }


        stage('Push Docker Image to Docker Hub') {
            steps {
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
        stage('Trigger Deploy') {
            steps {
                build job: 'RobertaDeploy', wait: false, parameters: [
                string(name: 'ROBERTA_IMAGE_URL', value: "${IMAGE_NAME}:${IMAGE_TAG}")
                ]
            }
        }
        stage('Clean Workspace'){
            steps{
                cleanWs(cleanWhenSuccess: true, deleteDirs: true)
            }
        }

   }
    post {
       always {
            sh 'docker image prune -a --force --filter "until=1h"'
       }
    }
    options{timestamps()}
}
