@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Running with Administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Apply-Fix.ps1"
pause
