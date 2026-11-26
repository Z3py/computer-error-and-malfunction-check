# Computer Error and Malfunction Check (CEMC) 🛡️

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-blue.svg)](https://www.microsoft.com/windows)
[![Architecture](https://img.shields.io/badge/Architecture-x64%20%7C%20ARM64-lightgrey.svg)]()
[![Pure PowerShell](https://img.shields.io/badge/No%20Dependencies-Pure%20PowerShell-brightgreen.svg)]()

> **Universal Windows Diagnostic & Stability Utility** to diagnose hardware/software malfunctions, prevent sudden shutdowns (*Kernel-Power Event 41*), eliminate thermal trip spikes (100°C), and protect against degraded battery brownouts.

---

## 🌟 The Problem: Why Do Modern Laptops Shut Down Randomly?

Millions of Windows users (especially on modern thin-and-light laptops with Intel Core 11th/12th/13th/14th Gen or AMD Ryzen) experience **mysterious sudden shutdowns**:
- The laptop screen goes black instantly without any warning or Blue Screen (BSOD).
- Windows Event Viewer logs **Kernel-Power Event ID 41 with `BugcheckCode: 0`**.
- It happens while actively working, gaming, browsing, or even while plugged into the charger.
- After rebooting, Windows often enters **Startup Repair / Automatic Repair** because of abrupt power failures.

### The Real Causes:
1. **Aggressive Turbo Boost Spikes (Thermal Cutoff):** Under burst load, processors can surge to 45W–65W+ within milliseconds. In thin laptop chassis, temperatures can instantly hit the ACPI critical limit (**`_CRT = 100°C`**), triggering an instant hardware safety power cut to prevent silicon damage.
2. **Degraded Battery Voltage Sags (Brownouts):** As batteries age and lose capacity (e.g. down to 60%–70%), their internal resistance increases. A sudden power spike or a minor charger cable bump causes the battery voltage to drop below the motherboard's threshold, resulting in an immediate shutoff.
3. **Modern Standby (S0) & Fast Startup Conflict:** Windows Fast Startup (*Hiberboot*) and Modern Standby can corrupt power states and drain battery in sleep, causing shutdown errors during wake transitions.

---

## 🚀 Features

- 🔍 **Automated Diagnostics:**
  - Audits recent **Kernel-Power Event 41** & **EventLog 6008** unexpected shutdowns.
  - Inspects battery health: calculates **Design Capacity vs. Full Charge Capacity** and wear percentage.
  - Queries ACPI thermal zones for critical trip points (`_CRT`).
  - Checks Fast Startup and Modern Standby states.
- 🛡️ **1-Click Stability Fix (Safe & Non-Destructive):**
  - **Caps CPU Max State at 99%:** Eliminates extreme 55W+ thermal spikes and drops operating temperatures by **15°C – 25°C** while maintaining smooth performance.
  - **Enables Active Cooling Policy:** Forces cooling fans to ramp up *before* the CPU overheats.
  - **Smart Battery Protection:** Raises the critical battery reserve to 10% (default is an unsafe 2%), triggering a graceful Hibernate before a battery brownout cuts power.
  - **Disables Standby Network Drain:** Stops background apps from overheating the laptop while the lid is closed.
  - **Disables Fast Startup (Hiberboot):** Eliminates session corruption during boot/shutdown.
- 🔄 **100% Reversible & Safe:**
  - Automatically exports a backup of your current power scheme before applying changes.
  - Provides a 1-click **Restore Defaults** option to revert all settings to factory state at any time.
- 💻 **Zero Dependencies:** Pure PowerShell & Batch. No third-party executables, no telemetry, no installation required.

---

## 📦 Quick Start

### Option 1: 1-Click Launchers (Recommended for Everyone)
1. Download or clone this repository:
   ```bash
   git clone https://github.com/Z3py/computer-error-and-malfunction-check.git
   ```
2. In the folder, right-click and choose **"Run as administrator"**:
   - `Run-Check.bat` — Diagnoses your PC and displays a full health summary.
   - `Run-Fix.bat` — Applies all stability and anti-shutdown mitigations.
   - `Run-Restore.bat` — Reverts everything back to Windows defaults.

### Option 2: PowerShell Direct Execution
Open PowerShell as Administrator and run:
```powershell
# 1. Run Diagnostic
.\scripts\Check-System.ps1

# 2. Apply Stability Fix
.\scripts\Apply-Fix.ps1

# 3. Restore Defaults (if needed)
.\scripts\Restore-Defaults.ps1
```

---

## 📊 Compatibility

Works on all Windows laptops and desktops:
- **Operating Systems:** Windows 10 (all versions), Windows 11 (21H2, 22H2, 23H2, 24H2+).
- **OEM Brands:** MSI, ASUS, Lenovo, Acer, HP, Dell, Microsoft Surface, Samsung, Gigabyte, etc.
- **Processors:** Intel (Core i3, i5, i7, i9, Ultra) & AMD (Ryzen 3, 5, 7, 9).

---

## 📖 Product Requirement Document (PRD)

For in-depth technical specifications, problem research, ACPI specifications, and future roadmap, read our **[Product Requirement Document (PRD.md)](./docs/PRD.md)**.

---

## 🤝 Contributing

Contributions are warmly welcome! Whether reporting bugs, suggesting features, or testing on different hardware brands:
- Read [CONTRIBUTING.md](./CONTRIBUTING.md) to get started.
- Open an [Issue](https://github.com/Z3py/computer-error-and-malfunction-check/issues) if you have test results or feedback.

---

## 📄 License

This project is licensed under the [MIT License](./LICENSE) — free for personal and commercial use.
