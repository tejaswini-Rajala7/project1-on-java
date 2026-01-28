# Run Jetty Server Script
# Port 8081 is already configured in pom.xml

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Jetty Server" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Maven is available
if (-not (Get-Command mvn -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] Maven not found in PATH!" -ForegroundColor Red
    Write-Host "Please install Maven or add it to your PATH." -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "Server will start on: http://localhost:8081" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Run Jetty - port is already configured in pom.xml
# If you need to override, use: mvn jetty:run "-Djetty.port=8081"
mvn jetty:run
