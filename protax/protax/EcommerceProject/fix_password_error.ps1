# Fix Password Authentication Error
Write-Host "=== Fixing Database Password Error ===" -ForegroundColor Green
Write-Host ""

# Add PostgreSQL to PATH
$env:Path += ";C:\Program Files\PostgreSQL\18\bin"

# Test current password
Write-Host "Step 1: Testing current password..." -ForegroundColor Cyan
$env:PGPASSWORD = "Itsmebabblu@789"
$testResult = psql -U postgres -c "SELECT 1;" 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "  [OK] Password 'Itsmebabblu@789' is CORRECT" -ForegroundColor Green
    $correctPassword = "Itsmebabblu@789"
} else {
    Write-Host "  [ERROR] Password 'Itsmebabblu@789' is INCORRECT" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please enter your PostgreSQL password:" -ForegroundColor Yellow
    $securePassword = Read-Host -AsSecureString
    $correctPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
    )
    
    # Test the new password
    $env:PGPASSWORD = $correctPassword
    $testResult = psql -U postgres -c "SELECT 1;" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] Password verified!" -ForegroundColor Green
    } else {
        Write-Host "  [ERROR] Password still incorrect. Please check your PostgreSQL password." -ForegroundColor Red
        exit 1
    }
}

# Update db.properties files
Write-Host ""
Write-Host "Step 2: Updating db.properties files..." -ForegroundColor Cyan

$propertiesContent = @"
# PostgreSQL Database Configuration
db.host=localhost
db.port=5432
db.name=ecommerce
db.user=postgres
db.password=$correctPassword
"@

# Update root db.properties
Set-Content -Path "db.properties" -Value $propertiesContent
Write-Host "  [OK] Updated: db.properties" -ForegroundColor Green

# Update src/main/resources/db.properties
if (-not (Test-Path "src\main\resources")) {
    New-Item -ItemType Directory -Path "src\main\resources" -Force | Out-Null
}
Set-Content -Path "src\main\resources\db.properties" -Value $propertiesContent
Write-Host "  [OK] Updated: src/main/resources/db.properties" -ForegroundColor Green

# Rebuild project
Write-Host ""
Write-Host "Step 3: Rebuilding project..." -ForegroundColor Cyan
mvn clean package -DskipTests

if ($LASTEXITCODE -eq 0) {
    Write-Host "  [OK] Build successful!" -ForegroundColor Green
} else {
    Write-Host "  [ERROR] Build failed!" -ForegroundColor Red
    exit 1
}

# Verify files are in place
Write-Host ""
Write-Host "Step 4: Verifying configuration..." -ForegroundColor Cyan

if (Test-Path "target\classes\db.properties") {
    Write-Host "  [OK] db.properties in target/classes/" -ForegroundColor Green
} else {
    Write-Host "  [ERROR] Missing from target/classes/" -ForegroundColor Red
}

if (Test-Path "target\EcommerceProject-1.0\WEB-INF\classes\db.properties") {
    Write-Host "  [OK] db.properties in WAR file" -ForegroundColor Green
} else {
    Write-Host "  [ERROR] Missing from WAR file" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Fix Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Restart your application server" -ForegroundColor White
Write-Host "  2. Test connection: http://localhost:8080/db-test" -ForegroundColor White
Write-Host ""

# Clear password from environment
$env:PGPASSWORD = $null
$correctPassword = $null
