# PostgreSQL Database Setup Script
# This script will help you set up the ecommerce database

Write-Host "=== PostgreSQL Database Setup ===" -ForegroundColor Green
Write-Host ""

# Step 1: Check if PostgreSQL is accessible
Write-Host "Step 1: Checking PostgreSQL installation..." -ForegroundColor Yellow

$psqlFound = $false
$psqlPath = $null

# Check common PostgreSQL installation paths
$pgPaths = @(
    "C:\Program Files\PostgreSQL\16\bin\psql.exe",
    "C:\Program Files\PostgreSQL\15\bin\psql.exe",
    "C:\Program Files\PostgreSQL\14\bin\psql.exe",
    "C:\Program Files\PostgreSQL\13\bin\psql.exe",
    "C:\Program Files\PostgreSQL\12\bin\psql.exe"
)

foreach ($path in $pgPaths) {
    if (Test-Path $path) {
        $psqlPath = $path
        $psqlFound = $true
        Write-Host "  ✓ Found PostgreSQL at: $path" -ForegroundColor Green
        break
    }
}

# Check if psql is in PATH
if (-not $psqlFound) {
    try {
        $null = Get-Command psql -ErrorAction Stop
        $psqlPath = "psql"
        $psqlFound = $true
        Write-Host "  ✓ Found psql in PATH" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ PostgreSQL not found!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please install PostgreSQL from: https://www.postgresql.org/download/windows/" -ForegroundColor Yellow
        Write-Host "Or add PostgreSQL bin directory to your PATH environment variable." -ForegroundColor Yellow
        exit 1
    }
}

# Step 2: Check PostgreSQL service
Write-Host ""
Write-Host "Step 2: Checking PostgreSQL service..." -ForegroundColor Yellow
$services = Get-Service postgresql* -ErrorAction SilentlyContinue
if ($services) {
    foreach ($service in $services) {
        if ($service.Status -eq 'Running') {
            Write-Host "  ✓ PostgreSQL service is running: $($service.Name)" -ForegroundColor Green
        } else {
            Write-Host "  ⚠ PostgreSQL service is stopped: $($service.Name)" -ForegroundColor Yellow
            $start = Read-Host "  Do you want to start it? (Y/N)"
            if ($start -eq 'Y' -or $start -eq 'y') {
                Start-Service $service.Name
                Write-Host "  ✓ Service started" -ForegroundColor Green
            }
        }
    }
} else {
    Write-Host "  ⚠ Could not find PostgreSQL service" -ForegroundColor Yellow
    Write-Host "  Make sure PostgreSQL is installed and running" -ForegroundColor Yellow
}

# Step 3: Get database credentials
Write-Host ""
Write-Host "Step 3: Database Configuration" -ForegroundColor Yellow
$dbUser = Read-Host "Enter PostgreSQL username (default: postgres)"
if ([string]::IsNullOrWhiteSpace($dbUser)) {
    $dbUser = "postgres"
}

$dbPassword = Read-Host "Enter PostgreSQL password" -AsSecureString
$dbPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPassword)
)

