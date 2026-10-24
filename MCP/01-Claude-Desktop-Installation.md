# Install Claude Desktop

## 🎯 Objective

Install Claude Desktop using the package manager available on your operating system, launch the application, and verify that it works.

**In this guide:** We will install Claude Desktop only. We will configure MCP servers in a later lesson.

## 📋 Prerequisites

- A Windows or macOS computer
- An internet connection
- Permission to install applications
- Windows: WinGet
- macOS: Homebrew

### Supported operating systems

- Windows 10 or later
- macOS 13 (Ventura) or later

Refer to the official [Claude Desktop installation guide](https://support.claude.com/en/articles/10065433-install-claude-desktop) for current requirements.

---

## 🪟 Option 1: Windows — Install with WinGet

### Step 1: Open Windows Terminal

1. Open the Start menu.
2. Search for **Windows Terminal**.
3. Open Windows Terminal.
4. Select the **PowerShell** profile.

### Step 2: Verify WinGet

Run:

```powershell
winget --version
```

**Expected result:** A version number is displayed.

If the command is not recognized, check whether App Installer is installed and up to date.

### Step 3: Install Claude Desktop

Run:

```powershell
winget install --id Anthropic.Claude -e
```

Wait for the installation to finish. Follow any prompts displayed in the terminal.

### Step 4: Verify the installation

Run:

```powershell
winget list --id Anthropic.Claude -e
```

Confirm that Claude appears in the installed package list.

### Step 5: Launch Claude Desktop

1. Open the Start menu.
2. Search for **Claude**.
3. Open the Claude desktop application.
4. Follow the on-screen instructions to sign in.

**Success criterion:** Claude Desktop opens successfully, and you can access the main chat interface.

---

## 🍎 Option 2: macOS — Install with Homebrew

### Step 1: Open Terminal

1. Press `Command + Space`.
2. Search for **Terminal**.
3. Open Terminal.

### Step 2: Verify Homebrew

Run:

```bash
brew --version
```

**Expected result:** A version number is displayed.

If Homebrew is not installed, follow the [official Homebrew installation instructions](https://brew.sh/).

### Step 3: Install Claude Desktop

Run:

```bash
brew install --cask claude
```

Wait for the installation to finish.

### Step 4: Verify the installation

Run:

```bash
brew list --cask claude
```

Confirm that Homebrew lists the Claude application.

### Step 5: Launch Claude Desktop

1. Press `Command + Space`.
2. Search for **Claude**.
3. Open Claude Desktop.
4. Follow the on-screen instructions to sign in.

**Success criterion:** Claude Desktop opens successfully, and you can access the main chat interface.

---

## 🔄 Alternative: Install from the Official Website

Use this method if the package manager cannot find the application or installation fails.

**Official download:** https://claude.com/download

1. Open the official download page.
2. Select the correct version for your operating system and hardware.
3. Download the installer.
4. Open it and follow the installation instructions.
5. Launch Claude Desktop and sign in.

Always download the application from the official website.

---

## 🛠️ Troubleshooting

### Windows: WinGet cannot find Claude

Run:

```powershell
winget search --name Claude
```

Check the results for the Claude desktop application. If it is unavailable, use the official download page.

### Windows: WinGet is not recognized

Check whether App Installer is installed and updated. Reopen Windows Terminal and try again.

### macOS: Homebrew cannot find Claude

Run:

```bash
brew update
brew info --cask claude
```

If the installation still fails, use the official download page.

### Claude Desktop does not open

- Close the application and try again.
- Restart the computer if necessary.
- Check for operating-system or organizational restrictions.
- Consult the [Claude Help Center](https://support.claude.com/).

---

## ✅ Final Verification Checklist

- [ ] I used Windows Terminal or macOS Terminal.
- [ ] I verified that my package manager is available.
- [ ] I installed Claude Desktop.
- [ ] I verified the installation using the package manager.
- [ ] I launched Claude Desktop successfully.
- [ ] I reached the main chat interface.

## 📚 Official Resources

- [Claude Desktop Download](https://claude.com/download)
- [Claude Desktop Installation Guide](https://support.claude.com/en/articles/10065433-install-claude-desktop)
- [WinGet Documentation](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
- [Homebrew Documentation](https://docs.brew.sh/)

