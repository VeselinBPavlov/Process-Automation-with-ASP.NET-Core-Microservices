# Setup скрипт за Minikube deployment

Write-Host "🚀 Setting up Minikube for Car Rental System..." -ForegroundColor Green

# Проверка дали Minikube работи
Write-Host "`n✅ Checking Minikube status..." -ForegroundColor Yellow
$minikubeStatus = minikube status 2>&1 | Out-String
if ($minikubeStatus -notlike "*Running*") {
    Write-Host "❌ Minikube is not running! Starting..." -ForegroundColor Red
    minikube start --driver=hyperv
} else {
    Write-Host "✅ Minikube is running" -ForegroundColor Green
}

# Set Docker environment за Minikube
Write-Host "`n🐳 Configuring Docker to use Minikube..." -ForegroundColor Yellow
Write-Host "Run this command in your terminal:" -ForegroundColor Cyan
Write-Host "  minikube docker-env --shell powershell | Invoke-Expression" -ForegroundColor White
Write-Host ""
Write-Host "Or run this script with elevated permissions to auto-configure" -ForegroundColor Gray

# Build images в Minikube Docker environment
Write-Host "`n🔨 Building Docker images..." -ForegroundColor Yellow
Write-Host "Make sure to run: minikube docker-env --shell powershell | Invoke-Expression" -ForegroundColor Cyan
Write-Host "Then run: docker-compose build" -ForegroundColor Cyan

Write-Host "`n📦 Alternative: Use imagePullPolicy: Never in K8s manifests" -ForegroundColor Yellow
Write-Host "This tells Kubernetes to use locally built images" -ForegroundColor Gray

# Deploy приложението
Write-Host "`n🚀 Ready to deploy!" -ForegroundColor Green
Write-Host "Run: .\k8s-deploy.ps1 -KubeCommand minikube" -ForegroundColor Cyan

Write-Host "`n📊 Useful Minikube commands:" -ForegroundColor Yellow
Write-Host "  minikube dashboard          - Open Kubernetes dashboard" -ForegroundColor Gray
Write-Host "  minikube service <name>     - Get service URL" -ForegroundColor Gray
Write-Host "  minikube tunnel             - Expose LoadBalancer services" -ForegroundColor Gray
Write-Host "  minikube docker-env         - Configure Docker to use Minikube" -ForegroundColor Gray
Write-Host "  minikube kubectl -- <cmd>   - Run kubectl commands" -ForegroundColor Gray
