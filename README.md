=======
notes:
=======

--BASIC:
minikube dashboard

docker info
docker status
kubectl config current-context
kubectl config view

--DEBUG/LOG:
minikube logs
	- shows all logs
kubectl describe pods bad-words-4183345525-wkdi7
	- shows logs
kubectl logs -f bad-words
	- stream logs

--SECRETS:
kubectl create secret docker-registry pddockerregistrykey --docker-server=https://docker.permissiondata.com --docker-username=wciemiega --docker-password=[pass] --docker-email=wciemiega@permissiondata.com
kubectl get secrets

--OTHER:
creates minkubeVM

docker.permissiondata.com/services/bad-words:dev
docker.permissiondata.com/services/bad-words:master

delete pod; gets re-created instanteniously!:
kubectl delete pod,service bad-words




# Start a single instance of hazelcast and set environment variables "DNS_DOMAIN=cluster" and "POD_NAMESPACE=default" in the container.
kubectl run hazelcast --image=hazelcast --env="DNS_DOMAIN=cluster" --env="POD_NAMESPACE=default"


--VOLUMES
# checkout mounted volumes
kubectl exec storage ls /data
# see drone volumes:
"volumes": [
    {
      "containerPath": "/var/log/badwords",
      "hostPath": "/var/log/badwords",
      "mode": "RW"
    }
  ],


=======
example:
=======

on vm:
mkdir -p /var/run/secrets/kubernetes.io/serviceaccount
mount -o bind /var/run/secrets/kubernetes.io/serviceaccount /var/run/secrets/kubernetes.io/serviceaccount
mount --make-shared /var/run/secrets/kubernetes.io/serviceaccount


minikube start
minikube ip

#setup docker
# TODO: see if it works
docker login -e wciemiega@permissiondata.com -u wciemiega -p [pass] https://docker.permissiondata.com
docker.permissiondata.com/services/bad-words:master

# postgress
# TODO is this needed?
mkdir /tmp/postgres + chmod 777 /tmp/postgres
kubectl create -f postgres-persistence.yml
kubectl create -f postgres-claim.yml
kubectl create -f postgres-pod.yml
kubectl create -f postgres-service.yml

#forward minikubevm to host
kubectl port-forward postgres 15432:5432

kubectl run bad-words10 --image=docker.permissiondata.com/services/bad-words:master \
	--env="LOG_LEVEL=0" \
	--env="LOG_PATH=/badwords.log" \
	--env="APP_NAME=badwords" \
	--env="APP_MINLEADS=2" \
	--env="REPEATED_MAXNUMBER=3" \
	--env="REPEATED_MAXMARK=2" \
	--env="REPEATED_MAXALPHA=3" \
	--env="DB_DRIVER=postgres" \
	--env="DB_NAME=badwords" \
	--env="DB_USER=postgres" \
	--env="DB_PASSWORD=password" \
	--env="DB_HOST=localhost" \
	--env="DB_PORT=5432" \
	--env="DB_MODE=disable" \
	--env="DB_MAXIDLECONNS=100" \
	--env="DB_MAXOPENCONNS=100" \
	--env="SERVER_IP=0.0.0.0" \
	--env="SERVER_PORT=7000" \
	--env="SERVER_TIMEOUT=10" \
	--port=9053 -- -config=''
OR
#with secrets?
kubectl apply -f bad-words.pod.yaml

kubectl expose deployment bad-words --type=NodePort
	- creates service

kubectl get service bad-words --output='yaml'

create pod config, from existing pod:
kubectl get pod bad-words-4183345525-wkdi7 --output='yaml' > bad-words.pod.yaml

minikube stop
minikube delete






