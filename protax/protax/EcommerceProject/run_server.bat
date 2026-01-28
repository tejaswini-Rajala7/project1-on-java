@echo off
echo ========================================
echo   Ecommerce Project - Server Startup
echo   (Using Maven Embedded Tomcat)
echo ========================================
echo.

REM Check if Maven is available
where mvn >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Maven not found in PATH!
    echo Please install Maven or add it to your PATH.
    echo Download from: https://maven.apache.org/download.cgi
    pause
    exit /b 1
)

REM Build the project
echo [1/2] Building project...
call mvn clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed!
    pause
    exit /b 1
)
echo [OK] Build successful!
echo.

REM Start embedded Tomcat
echo [2/2] Starting embedded Tomcat server...
echo.
echo ========================================
echo   Server will start on:
echo   http://localhost:8080/EcommerceProject-1.0/
echo.
echo   Test DB Connection:
echo   http://localhost:8080/EcommerceProject-1.0/db-test
echo.
echo   Admin Login:
echo   Email: admin@protax.com
echo   Password: admin123
echo.
echo   Press Ctrl+C to stop the server
echo ========================================
echo.

call mvn tomcat7:run

pause
