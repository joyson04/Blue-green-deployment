kubectl create ns webapps

kubectl apply -f namespaces.yml

kubectl apply -f securt.yml -n webapps

kubectl describe secret mysecretname -n webapps

Kubernetes Server Endpoint:
  
  kubectl config view


kubectl patch service service-deploy -p '{"spec":{"selector":{"app":"blue-app", "version":"blue"}}}'

Change:

kubectl patch service service-deploy -p '{"spec":{"selector":{"app":"green-app", "version":"green"}}}'

kubectl scale deployment blue-deployment --replicas=0

kubectl set selector service service-deploy version=blue
