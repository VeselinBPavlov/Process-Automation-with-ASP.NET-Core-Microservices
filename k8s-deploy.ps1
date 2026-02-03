# PowerShell скрипт за deployment на Car Rental System в Kubernetes
param(
    [ValidateSet('local', 'development', 'production')]
    [string]$Environment = 'local'
)

Write-Host "🚀 Deploying Car Rental System to Kubernetes..." -ForegroundColor Green
Write-Host "Environment: $Environment" -ForegroundColor Cyan

$kubectl = 'kubectl'

# Проверете дали Kubernetes работи
Write-Host "`n✅ Checking Kubernetes cluster..." -ForegroundColor Yellow
try {
    Invoke-Expression "$kubectl cluster-info" | Out-Null
} catch {
    Write-Host "❌ Error: Kubernetes cluster is not running!" -ForegroundColor Red
    Write-Host "Please start your Kubernetes cluster (Docker Desktop, minikube, or microK8s)" -ForegroundColor Red
    exit 1
}

# Създайте namespace (ако не съществува)
Write-Host "`n📦 Creating namespace..." -ForegroundColor Yellow
Invoke-Expression "$kubectl create namespace carrentalsystem" 2>$null
Invoke-Expression "$kubectl config set-context --current --namespace=carrentalsystem"

# Deploy environment configuration
Write-Host "`n🔧 Deploying environment configuration..." -ForegroundColor Yellow
Invoke-Expression "$kubectl apply -f .k8s/.environment/$Environment.yml"

# Deploy databases
Write-Host "`n💾 Deploying databases..." -ForegroundColor Yellow
Get-ChildItem -Path ".k8s/databases" -Filter "*.yml" | ForEach-Object {
    Write-Host "  - Deploying $($_.Name)" -ForegroundColor Gray
    Invoke-Expression "$kubectl apply -f $($_.FullName)"
}

# Deploy event bus (RabbitMQ)
Write-Host "`n📨 Deploying event bus (RabbitMQ)..." -ForegroundColor Yellow
Invoke-Expression "$kubectl apply -f .k8s/event-bus/event-bus.yml"

# Изчакайте базите данни и RabbitMQ да стартират
Write-Host "`n⏳ Waiting for infrastructure services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Deploy web services
Write-Host "`n🌐 Deploying microservices..." -ForegroundColor Yellow
Get-ChildItem -Path ".k8s/web-services" -Filter "*.yml" | ForEach-Object {
    Write-Host "  - Deploying $($_.Name)" -ForegroundColor Gray
    Invoke-Expression "$kubectl apply -f $($_.FullName)"
}

# Deploy clients
Write-Host "`n💻 Deploying client applications..." -ForegroundColor Yellow
Get-ChildItem -Path ".k8s/clients" -Filter "*.yml" | ForEach-Object {
    Write-Host "  - Deploying $($_.Name)" -ForegroundColor Gray
    Invoke-Expression "$kubectl apply -f $($_.FullName)"
}

# Покажете статуса
Write-Host "`n✅ Deployment complete!" -ForegroundColor Green
Write-Host "`n📊 Checking deployment status..." -ForegroundColor Yellow
Invoke-Expression "$kubectl get pods"

Write-Host "`n📝 Полезни команди:" -ForegroundColor Cyan
Write-Host "  Всички pods:             kubectl get pods" -ForegroundColor Gray
Write-Host "  Всички services:         kubectl get services" -ForegroundColor Gray
Write-Host "  Логове:                  kubectl logs <pod-name>" -ForegroundColor Gray
Write-Host "  Изтриване:               kubectl delete namespace carrentalsystem" -ForegroundColor Gray

Write-Host "`n🌐 За достъп до приложенията отворете нови PowerShell прозорци:" -ForegroundColor Yellow
Write-Host "  User Client:             kubectl port-forward svc/user-client 8080:80" -ForegroundColor Gray
Write-Host "  Admin Client:            kubectl port-forward svc/admin-client 5000:80" -ForegroundColor Gray
Write-Host "  Watchdog:                kubectl port-forward svc/watchdog-client 5500:80" -ForegroundColor Gray
