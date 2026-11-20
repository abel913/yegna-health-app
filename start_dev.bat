@echo off
echo ========================================================
echo Starting Yegna Health Development Stack
echo ========================================================

echo [1/3] Starting Backend API Server on Port 5000...
start "Yegna Backend Server (5000)" cmd /k "cd /d %~dp0server && npm run dev"

echo [2/3] Starting Admin Web CMS on Port 5174...
start "Yegna Admin Web (5174)" cmd /k "cd /d %~dp0admin-web && npm run dev"

echo [3/3] Starting Flutter Web on Port 8080...
start "Yegna Flutter Web (8080)" cmd /k "cd /d %~dp0 && node scratch/serve_web.js"

echo ========================================================
echo All 3 services launched in separate windows!
echo - Backend API:  http://localhost:5000/api
echo - Admin Web:    http://localhost:5174/
echo - Flutter Web:  http://localhost:8080/
echo ========================================================
pause
