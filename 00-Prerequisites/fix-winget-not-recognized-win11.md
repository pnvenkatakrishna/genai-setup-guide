# 🛠 Incident Fix: `winget` Not Recognized in Windows 11

---

## 📌 Incident Summary

The `winget` command failed to execute on a Windows 11 system despite **App Installer being installed**.

### 🔥 Symptoms Observed

* `'winget' is not recognized as an internal or external command`
* Command works when using **full executable path**, but not via `winget`
* `winget.exe` exists but shows **0 KB size**
* Issue persists across PowerShell and CMD

---

## 🎯 Impact

* ❌ Unable to install packages via `winget`
* ❌ Breaks developer workflows and automation scripts
* ❌ Affects DevOps setups relying on system package management

---

## 🔍 Root Cause Analysis

Windows uses **App Execution Aliases** to resolve commands like `winget`, `python`, etc.

📍 Alias location:

```id="loc1"
%LOCALAPPDATA%\Microsoft\WindowsApps
```

### ⚙️ What Happened

* `winget.exe` in this directory is a **stub (alias)**, not the real binary
* It redirects execution to:

```id="loc2"
C:\Program Files\WindowsApps\
```

* The alias file became **corrupted (0 KB)**
* Windows attempted to execute the alias but failed to redirect

👉 Result: Command not recognized

---

## 🧠 Technical Insight

This is an **alias resolution failure**, similar to:

* Broken symlinks in Linux
* PATH misconfiguration issues

👉 The actual binary exists, but the **entry point (alias)** is broken

---

## 🚀 Resolution Steps (CLI Method)

### 🔹 Step 1: Verify App Installer

```powershell id="cmd1"
Get-AppxPackage *AppInstaller*
```

✅ Ensure it is installed

---

### 🔹 Step 2: Locate Actual `winget.exe`

```powershell id="cmd2"
Get-ChildItem "C:\Program Files\WindowsApps" -Recurse -Filter winget.exe
```

📌 Identify the latest version folder:

```id="cmd3"
C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_<version>_x64__8wekyb3d8bbwe
```

---

### 🔹 Step 3: Validate Broken Alias

```powershell id="cmd4"
cd $env:LOCALAPPDATA\Microsoft\WindowsApps
dir winget.exe
```

❌ If size = `0 KB` → alias is corrupted

---

### 🔹 Step 4: Remove Corrupted Alias

```powershell id="cmd5"
Remove-Item "$env:LOCALAPPDATA\Microsoft\WindowsApps\winget.exe" -Force
```

---

### 🔹 Step 5: Add Correct Path Dynamically (Permanent Fix)

```powershell id="cmd6"
$wingetPath = Get-ChildItem "C:\Program Files\WindowsApps" -Directory |
Where-Object { $_.Name -like "Microsoft.DesktopAppInstaller*" } |
Sort-Object Name -Descending |
Select-Object -First 1

[Environment]::SetEnvironmentVariable(
  "PATH",
  $env:PATH + ";" + $wingetPath.FullName,
  "User"
)
```

✅ Automatically selects latest installed version

---

### 🔹 Step 6: Restart Terminal

Close PowerShell / CMD → Reopen

---

### 🔹 Step 7: Verify Fix

```powershell id="cmd7"
winget --version
winget list
winget search git
```

✅ Confirms full functionality (not just availability)

---

## ⚡ Alternative Fix (UI Method)

1. Open **Settings**
2. Navigate:

   * `Apps` → `Advanced App Settings` → `App Execution Aliases`
3. Find:

   * **App Installer (winget)**
4. Toggle:

   * OFF → ON

👉 Recreates the alias file

---

## ⚡ Fallback (Direct Execution)

```powershell id="cmd8"
& "$($wingetPath.FullName)\winget.exe" --version
```

---

## 🧪 Example Usage

```powershell id="cmd9"
winget install Git.Git
winget install Python.Python.3.11
winget install Ollama.Ollama
```

---

## 🛡 Prevention & Best Practices

* Avoid manually modifying `WindowsApps` directory
* Keep **App Installer** updated via Microsoft Store
* Validate aliases periodically in enterprise environments
* Prefer **PATH-based execution** for stability in scripts

---

## 📊 Final Status

| Component     | Status                      |
| ------------- | --------------------------- |
| App Installer | ✅ Installed                 |
| Alias         | ❌ Corrupted                 |
| Root Cause    | ⚠️ Alias Resolution Failure |
| Fix Applied   | ✅ PATH Updated Dynamically  |
| Result        | 🚀 Fully Functional         |

---

## 🏁 Conclusion

This issue is caused by a failure in the **App Execution Alias mechanism**, not by `winget` itself.

### ✅ Reliable Solutions

* Repair alias (UI method)
* Bypass alias using PATH (recommended for stability)

---

## 💡 Interview Takeaway

This is a real-world example of:

* Debugging OS-level command resolution
* Identifying indirect failures (alias vs binary)
* Applying a **permanent, version-independent fix**

👉 Demonstrates strong troubleshooting and system engineering skills

---