# Step 4: Test connection
Write-Host ""
Write-Host "Step 4: Testing PostgreSQL connection..." -ForegroundColor Yellow
$env:PGPASSWORD = $dbPasswordPlain
try {
    if ($psqlPath -eq "psql") {
        $testResult = & psql -U $dbUser -c "SELECT version();" 2>&1
    } else {
        $testResult = & $psqlPath -U $dbUser -c "SELECT version();" 2>&1
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Connection successful!" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Connection failed!" -ForegroundColor Red
        Write-Host "  Error: $testResult" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "  ✗ Connection failed: $_" -ForegroundColor Red
    exit 1
}

# Step 5: Create database
Write-Host ""
Write-Host "Step 5: Creating database 'ecommerce'..." -ForegroundColor Yellow

# Check if database exists
if ($psqlPath -eq "psql") {
    $dbExists = & psql -U $dbUser -lqt 2>&1 | Select-String -Pattern "ecommerce"
} else {
    $dbExists = & $psqlPath -U $dbUser -lqt 2>&1 | Select-String -Pattern "ecommerce"
}

if ($dbExists) {
    Write-Host "  ⚠ Database 'ecommerce' already exists" -ForegroundColor Yellow
    $recreate = Read-Host "  Do you want to drop and recreate it? (Y/N) - WARNING: This will delete all data!"
    if ($recreate -eq 'Y' -or $recreate -eq 'y') {
        Write-Host "  Dropping existing database..." -ForegroundColor Yellow
        if ($psqlPath -eq "psql") {
            & psql -U $dbUser -c "DROP DATABASE ecommerce;" 2>&1 | Out-Null
        } else {
            & $psqlPath -U $dbUser -c "DROP DATABASE ecommerce;" 2>&1 | Out-Null
        }
    } else {
        Write-Host "  Skipping database creation" -ForegroundColor Yellow
        $skipCreate = $true
    }
}

if (-not $skipCreate) {
    Write-Host "  Creating database..." -ForegroundColor Yellow
    if ($psqlPath -eq "psql") {
        $createResult = & psql -U $dbUser -c "CREATE DATABASE ecommerce;" 2>&1
    } else {
        $createResult = & $psqlPath -U $dbUser -c "CREATE DATABASE ecommerce;" 2>&1
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Database created successfully!" -ForegroundColor Green
    } else {
        if ($createResult -match "already exists") {
            Write-Host "  ⚠ Database already exists (continuing...)" -ForegroundColor Yellow
        } else {
            Write-Host "  ✗ Failed to create database: $createResult" -ForegroundColor Red
            exit 1
        }
    }
}

# Step 6: Run schema script
Write-Host ""
Write-Host "Step 6: Running database schema script..." -ForegroundColor Yellow

$schemaFile = Join-Path $PSScriptRoot "database_schema_postgresql.sql"
if (-not (Test-Path $schemaFile)) {
    Write-Host "  ✗ Schema file not found: $schemaFile" -ForegroundColor Red
    exit 1
}

Write-Host "  Running: $schemaFile" -ForegroundColor Cyan
if ($psqlPath -eq "psql") {
    $schemaResult = & psql -U $dbUser -d ecommerce -f $schemaFile 2>&1
} else {
    $schemaResult = & $psqlPath -U $dbUser -d ecommerce -f $schemaFile 2>&1
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Schema script executed successfully!" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Schema execution completed with warnings" -ForegroundColor Yellow
    Write-Host "  Output: $schemaResult" -ForegroundColor Gray
}

# Step 7: Verify tables
Write-Host ""
Write-Host "Step 7: Verifying tables..." -ForegroundColor Yellow
if ($psqlPath -eq "psql") {
    $tables = & psql -U $dbUser -d ecommerce -t -c "\dt" 2>&1
} else {
    $tables = & $psqlPath -U $dbUser -d ecommerce -t -c "\dt" 2>&1
}

$expectedTables = @("users", "categories", "products", "cart", "addresses", "orders", "order_items", "reviews", "wishlist", "coupons")
$foundTables = @()

foreach ($table in $expectedTables) {
    if ($tables -match $table) {
        $foundTables += $table
        Write-Host "  ✓ Table '$table' exists" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Table '$table' not found" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "  Database: ecommerce" -ForegroundColor Cyan
Write-Host "  Tables created: $($foundTables.Count)/$($expectedTables.Count)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Update db.properties with your password:" -ForegroundColor White
Write-Host "     db.password=$dbPasswordPlain" -ForegroundColor Gray
Write-Host "  2. Test connection: http://localhost:8080/EcommerceProject-1.0/db-test" -ForegroundColor White
Write-Host "  3. Start your application server" -ForegroundColor White
Write-Host ""

# Clean up password from memory
$dbPasswordPlain = $null
$env:PGPASSWORD = $null
