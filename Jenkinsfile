pipeline {
    agent any
    
    environment{
        KUBE_NAMESPACE = 'webapps'
    }

    parameters{
        choice(name: 'DEPLOY_ENV', choices: ['blue', 'green'], description: 'Choose which environment to deploy: Blue or Green')
        booleanParam(name: 'SWITCH_TRAFFICS', defaultValue: false, description: 'Switch traffic between Blue and Green')
    }

    stages {
        stage('GIT') {
            steps {
                git branch: 'main', url: 'https://github.com/joyson04/Blue-green-deployment.git'
            }
        }

        stage('Mongod-Volumes') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'demos', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://23D9F611757A6BDB04F685B76E1C17C9.gr7.us-east-1.eks.amazonaws.com')  {
                    sh """ 
                        if ! kubectl get pv  -n ${KUBE_NAMESPACE};then
                            kubectl apply -f volume.yml -n  ${KUBE_NAMESPACE}
                        fi
                    """
                }
            }
        }

        stage('Deploy SVC') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'demos', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://23D9F611757A6BDB04F685B76E1C17C9.gr7.us-east-1.eks.amazonaws.com')  {
                    sh """ 
                        if ! kubectl get svc service-deploy -n ${KUBE_NAMESPACE};then
                            kubectl apply -f svc.yml -n  ${KUBE_NAMESPACE}
                        fi
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script{
                    def  deploymentApp = ''
                    if (params.DEPLOY_ENV == 'blue') {
                        deploymentApp = "app-deployment-blue.yml"
                    }else{
                        deploymentApp = "app-deployment-green.yml"
                    }
                    withKubeConfig(caCertificate: '', clusterName: 'demos', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://23D9F611757A6BDB04F685B76E1C17C9.gr7.us-east-1.eks.amazonaws.com')  {
                        sh "kubectl apply -f mongo.yml -n ${KUBE_NAMESPACE}"
                        sh "kubectl apply -f ${deploymentApp} -n ${KUBE_NAMESPACE}"
                    }  
                } 
            }
        }

        stage('SHOW SVC') {
            steps {
               script{
                 def verifyEnv = params.DEPLOY_ENV
                    withKubeConfig(caCertificate: '', clusterName: 'demos', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://23D9F611757A6BDB04F685B76E1C17C9.gr7.us-east-1.eks.amazonaws.com')  {
                        sh """
                            kubectl get pods -l version=${verifyEnv} -n ${KUBE_NAMESPACE}
                            kubectl get svc service-deploy -n ${KUBE_NAMESPACE}
                            kubectl get pods
                        """
                    }
               }
            }
        }

        stage('Switch Traffic') {
            when {
                // Boolean expression
                expression { return params.SWITCH_TRAFFICS }
            }
            steps {
                script{
                    def newEnv = params.DEPLOY_ENV
                    withKubeConfig(caCertificate: '', clusterName: 'demos', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://23D9F611757A6BDB04F685B76E1C17C9.gr7.us-east-1.eks.amazonaws.com')  {
                        sh '''
                            kubectl patch service service-deploy -p "{\\"spec\\": {\\"selector\\": {\\"app\\": \\"app\\", \\"version\\": \\"''' + newEnv + '''\\"}}}" -n ${KUBE_NAMESPACE}
                        '''
                    }
                     echo "Traffic has been switched to the ${newEnv} environments : ${newEnv}"
                }
            }
        }

        stage('Verify Deployment') {
            when {
                // Boolean expression
                expression { return params.SWITCH_TRAFFICS }
            }
            steps {
                script{
                    def verifyEnv = params.DEPLOY_ENV
                    withKubeConfig(caCertificate: '', clusterName: 'demos', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://23D9F611757A6BDB04F685B76E1C17C9.gr7.us-east-1.eks.amazonaws.com')  {
                        sh """
                            kubectl get pods -l version=${verifyEnv} -n ${KUBE_NAMESPACE}
                            kubectl get svc service-deploy -n ${KUBE_NAMESPACE}
                        """
                    }
                }
            }
        }
    }
}
