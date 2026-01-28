@echo off
echo ========================================
echo Streamlit Installation Script
echo ========================================
echo.

echo Checking Python installation...
python --version
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH!
    echo Please install Python from https://www.python.org/downloads/
    pause
    exit /b 1
)

echo.
echo Installing Streamlit and dependencies...
python -m pip install --upgrade pip
python -m pip install streamlit psycopg2-binary python-dotenv

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo To run the app, use:
echo   streamlit run streamlit_app.py
echo.
echo OR if streamlit command not found:
echo   python -m streamlit run streamlit_app.py
echo.
pause
