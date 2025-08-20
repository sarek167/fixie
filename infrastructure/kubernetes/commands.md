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

docker system prune
```

**Restart deployment**
```bash
kubectl rollout restart deployment fixieauth
kubectl rollout restart deployment fixietasks
kubectl rollout restart deployment fixieavatar
kubectl rollout restart deployment fixienotification
kubectl rollout restart deployment fixieavatar-worker
kubectl rollout restart deployment fixienotification-worker
```

**Logs if not present**
```bash
kubectl describe pod
```

**Start microservices**
```bash
kubectl apply -f fixieAuth-deployment.yaml
kubectl apply -f fixieAuth-service.yaml
kubectl apply -f fixieTasks-deployment.yaml
kubectl apply -f fixieTasks-service.yaml
kubectl apply -f fixieAvatar-deployment.yaml
kubectl apply -f fixieAvatar-service.yaml
kubectl apply -f fixieNotification-deployment.yaml
kubectl apply -f fixieNotification-service.yaml
kubectl apply -f fixieAvatar-worker-deployment.yaml
kubectl apply -f fixieNotification-worker-deployment.yaml
kubectl apply -f fixieNotification-rmOld-cronJob.yaml

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
bin/zookeeper-server-start.sh config/zookeeper.properties
bin/kafka-server-start.sh config/server.properties

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
export DJANGO_SETTINGS_MODULE=fixieNotification.settings
daphne -b 0.0.0.0 -p 8003 fixieNotification.asgi:application
```

**kustomize**
```bash
kustomize build --load-restrictor=LoadRestrictionsNone k8s/overlays/local | kubectl apply -f -
kubectl get deploy,po,svc,cm,secret -n default
kubectl describe secret fixieauth-secrets


kubectl  port-forward service/fixieauth 8000:80
kubectl  port-forward service/fixietasks 8001:80
kubectl  port-forward service/fixieavatar 8002:80
kubectl  port-forward service/fixienotification 8003:80
```


```bash
POD=$(kubectl get po -l app=fixieauth -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it "$POD" -- sh -lc '
python - << "PY"
import os, sys
os.environ.setdefault("DJANGO_SETTINGS_MODULE", os.getenv("DJANGO_SETTINGS_MODULE","fixieAuth.settings"))
import django
django.setup()
from django.db import connections
try:
    with connections["default"].cursor() as c:
        c.execute("SELECT 1")
        print("DB OK:", c.fetchone())
except Exception as e:
    print("DB ERROR:", repr(e))
    sys.exit(1)
PY
'



kubectl exec -it "$POD" -- env | egrep 'DB_|DATABASE_URL|DJANGO_SETTINGS_MODULE'



kubectl  run mssql-cli --rm -it --image=mcr.microsoft.com/mssql-tools --restart=Never -- \
/opt/mssql-tools/bin/sqlcmd -S tcp:$DB_HOST,1433 -U $DB_USER -P $DB_PASSWORD -Q "SELECT 1"

# zdarzenia poda
kubectl  describe pod "$POD"
kubectl fixie get events --sort-by=.lastTimestamp | tail -n 30

# sprawdzenie czy serwis wystaje i odpowiada w klastrze
kubectl  run curl --rm -it --image=alpine --restart=Never -- \
sh -lc 'apk add --no-cache curl >/dev/null && curl -i http://fixieauth.fixie.svc.cluster.local/'

kubectl run mssql-cli --rm -it --image=mcr.microsoft.com/mssql-tools --restart=Never \
  --env="DB_HOST=sql-server-fixie.database.windows.net" \
  --env="DB_USER=tasks_admin" \
  --env="DB_PASSWORD=Lemonade001!" \
  -- /bin/sh -lc '/opt/mssql-tools/bin/sqlcmd -S tcp:${DB_HOST},1433 -U ${DB_USER} -P ${DB_PASSWORD} -Q "SELECT 1"'

```

**Restart pod with conf**
```bash
kustomize build --load-restrictor=LoadRestrictionsNone k8s/overlays/local | kubectl apply -f -
kubectl -n default rollout restart deploy/fixieauth
```


**Kafka**
```bash
kubectl create ns messaging
kubectl create ns cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager -n cert-manager --set crds.enabled=true
# po chwili:
helm install rp redpanda/redpanda -n messaging \
  --set statefulset.replicas=1 \
  --set storage.persistentVolume.enabled=false \
  --set external.enabled=false

# sprawdź usługi i nazwę bootstrapu
kubectl -n messaging get svc
```

**Sekret do obrazów**
```bash
kubectl create secret docker-registry acr-pull-secret \
  --docker-server=$ACR \
  --docker-username=fixieacr \
  --docker-password=RrrpKAWDyepd6Kl9RuD3wWBc6xBFWawPmlK/VsQWc9+ACRDLIJbO \
  --docker-email=none


kubectl patch serviceaccount default \
  -p '{"imagePullSecrets":[{"name":"acr-pull-secret"}]}'


```

**push images**
```bash
ACR=fixieacr.azurecr.io
IMG=fixieauth
TAG=v2

# tag z pełnym repo ACR
docker tag fixieauth-image $ACR/$IMG:$TAG

# zaloguj się do rejestru dockerem
docker login $ACR -u <username> -p <password>

# push
docker push $ACR/$IMG:$TAG

az acr repository list -n fixieacr -o table
az acr repository show-tags -n fixieacr --repository $IMG -o table


```

az aks nodepool add \
  -g fixie -n amdpool -c 2 \
  --cluster-name fixieaks \
  --node-vm-size Standard_D2s_v5 \
  --mode User

<!-- IP 192.168.49.2 -->