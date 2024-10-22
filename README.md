![Screenshot from 2024-10-22 13-30-25](https://github.com/user-attachments/assets/83c9b672-1fa2-4518-ab59-2cbe6cb636c7)
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
        

![Screenshot from 2024-10-22 13-35-28](https://github.com/user-attachments/assets/0978b0c0-85db-4fcd-91f8-2bd0b25adeaf)



Version: 1

![Screenshot from 2024-10-22 13-23-39](https://github.com/user-attachments/assets/9b55026a-c03e-4d93-a466-e7844c9a0e00)


Version:2 

![Screenshot from 2024-10-22 13-25-31](https://github.com/user-attachments/assets/15d6d313-9209-4e30-8bc6-9a666e59ca21)


Application Working:

![Screenshot from 2024-10-22 13-27-14](https://github.com/user-attachments/assets/2168c4da-717e-4001-a83f-7dde32aad8ff)


Blue_deploy:

![Screenshot from 2024-10-22 13-30-18](https://github.com/user-attachments/assets/13803186-2fc7-41d9-9b77-9d3a07e34967)

Blue_deploy_working:

![Screenshot from 2024-10-22 13-30-25](https://github.com/user-attachments/assets/d1459f97-15aa-4555-b389-71140a00b287)

Green-deployment-Jenkins:

![Screenshot from 2024-10-22 13-31-59](https://github.com/user-attachments/assets/8cd97f94-01d9-44fb-adda-3e329c656295)

Switch Traffic:

![Screenshot from 2024-10-22 13-32-49](https://github.com/user-attachments/assets/50228c49-63c1-4ace-8000-3dff7a62ce59)

Working:

![Screenshot from 2024-10-22 13-33-30](https://github.com/user-attachments/assets/72171d75-5ab9-4ff3-bc9e-bccc69359254)

Vedio:




