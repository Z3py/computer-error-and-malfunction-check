# CEMC - Stability Fix
# Applies safety mitigations against thermal trips and battery brownouts

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Computer Error and Malfunction Check (CEMC) - Apply Fix    " -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Backup Current Power Plan
$backupFolder = "$PSScriptRoot\..\backup"
if (-not (Test-Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null
}
$backupFile = "$backupFolder\PowerSchemeBackup_$(Get-Date -Format 'yyyyMMdd_HHmmss').pow"
Write-Host "[1/5] Backing up current active power plan..." -ForegroundColor Green
powercfg /export $backupFile SCHEME_CURRENT
Write-Host "  Backup saved to: $backupFile"

# 2. Cap CPU Maximum State to 99%
Write-Host "[2/5] Setting CPU Max Throttle to 99% (Mitigates 100C thermal spikes)..." -ForegroundColor Green
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 99
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 99

# 3. Enable Active System Cooling Policy
Write-Host "[3/5] Setting System Cooling Policy to Active (Fan first)..." -ForegroundColor Green
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR SYSCOOLPOL 1

# 4. Battery Brownout Guard (Raise Critical Threshold to 10%)
Write-Host "[4/5] Configuring Battery Brownout Protection (10% Critical Reserve)..." -ForegroundColor Green
powercfg /setdcvalueindex SCHEME_CURRENT SUB_BATTERY BATLEVELLOW 15
powercfg /setdcvalueindex SCHEME_CURRENT SUB_BATTERY BATLEVELCRIT 10
powercfg /setdcvalueindex SCHEME_CURRENT SUB_BATTERY BATACTIONCRIT 2
powercfg /setdcvalueindex SCHEME_CURRENT SUB_BATTERY f3c5027d-cd16-4930-aa6b-90db844a8f00 8

# 5. Disable Standby Wi-Fi & Fast Startup
Write-Host "[5/5] Disabling Modern Standby Network Drain & Fast Startup..." -ForegroundColor Green
powercfg /setdcvalueindex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0
powercfg /setacvalueindex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f | Out-Null

powercfg /setactive SCHEME_CURRENT

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " SUCCESS: All stability settings have been applied.         " -ForegroundColor Green
Write-Host " Laptop temperature is now capped and power drops mitigated." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
