# Скрипт за проверка на заети портове
Write-Host "🔍 Проверка на портове използвани от приложението..." -ForegroundColor Cyan

$ports = @(
    @{Port=1433; Service="SQL Server (Docker)"},
    @{Port=1434; Service="SQL Server (Docker - алтернативен)"},
    @{Port=5672; Service="RabbitMQ"},
    @{Port=5001; Service="Identity Service"},
    @{Port=5002; Service="Dealers Service"},
    @{Port=5003; Service="Statistics Service"},
    @{Port=5004; Service="Notifications Service"},
    @{Port=5000; Service="Admin Client"},
    @{Port=5500; Service="Watchdog"},
    @{Port=80; Service="User Client"}
)

foreach ($item in $ports) {
    $port = $item.Port
    $service = $item.Service
    
    $used = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    
    if ($used) {
        $processId = $used.OwningProcess | Select-Object -First 1
        $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
        Write-Host "❌ Порт $port ($service) е зает от: $($process.ProcessName) (PID: $processId)" -ForegroundColor Red
    } else {
        Write-Host "✅ Порт $port ($service) е свободен" -ForegroundColor Green
    }
}

Write-Host "`n💡 Ако портове са заети:" -ForegroundColor Yellow
Write-Host "  - Спрете процеса който ги заема" -ForegroundColor Gray
Write-Host "  - Или променете портовете в docker-compose.yml" -ForegroundColor Gray
