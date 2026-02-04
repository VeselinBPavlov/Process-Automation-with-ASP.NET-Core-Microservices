# Script to check build status of all microservices
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Checking Build Status for All Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to check dotnet build
function Test-DotNetBuild {
    param (
        [string]$ProjectPath,
        [string]$ServiceName
    )
    
    Write-Host "Checking $ServiceName..." -ForegroundColor Yellow
    Push-Location $ProjectPath
    
    $output = dotnet build --no-restore 2>&1
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -eq 0) {
        Write-Host "✓ $ServiceName: BUILD SUCCESSFUL" -ForegroundColor Green
    } else {
        Write-Host "✗ $ServiceName: BUILD FAILED" -ForegroundColor Red
        Write-Host $output -ForegroundColor Red
    }
    
    Pop-Location
    Write-Host ""
    
    return $exitCode -eq 0
}

# Function to check Angular build
function Test-AngularBuild {
    Write-Host "Checking Angular Client..." -ForegroundColor Yellow
    Push-Location "Client"
    
    # Check if node_modules exists
    if (!(Test-Path "node_modules")) {
        Write-Host "⚠ node_modules not found. Run 'npm install' first." -ForegroundColor Yellow
        Pop-Location
        return $false
    }
    
    # Run ng build dry run
    $output = npm run build 2>&1
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -eq 0) {
        Write-Host "✓ Angular Client: BUILD SUCCESSFUL" -ForegroundColor Green
    } else {
        Write-Host "✗ Angular Client: BUILD FAILED" -ForegroundColor Red
        Write-Host $output -ForegroundColor Red
    }
    
    Pop-Location
    Write-Host ""
    
    return $exitCode -eq 0
}

# Track results
$results = @()

# Check .NET Microservices
Write-Host "=== .NET Microservices ===" -ForegroundColor Cyan
Write-Host ""

$results += @{
    Service = "Identity Service"
    Success = Test-DotNetBuild -ProjectPath "Server\CarRentalSystem.Identity" -ServiceName "Identity Service"
}

$results += @{
    Service = "Dealers Service"
    Success = Test-DotNetBuild -ProjectPath "Server\CarRentalSystem.Dealers" -ServiceName "Dealers Service"
}

$results += @{
    Service = "Statistics Service"
    Success = Test-DotNetBuild -ProjectPath "Server\CarRentalSystem.Statistics" -ServiceName "Statistics Service"
}

$results += @{
    Service = "Notifications Service"
    Success = Test-DotNetBuild -ProjectPath "Server\CarRentalSystem.Notifications" -ServiceName "Notifications Service"
}

$results += @{
    Service = "Watchdog Service"
    Success = Test-DotNetBuild -ProjectPath "Server\CarRentalSystem.Watchdog" -ServiceName "Watchdog Service"
}

$results += @{
    Service = "Admin Client"
    Success = Test-DotNetBuild -ProjectPath "Server\CarRentalSystem.Admin" -ServiceName "Admin Client"
}

# Check Angular Client
Write-Host "=== Angular Client ===" -ForegroundColor Cyan
Write-Host ""

$results += @{
    Service = "User Client (Angular)"
    Success = Test-AngularBuild
}

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Build Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$successCount = ($results | Where-Object { $_.Success }).Count
$totalCount = $results.Count

foreach ($result in $results) {
    $status = if ($result.Success) { "✓ PASS" } else { "✗ FAIL" }
    $color = if ($result.Success) { "Green" } else { "Red" }
    Write-Host "$status - $($result.Service)" -ForegroundColor $color
}

Write-Host ""
Write-Host "Total: $successCount/$totalCount services built successfully" -ForegroundColor $(if ($successCount -eq $totalCount) { "Green" } else { "Yellow" })

if ($successCount -eq $totalCount) {
    Write-Host ""
    Write-Host "All services are ready to run! ✓" -ForegroundColor Green
    exit 0
} else {
    Write-Host ""
    Write-Host "Some services have build errors. Please fix them before deploying." -ForegroundColor Yellow
    exit 1
}
