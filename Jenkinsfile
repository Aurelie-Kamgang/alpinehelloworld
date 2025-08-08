pipeline{
    agent none
        environment {
            IMAGE_NAME = "alpinehello"
            IMAGE_TAG = "v1.0"
            PORT_EXPOSE = "80"
            ID_DOCKERHUB = blondel
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
    }
}
