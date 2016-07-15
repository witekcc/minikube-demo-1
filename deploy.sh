

minikube start

kubectl run bad-words --image=docker.permissiondata.com/services/bad-words:master --port=9053

kubectl expose deployment bad-words --type=NodePort

minikube stop

minikube delete
