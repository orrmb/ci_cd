pipeline {
    agent {
        docker {
            image 'orrmb/jenkinsagent'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        IMAGE_NAME = 'orrmb/yolo-app-dev'
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
                changeset "k8s/yolo5/**"
            }
            steps {
                script {
                    sh "git config --global --add safe.directory /var/lib/jenkins/workspace/dev/yolo_dev"
                    commit = sh(returnStdout: true, script: 'git log -1 --oneline').trim()
                    def version = commit =~ /yolo version (\d+\.\d+\.\d+)/
                    if (version) {
                        env.VERSION = version[0][1]
                        echo "${VERSION}"
                    } else {
                        echo "Version not found"
                        scmSkip(deleteBuild: true, skipPattern:'.*\\[ci skip\\].*')
                    }
                }
                echo "Starting to build image $IMAGE_NAME"
                sh "docker build -t ${IMAGE_NAME}:cicd-${VERSION} . -f k8s/polybot/bot-https/Dockerfile"
                echo "The image $IMAGE_NAME has been built"
                sh "docker push ${IMAGE_NAME}:cicd-${VERSION}"
                echo "Pushed the image $IMAGE_NAME"
                cleanWs()
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
