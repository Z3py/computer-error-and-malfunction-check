# CEMC - Diagnostic Check
# Audits unexpected shutdowns, battery wear, and power configurations

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Computer Error and Malfunction Check (CEMC) - Diagnostics " -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# 1. System Specifications
$cs = Get-CimInstance Win32_ComputerSystem
$proc = Get-CimInstance Win32_Processor | Select-Object -First 1
Write-Host "[1/5] System Information:" -ForegroundColor Green
Write-Host "  - Manufacturer : $($cs.Manufacturer)"
Write-Host "  - Model        : $($cs.Model)"
Write-Host "  - Processor    : $($proc.Name)"
Write-Host ""

# 2. Battery Wear Inspection
Write-Host "[2/5] Battery Health Audit:" -ForegroundColor Green
$battStatic = Get-CimInstance -Namespace root\wmi -ClassName BatteryStaticData -ErrorAction SilentlyContinue | Select-Object -First 1
$battFull = Get-CimInstance -Namespace root\wmi -ClassName BatteryFullChargedCapacity -ErrorAction SilentlyContinue | Select-Object -First 1

if ($battStatic -and $battFull -and $battStatic.DesignedCapacity -gt 0) {
    $design = $battStatic.DesignedCapacity
    $full = $battFull.FullChargedCapacity
    $wear = [math]::Round((($design - $full) / $design) * 100, 1)
    $health = [math]::Round(($full / $design) * 100, 1)
    Write-Host "  - Design Capacity      : $design mWh"
    Write-Host "  - Full Charge Capacity : $full mWh"
    Write-Host "  - Battery Health Level : $health%"
    Write-Host "  - Degradation / Wear   : $wear%"
    if ($wear -gt 25) {
        Write-Host "  [!] Warning: Wear level > 25% increases susceptibility to voltage brownout." -ForegroundColor Yellow
    }
} else {
    Write-Host "  - Battery query returned desktop/AC profile or restricted permissions."
}
Write-Host ""

# 3. Kernel-Power Unexpected Shutdowns
Write-Host "[3/5] Recent Kernel-Power Events (Event ID 41):" -ForegroundColor Green
$events41 = Get-WinEvent -FilterHashtable @{LogName='System'; Id=41} -MaxEvents 10 -ErrorAction SilentlyContinue
if ($events41) {
    Write-Host "  Found $($events41.Count) recent unexpected shutdown event(s):"
    foreach ($ev in $events41) {
        [xml]$xml = $ev.ToXml()
        $code = $xml.Event.EventData.Data | Where-Object { $_.Name -eq 'BugcheckCode' } | Select-Object -ExpandProperty '#text'
        $type = if ($code -eq '0') { "Instant Power Cut / Hardware Trip" } else { "BSOD (Bugcheck: $code)" }
        Write-Host "  - $($ev.TimeCreated.ToString('yyyy-MM-dd HH:mm:ss')) | $type"
    }
} else {
    Write-Host "  - Zero Kernel-Power Event 41 entries detected in current log." -ForegroundColor Green
}
Write-Host ""

# 4. Thermal & Power Configuration
Write-Host "[4/5] Power Configurations & Mitigation Status:" -ForegroundColor Green
$throttle = powercfg /query SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX | Select-String "Current AC Power Setting Index"
$throttleDC = powercfg /query SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX | Select-String "Current DC Power Setting Index"
$hiber = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name HiberbootEnabled -ErrorAction SilentlyContinue

Write-Host "  - CPU Throttle (AC/DC) : $throttle / $throttleDC"
if ($hiber) {
    $hState = if ($hiber.HiberbootEnabled -eq 1) { "Enabled (High Crash Risk on Sleep)" } else { "Disabled (Safe)" }
    Write-Host "  - Fast Startup (Hiber) : $hState"
}
Write-Host ""

# 5. Recommendation
Write-Host "[5/5] Verdict & Next Action:" -ForegroundColor Cyan
Write-Host "  Run 'Run-Fix.bat' as Administrator to apply stability protections." -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
