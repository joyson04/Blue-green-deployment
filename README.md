
  One Type Switch  Traffic:
    

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


 second Type Switch Traffic:

        
        stage('Switch Traffic Second ') {
            when {
                // Boolean expression
                expression { return params.SWITCH_TRAFFICS }
            }
            steps {
                script{
                    def newEnv = params.DEPLOY_ENV
                    withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: ' kubernetes', credentialsId: 'kubernetes-jenkins', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://172.31.95.76:6443') {
                        sh '''kubectl set selector service service-deploy version="'''${newEnv}'''" -n ''' ${KUBE_NAMESPACE}
                    }
                     echo "Traffic has been switched to the ${newEnv} environments : ${newEnv}"
                }
            }
        }
        
