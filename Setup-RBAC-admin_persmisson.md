Create a Service Account, Role & Assign that role, And create a secret for the Service Account and generate a Token

    kubectl create namespace devops-tools

Creating Service Account

    apiVersion: v1
    kind: ServiceAccount
    metadata:
        name: jenkins-admin
        namespace: devops-tools


Create Role

    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
        name: jenkins-admin
        namespace: devops-tools
    rules:
        - apiGroups: [""]
          resources: ["*"]
          verbs: ["*"]



Bind the role to service account

    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
        name: jenkins-admin-binding
        namespace: devops-tools
    roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: Role
        name: jenkins-admin
        subjects:
            - kind: ServiceAccount
              name: jenkins-admin
              namespace: devops-tools



Create Secret for Service Account and Generate Token

After creating the Service Account, Kubernetes will automatically generate a token. To retrieve this token, follow these steps:

Display the token:

Use the exact name of the secret from the above command output:

    kubectl describe secret <secret-name> -n devops-tools


Retrieve the Service Account secret:
 
    kubectl get secrets -n devops-tools | grep jenkins-admin

