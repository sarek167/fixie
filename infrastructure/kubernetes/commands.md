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
kubectl rollout restart deployment fixieavatar
kubectl rollout restart deployment fixienotification
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


kubectl  port-forward service/fixieauth-service 8000:80
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