# CEMC - Restore Defaults
# Reverts power and startup configurations back to factory Windows defaults

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Computer Error and Malfunction Check (CEMC) - Restore      " -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/2] Restoring default Windows power schemes..." -ForegroundColor Green
powercfg /restoredefaultschemes

Write-Host "[2/2] Restoring Fast Startup default..." -ForegroundColor Green
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f | Out-Null

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Restored: Windows default power configurations are active.  " -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
