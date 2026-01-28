@echo off
echo ========================================
echo Product Image URL Updater
echo ========================================
echo.
echo This will update all product image URLs in the database
echo to use working Unsplash URLs instead of local paths.
echo.
pause

cd /d "%~dp0"
call mvn compile
if %errorlevel% neq 0 (
    echo.
    echo Compilation failed! Please check for errors above.
    pause
    exit /b %errorlevel%
)

echo.
echo Running Image URL Updater...
call mvn exec:java

echo.
echo ========================================
echo Update Complete!
echo ========================================
echo.
echo Please restart your server and clear browser cache.
pause
