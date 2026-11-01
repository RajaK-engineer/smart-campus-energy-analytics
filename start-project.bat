@echo off
title Smart Campus Energy Analytics Platform
echo =======================================================
echo   Starting Smart Campus Energy Analytics Platform
echo =======================================================
echo.

echo [1/2] Starting Smart Campus Unified Platform (Port 5000)...
start "Smart Campus Platform" cmd /k "cd /d "%~dp0backend" && python -m uvicorn main:app --port 5000 --host 0.0.0.0 --reload"

echo [2/2] Opening Browser...
timeout /t 3 /nobreak >nul
start http://localhost:5000

echo.
echo =======================================================
echo   System Launched Successfully!
echo   Platform Link (Frontend + Backend): http://localhost:5000
echo   Admin Portal:                       http://localhost:5000/admin
echo   Management Portal:                  http://localhost:5000/management
echo   Swagger API Documentation:          http://localhost:5000/docs
echo =======================================================
