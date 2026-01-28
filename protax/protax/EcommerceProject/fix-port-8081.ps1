# Fix Port 8081 Already in Use Error
# This script finds and kills the process using port 8081

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Fixing Port 8081 Conflict" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Find process using port 8081
Write-Host "Checking for processes using port 8081..." -ForegroundColor Yellow
$processes = netstat -ano | findstr :8081 | Select-String "LISTENING"

if ($processes) {
    $pid = ($processes[0] -split '\s+')[-1]
    Write-Host "Found process using port 8081: PID $pid" -ForegroundColor Yellow
    
    # Get process name
    try {
        $processName = (Get-Process -Id $pid -ErrorAction Stop).ProcessName
        Write-Host "Process name: $processName" -ForegroundColor Yellow
    } catch {
        Write-Host "Could not get process name (may have already stopped)" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "Stopping process..." -ForegroundColor Yellow
    
    try {
        Stop-Process -Id $pid -Force -ErrorAction Stop
        Write-Host "✓ Successfully stopped process $pid" -ForegroundColor Green
        Write-Host ""
        Write-Host "Port 8081 is now free. You can start the server now." -ForegroundColor Green
    } catch {
        Write-Host "✗ Could not stop process. You may need to run as Administrator." -ForegroundColor Red
        Write-Host ""
        Write-Host "Try running this command manually:" -ForegroundColor Yellow
        Write-Host "  taskkill /PID $pid /F" -ForegroundColor Cyan
    }
} else {
    Write-Host "No process found using port 8081." -ForegroundColor Green
    Write-Host "The port should be available now." -ForegroundColor Green
}

Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
