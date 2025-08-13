pipeline {
    agent none
    environment {
        PORT_EXPOSED = "80"
        IMAGE_NAME = "alpinebootcamp26"
        IMAGE_TAG = "v1.3"
        DOCKER_USERNAME = 'blondel'
    }
    stages {
      stage('Deploy in prod'){
          agent any
            environment {
                HOSTNAME_DEPLOY_PROD = "18.234.241.157"
            }
          steps {
            sshagent(credentials: ['SSH_AUTH_SERVER']) {
                sh '''
                    sudo mkdir -p ~/.ssh && sudo chmod 0700 ~/.ssh
                    ssh-keyscan -t rsa,dsa ${HOSTNAME_DEPLOY_PROD} >> ~/.ssh/known_hosts
                    command2="docker pull $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG"
                    command3="docker rm -f alpinebootcampp || echo 'app does not exist'"
                    command4="docker run -d -p 80:5000 -e PORT=5000 --name alpinebootcampp $DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG"
                    ssh -t ubuntu@${HOSTNAME_DEPLOY_PROD} \
                        -o SendEnv=IMAGE_NAME \
                        -o SendEnv=IMAGE_TAG \
                        -o SendEnv=DOCKER_USERNAME \
                        -o SendEnv=DOCKERHUB_AUTH_PSW \
                        -C "$command2 && $command3 && $command4"
                '''
            }
          }
      }        

    }
}
