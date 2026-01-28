@echo off
echo ========================================
echo   Fixing Port 8081 Conflict
echo ========================================
echo.

echo Checking for processes using port 8081...
netstat -ano | findstr :8081 | findstr LISTENING >nul

if %ERRORLEVEL% EQU 0 (
    echo Found process using port 8081.
    echo.
    
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8081 ^| findstr LISTENING') do (
        set PID=%%a
        echo Stopping process PID: %%a
        taskkill /PID %%a /F >nul 2>&1
        if %ERRORLEVEL% EQU 0 (
            echo Successfully stopped process %%a
        ) else (
            echo Failed to stop process. Try running as Administrator.
            echo Manual command: taskkill /PID %%a /F
        )
    )
    
    echo.
    echo Port 8081 should now be free.
) else (
    echo No process found using port 8081.
    echo Port should be available.
)

echo.
pause
