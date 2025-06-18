pipeline{
    agent none
        environment {
            IMAGE_NAME = "alpinehello"
            IMAGE_TAG = "v1.0"
            PORT_EXPOSE = "v1"
            DOCKERHUB_AUTH = credentials('DOCKERHUB_AUTH')
            ID_DOCKERHUB = "${DOCKERHUB_AUTH_USR}" 
            HOSTNAME_DEPLOY_STAGING = "35.170.246.199"
            HOSTNAME_DEPLOY_PROD = "18.233.5.135"         
        }
        stages {
            stage ('Build') {
                agent any
                steps {
                    script {
                        sh 'docker build -t ${ID_DOCKERHUB}/${IMAGE_NAME}:${IMAGE_TAG} .'
                    }
                }
            }
            stage ('Test acceptance') {
                agent any
                steps {
                    script {
                        sh '''
                            docker run --name ${IMAGE_NAME} -d -p ${PORT_EXPOSE}:5000 -e PORT=5000 ${ID_DOCKERHUB}/${IMAGE_NAME}:${IMAGE_TAG}
                            sleep 5
                            curl http://172.17.0.1:${PORT_EXPOSED} | grep -q "Hello world!"
                        '''
                    }
                }
            }
            stage ('artefact') {
                agent any
                steps {
                    sh '''
                        docker login -u ${DOCKERHUB_AUTH_USR} -p ${DOCKERHUB_AUTH_PSW}
                        docker push ${ID_DOCKERHUB}/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
            stage ('deploy staging') {
                agent any
                steps {
                    sshagent (credentials: ['SSH_AUTH_SERVER']) {
                        sh '''
                            [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
                            ssh-keyscan -t rsa,dsa ${HOSTNAME_DEPLOY_STAGING} >> ~/.ssh/known_hosts
                            command1="docker login -u $DOCKERHUB_AUTH_USR -p $DOCKERHUB_AUTH_PSW"
                            command2="docker pull $DOCKERHUB_AUTH_USR/$IMAGE_NAME:$IMAGE_TAG"
                            command3="docker rm -f $IMAGE_NAME || echo 'app does not exist'"
                            command4="docker run -d -p 80:5000 -e PORT=5000 --name $IMAGE_NAME $DOCKERHUB_AUTH_USR/$IMAGE_NAME:$IMAGE_TAG"
                            ssh -t ubuntu@${HOSTNAME_DEPLOY_STAGING} \
                            -o SendEnv=IMAGE_NAME \
                            -o SendEnv=IMAGE_TAG \
                            -o SendEnv=DOCKERHUB_AUTH_USR \
                            -o SendEnv=DOCKERHUB_AUTH_PSW \
                            -C "$command1 && $command2 && $command3 && $command4"
                        '''
                    }
                }

            }
            stage ('deploy prod') {
                agent any
                steps {
                    sshagent (credentials: ['SSH_AUTH_SERVER']) {
                        sh '''
                            [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
                            ssh-keyscan -t rsa,dsa ${HOSTNAME_DEPLOY_PROD} >> ~/.ssh/known_hosts
                            command1="docker login -u $DOCKERHUB_AUTH_USR -p $DOCKERHUB_AUTH_PSW"
                            command2="docker pull $DOCKERHUB_AUTH_USR/$IMAGE_NAME:$IMAGE_TAG"
                            command3="docker rm -f $IMAGE_NAME || echo 'app does not exist'"
                            command4="docker run -d -p 80:5000 -e PORT=5000 --name $IMAGE_NAME $DOCKERHUB_AUTH_USR/$IMAGE_NAME:$IMAGE_TAG"
                            ssh -t ubuntu@${HOSTNAME_DEPLOY_PROD} \
                            -o SendEnv=IMAGE_NAME \
                            -o SendEnv=IMAGE_TAG \
                            -o SendEnv=DOCKERHUB_AUTH_USR \
                            -o SendEnv=DOCKERHUB_AUTH_PSW \
                            -C "$command1 && $command2 && $command3 && $command4"
                        '''
                    }
            }
        }
    }
}
