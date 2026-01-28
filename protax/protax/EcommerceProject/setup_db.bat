@echo off
echo ========================================
echo PostgreSQL Database Setup Script
echo ========================================
echo.

REM Check if PostgreSQL is installed
where psql >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: PostgreSQL is not installed or not in PATH
    echo Please install PostgreSQL from https://www.postgresql.org/download/windows/
    pause
    exit /b 1
)

echo Step 1: Checking PostgreSQL service status...
sc query postgresql-x64-16 | find "RUNNING" >nul
if %errorlevel% neq 0 (
    echo PostgreSQL service is not running. Attempting to start...
    net start postgresql-x64-16
    if %errorlevel% neq 0 (
        echo ERROR: Could not start PostgreSQL service
        echo Please start it manually from Services (services.msc)
        pause
        exit /b 1
    )
    timeout /t 3
    echo Service started successfully!
) else (
    echo PostgreSQL service is running.
)

echo.
echo Step 2: Checking if database exists...
psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='ecommerce'" 2>nul | find "1" >nul
if %errorlevel% neq 0 (
    echo Database 'ecommerce' does not exist. Creating...
    psql -U postgres -c "CREATE DATABASE ecommerce;" 2>nul
    if %errorlevel% neq 0 (
        echo ERROR: Could not create database. Please check PostgreSQL credentials.
        echo You may need to enter the postgres user password.
        pause
        exit /b 1
    )
    echo Database created successfully!
) else (
    echo Database 'ecommerce' already exists.
)

echo.
echo Step 3: Running schema script...
if exist "database_schema_postgresql.sql" (
    psql -U postgres -d ecommerce -f database_schema_postgresql.sql 2>nul
    if %errorlevel% neq 0 (
        echo WARNING: Schema script had errors. Check manually.
    ) else (
        echo Schema script executed successfully!
    )
) else (
    echo WARNING: database_schema_postgresql.sql not found!
)

echo.
echo Step 4: Verifying tables...
psql -U postgres -d ecommerce -tAc "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public'" 2>nul
if %errorlevel% equ 0 (
    echo Database setup appears complete!
) else (
    echo WARNING: Could not verify tables. Please check manually.
)

echo.
echo ========================================
echo Setup complete!
echo ========================================
echo.
echo Next steps:
echo 1. Update db.properties with your PostgreSQL password
echo 2. Or set environment variables: DB_PASSWORD=your_password
echo 3. Restart your application server
echo.
pause
