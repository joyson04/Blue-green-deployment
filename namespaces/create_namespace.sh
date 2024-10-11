kubectl create ns webapps

kubectl apply -f namespaces.yml

kubectl apply -f securt.yml -n webapps

kubectl describe secret mysecretname -n webapps

Kubernetes Server Endpoint:
  
  kubectl config view
  
kubectl patch service post-blog-service -p '{"spec":{"selector":{"app":"post-blog", "version":"blue"}}}'

kubectl scale deployment post-blog-blue --replicas=0

kubectl set selector service post-blog-service version=blue
