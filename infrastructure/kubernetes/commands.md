# Kubernetes start

**Start minikube**
```bash
minikube start
eval $(minikube docker-env)
```

**Build images**
```bash
docker build -t fixieauth-image .

docker build -t fixietasks-image .
```

**Restart deployment**
```bash
kubectl rollout restart deployment fixieauth
kubectl rollout restart deployment fixietasks
```

**Start microservices**
```bash
kubectl apply -f fixieAuth-deployment.yaml
kubectl apply -f fixieAuth-service.yaml
kubectl apply -f fixieTasks-deployment.yaml
kubectl apply -f fixieTasks-service.yaml
```

**Check microservices**
```bash
kubectl get pods
kubectl get services
kubectl logs <nazwa-poda>\
kubectl get service
```

**Kafka locally**
```bash
bin/kafka-server-start.sh config/server.properties
bin/zookeeper-server-start.sh config/zookeeper.properties
```

**Kafka workers**
```bash
# avatar worker
python3 manage.py run_avatar_worker

# notification worker
python3 manage.py run_notification_worker
```

**Notifications microservice**
```bash
daphne -b 0.0.0.0 -p 8003 fixieNotification.asgi:application
```