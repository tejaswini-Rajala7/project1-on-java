# Run Server Script - Uses Maven Embedded Tomcat
# No need to install Tomcat separately!

Write-Host "========================================" -ForegroundColor Green
Write-Host "  Ecommerce Project - Server Startup" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Check if Maven is available
if (-not (Get-Command mvn -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] Maven not found in PATH!" -ForegroundColor Red
    Write-Host "Please install Maven or add it to your PATH." -ForegroundColor Yellow
    Write-Host "Download from: https://maven.apache.org/download.cgi" -ForegroundColor Cyan
    pause
    exit 1
}

# Check if PostgreSQL is running
Write-Host "[1/3] Checking PostgreSQL..." -ForegroundColor Yellow
$pgService = Get-Service postgresql* -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Running' }
if ($pgService) {
    Write-Host "  [OK] PostgreSQL is running: $($pgService.Name)" -ForegroundColor Green
} else {
    Write-Host "  [WARNING] PostgreSQL service not found or not running" -ForegroundColor Yellow
    Write-Host "  Make sure PostgreSQL is running before starting the server" -ForegroundColor Yellow
}

# Build the project
Write-Host ""
Write-Host "[2/3] Building project..." -ForegroundColor Yellow
mvn clean package -DskipTests
if ($LASTEXITCODE -ne 0) {
    Write-Host "  [ERROR] Build failed!" -ForegroundColor Red
    pause
    exit 1
}
Write-Host "  [OK] Build successful!" -ForegroundColor Green

# Start embedded Tomcat
Write-Host ""
Write-Host "[3/3] Starting embedded Tomcat server..." -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Server will start on:" -ForegroundColor White
Write-Host "  http://localhost:8080/EcommerceProject-1.0/" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Test DB Connection:" -ForegroundColor White
Write-Host "  http://localhost:8080/EcommerceProject-1.0/db-test" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Admin Login:" -ForegroundColor White
Write-Host "  Email: admin@protax.com" -ForegroundColor Cyan
Write-Host "  Password: admin123" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Run Jetty (port 8081 is configured in pom.xml)
# Note: In PowerShell, quote system properties: mvn jetty:run "-Djetty.port=8081"
# But since port is already configured, just use:
mvn jetty:run
