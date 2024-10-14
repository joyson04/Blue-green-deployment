
  One Type Switch  Traffic:
    

        stage('Switch Traffic') {
            when {
                // Boolean expression
                expression { return params.SWITCH_TRAFFICS }
            }
            steps {
                script{
                    def newEnv = params.DEPLOY_ENV
                    withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: ' kubernetes', credentialsId: 'kubernetes-jenkins', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://172.31.95.76:6443') {
                        sh '''
                            kubectl patch service service-deploy -p "{\\"spec\\": {\\"selector\\": {\\"app\\": \\"app\\", \\"version\\": \\"''' + newEnv + '''\\"}}}" -n ${KUBE_NAMESPACE}
                        '''
                        echo "Traffic has been switched to the ${newEnv} environments : ${newEnv}"
                    }
                }
            }
        }


 second Type Switch Traffic:

        stage('Switch Traffic') {
            when {
                // Boolean expression
                expression { return params.SWITCH_TRAFFICS }
            }
            steps {
                script{
                    def newEnv = params.DEPLOY_ENV
                    withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: ' kubernetes', credentialsId: 'kubernetes-jenkins', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://172.31.95.76:6443') {
                        sh "kubectl set selector service service-deploy version=${newEnv}" -n ${KUBE_NAMESPACE}
                        echo "Traffic has been switched to the ${newEnv} environments : ${newEnv}"
                    }
                }
            }
        }
        
