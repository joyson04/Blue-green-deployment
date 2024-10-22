pipeline {
    agent any
    
    environment{
        KUBE_NAMESPACE = 'my-namespace'
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

        stage('Mongo DB') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'demos', contextName: '', credentialsId: 'k8-token', namespace: 'my-namespace', restrictKubeConfigAccess: false, serverUrl: 'https://9294252C03015B2627857B69FC308140.gr7.us-east-1.eks.amazonaws.com')  {
                    sh """ 
                        if ! kubectl get svc mongo-service -n ${KUBE_NAMESPACE};then
                            kubectl apply -f mongo.yml -n  ${KUBE_NAMESPACE}
                        fi
                    """
                }
            }
        }

        stage('Deploy SVC') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'demos', contextName: '', credentialsId: 'k8-token', namespace: 'my-namespace', restrictKubeConfigAccess: false, serverUrl: 'https://9294252C03015B2627857B69FC308140.gr7.us-east-1.eks.amazonaws.com')  {
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
                    withKubeConfig(caCertificate: '', clusterName: 'demos', contextName: '', credentialsId: 'k8-token', namespace: 'my-namespace', restrictKubeConfigAccess: false, serverUrl: 'https://9294252C03015B2627857B69FC308140.gr7.us-east-1.eks.amazonaws.com')  {
                        sh "kubectl apply -f ${deploymentApp} -n ${KUBE_NAMESPACE}"
                    }  
                } 
            }
        }

        stage('SHOW SVC') {
            steps {
               script{
                 def verifyEnv = params.DEPLOY_ENV
                    withKubeConfig(caCertificate: '', clusterName: 'demos', contextName: '', credentialsId: 'k8-token', namespace: 'my-namespace', restrictKubeConfigAccess: false, serverUrl: 'https://9294252C03015B2627857B69FC308140.gr7.us-east-1.eks.amazonaws.com')  {
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
                    withKubeConfig(caCertificate: '', clusterName: 'demos', contextName: '', credentialsId: 'k8-token', namespace: 'my-namespace', restrictKubeConfigAccess: false, serverUrl: 'https://9294252C03015B2627857B69FC308140.gr7.us-east-1.eks.amazonaws.com')  {
                        sh '''
                            kubectl patch svc  service-deploy  -p "{\\"spec\\": {\\"selector\\": {\\"app\\": \\"''' + newEnv + '''-app\\", \\"version\\": \\"''' + newEnv + '''\\"}}}" -n ${KUBE_NAMESPACE}
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
                    withKubeConfig(caCertificate: '', clusterName: 'demos', contextName: '', credentialsId: 'k8-token', namespace: 'my-namespace', restrictKubeConfigAccess: false, serverUrl: 'https://9294252C03015B2627857B69FC308140.gr7.us-east-1.eks.amazonaws.com') {
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
