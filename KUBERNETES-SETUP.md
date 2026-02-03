# 🚀 Kubernetes Deployment Guide за Windows

Това ръководство обяснява как да стартирате Car Rental System микросървисното приложение в Kubernetes на Windows.

## 📋 Предварителни изисквания

### Docker Desktop с Kubernetes (Препоръчително)
1. Инсталирайте [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. Отворете Settings → Kubernetes → ✅ Enable Kubernetes
3. Изчакайте да стартира (зеленият индикатор долу вляво)
4. Готово! Kubernetes е активиран с `kubectl` команда

## 🛠️ Build на Docker Images

Преди deployment, build-нете Docker images локално:

```powershell
# Build на всички images с една команда
docker-compose build
```

## 🚀 Deployment

### Автоматичен deployment (Препоръчително)

#### Windows (PowerShell):
```powershell
# С Docker Desktop Kubernetes
.\k8s-deploy.ps1 -Environment local -KubeCommand kubectl

# С microK8s (в WSL)
.\k8s-deploy.ps1 -Environment local -KubeCommand microk8s

# За production environment
.\k8s-deploy.ps1 -Environment production -KubeCommand kubectl
```

#### Linux/Mac (Bash):
```bash
# Направете скрипта изпълним
chmod +x k8s-deploy.sh

# С kubectl
./k8s-deploy.sh local kubectl

# С microK8s
./k8s-deploy.sh local microk8s
```powershell
# За локална разработка
.\k8s-deploy.ps1

# За production environment
.\k8s-deploy.ps1 -Environment production
```

### Ръчен deployment

```powershell
# Създайте namespace
kubectl create namespace carrentalsystem
kubectl config set-context --current --namespace=carrentalsystem

# Deploy environment configuration
kubectl apply -f .k8s/.environment/local.yml

# Deploy databases
kubectl apply -f .k8s/databases/

# Deploy event bus
kubectl apply -f .k8s/event-bus/

# Изчакайте услугите да стартират (30 секунди)
Start-Sleep -Secondstl describe pod <pod-name>

# Вижте логовете
kubectl logs <pod-name>

# Следете логовете в реално време
kubectl logs -f <pod-name>
```
powershell
## 🌐 Достъп до приложенията

### Port Forwarding (Препоръчително за локална разработка)

Отворете отделни терминали за всяко приложение:

```bash
# User Client (Angular) - http://localhost:8080
kubectl port-forward svc/user-client 8080:80

# Admin Client - http://localhost:5000
kubectl port-forward svc/admin-client 5000:80

# Watchdog (Health Checks) - http://localhost:5500
kubectl port-forward svc/watchdog-client 5500:80

# Identity Service - http://localhost:5001
kubectl port-forward svc/identity-service 5001:80

# Dealers Service - http://localhost:5002
kubectl port-forward svc/dealers-service 5002:80
за локална разработка)

Отворете отделни PowerShell прозорци за всяко приложение:

```powershell
# User Client (Angular) - http://localhost:8080
kubectl port-forward svc/user-client 8080:80

# Admin Client - http://localhost:5000
kubectl port-forward svc/admin-client 5000:80

# Watchdog (Health Checks) - http://localhost:5500
kubectl port-forward svc/watchdog-client 5500:80

# Identity Service - http://localhost:5001
kubectl port-forward svc/identity-service 5001:80

# Dealers Service - http://localhost:5002
kubectl port-forward svc/dealers-service 5002:80

# Statistics Service - http://localhost:5003
kubectl port-forward svc/statistics-service 5003:80

# Notifications Service - http://localhost:5004
kubectl port-forward svc/notifications-service 5004:

## 🧹 Изчистване

```bash
# Изтрийте всички ресурси в namespace
kubectl delete namespace carrentalsystem

# Или изтрийте поединично
kubectl delete -f .k8s/clients/
kubectl delete -f .k8s/web-services/
kubectl delete -f .k8s/event-bus/
kubectl delete -f .k8s/databases/
kubectl delete -f .k8s/.environment/local.yml
```

## 📝 Environment Конфигурации

Проектът съдържа три environment конфигурации:

- **local.yml** - За локална разработка
- **development.yml** - За development сървър
- **production.yml** - За production environment

Те съдържат ConfigMaps и Secrets с настройки за:
- Connection strings към базите данни
- Rpowershell
# Изпълнете команди в pod
kubectl exec -it <pod-name> -- /bin/bash

# Проверете events
kubectl get events --sort-by=.metadata.creationTimestamp

# Проверете persistent volumes
kubectl get pv
kubectl get pvc

# Проверете secrets и configmaps
kubectl get secrets
kubectl get configmaps
```

## 🧹 Изчистване

```powershellrnetes Documentation](https://kubernetes.io/docs/)
- [Docker Desktop Kubernetes](https://docs.docker.com/desktop/kubernetes/)
- [microK8s Documentation](https://microk8s.io/docs)
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet