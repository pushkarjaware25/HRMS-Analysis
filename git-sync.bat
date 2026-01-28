@echo off
setlocal EnableDelayedExpansion

:: =========================
:: Commit message prefix
:: =========================
set PREFIX=PC Sync commit at

:: =========================
:: Get current timestamp
:: Format: YYYY-MM-DD_HH-MM
:: =========================
for /f "tokens=1 delims=." %%A in ("%time%") do set T=%%A
set T=%T: =0%

set TIMESTAMP=%date:~10,4%-%date:~4,2%-%date:~7,2%_%T:~0,2%-%T:~3,2%

:: =========================
:: Final commit message
:: =========================
set MESSAGE=%PREFIX% %TIMESTAMP%

:: =========================
:: Git operations
:: =========================
git fetch
git pull
git add .
git commit -m "%MESSAGE%"
git push

echo.
echo ==============================
echo Git sync completed successfully
echo Commit message:
echo %MESSAGE%
echo ==============================
pause