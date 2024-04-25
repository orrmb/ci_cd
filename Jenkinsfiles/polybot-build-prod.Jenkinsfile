pipeline {
    agent {
        docker {
            image 'orrmb/jenkinsagent'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
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
                    sh "git config --global --add safe.directory /var/lib/jenkins/workspace/prod/poly_prod"
                    commit = sh(returnStdout: true, script: 'git log -1 --oneline').trim()
                    def version = commit =~ /poly-prod version (\d+\.\d+\.\d+)/
                    if (version) {
                        env.VERSION = version[0][1]
                        echo "${VERSION}"
                        env.IMAGE_NAME="orrmb/bot-app-prod:cicd-${VERSION}"
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
                build job: 'releases/cd-prod', wait: false, parameters: [
                string(name: 'IMAGE_NAME', value: "${IMAGE_NAME}")
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
