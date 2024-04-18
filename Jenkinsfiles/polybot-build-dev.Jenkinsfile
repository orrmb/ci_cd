pipeline {
    agent {
        docker {
            image 'orrmb/jenkinsagent'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        IMAGE_NAME = 'orrmb/bot-app-dev'
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
                changeset "**/k8s/polybot/**"
            }
            steps {
                script {
                    sh "git config --global --add safe.directory /var/lib/jenkins/workspace/dev/poly_dev"
                    commit = sh(returnStdout: true, script: 'git log -1 --oneline').trim()
                    def version = commit =~ /poly-dev version (\d+\.\d+\.\d+)/
                    if (version) {
                        env.VERSION = version[0][1]
                        echo "${VERSION}"
                        env.IMAGE_NAME="${IMAGE_NAME}:cicd-${VERSION}"
                    } else {
                        echo "Version not found"
                        scmSkip(deleteBuild: true, skipPattern:'.*\\[ci skip\\].*')
                    }
                }
                echo "Starting to build image $IMAGE_NAME"
                sh "docker build -t ${IMAGE_NAME} . -f k8s/polybot/bot-https/Dockerfile"
                echo "The image $IMAGE_NAME has been built"
                sh "docker push ${IMAGE_NAME}"
                echo "Pushed the image $IMAGE_NAME"
                cleanWs()
            }
        }
        stage('Trigger Deploy') {
            steps {
                build job: 'cd-dev', wait: false, parameters: [
                string(name: 'POLYBOT_IMAGE', value: "${IMAGE_NAME}")
        ]
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
