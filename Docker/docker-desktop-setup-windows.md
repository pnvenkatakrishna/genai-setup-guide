# Docker Desktop – Installation & Setup Guide (Windows)

## 1. Introduction

Docker Desktop is an application that allows us to build, run and manage Docker containers on Windows.

Docker Desktop uses **WSL 2 (Windows Subsystem for Linux 2)** as its backend to run Linux containers.

## 2. Prerequisites

Before installing Docker Desktop, ensure that you have:

- Windows 10 or Windows 11 (supported version).
- Minimum 8 GB RAM recommended.
- Hardware virtualization enabled (Intel VT-x / AMD-V).
- Administrator access.
- Internet connection.

**Important:**
- WSL 2 is required when using the recommended WSL 2 backend.
- Installing Ubuntu separately is optional.
- Installing VirtualBox or VMware is not required.
- Docker Desktop manages its own Linux environment through WSL 2.

## 3. Install and Configure WSL 2

**Step 1: Open PowerShell as Administrator.**

**Step 2: Check whether WSL is installed.**

```powershell
wsl --status
```

**Step 3: Install WSL if it is not already installed.**

```powershell
wsl --install
```

**Step 4: Update WSL.**

```powershell
wsl --update
```

**Step 5: Set WSL 2 as the default version.**

```powershell
wsl --set-default-version 2
```

**Step 6: Verify WSL installation.**

```powershell
wsl --version
```

**Note:** If WSL is already installed and working, you do not need to install it again. If Windows requests a restart, restart your machine before proceeding.

## 4. Install Docker Desktop Using Winget

Winget is the Windows Package Manager used to install applications from the command line.

**Step 1: Verify Winget availability.**

```powershell
winget --version
```

**Step 2: Install Docker Desktop.**

```powershell
winget install -e --id Docker.DockerDesktop
```

**Step 3:** Wait for the installation to complete.

**Step 4:** Restart Windows if required.

## 5. Configure Docker Desktop

**Step 1:** Open Docker Desktop from the Windows Start menu.

**Step 2:** Accept the Docker Subscription Service Agreement and complete the initial setup.

**Step 3:** Navigate to:

`Settings → General`

Ensure that **Use the WSL 2 based engine** is enabled.

**Step 4:** Navigate to:

`Settings → Resources → WSL Integration`

Ubuntu integration is optional. Enable it only if you have installed Ubuntu and want to use Docker commands from its terminal.

**Step 5:** Click Apply & Restart if you changed any settings.

Wait until Docker Desktop indicates that the Docker Engine is running.

## 6. Verify Docker Installation

Open PowerShell and execute the following commands.

**Check Docker version:**

```powershell
docker --version
```

**Check Docker Compose:**

```powershell
docker compose version
```

**Check Docker Engine:**

```powershell
docker info
```

**Run a test container:**

```powershell
docker run hello-world
```

If you see the following message, Docker is working successfully:

```text
Hello from Docker!
```

## 7. Run Your First Nginx Container

Let's run a web server using Docker.

**Step 1: Download the Nginx image.**

```powershell
docker pull nginx
```

**Step 2: Create and run an Nginx container.**

```powershell
docker run -d --name my-nginx -p 8080:80 nginx
```

**Step 3: Verify the running container.**

```powershell
docker ps
```

**Step 4: Open your browser and visit:**

http://localhost:8080

You should see the Nginx welcome page.

**Step 5: Stop the container.**

```powershell
docker stop my-nginx
```

**Step 6: Remove the container.**

```powershell
docker rm my-nginx
```

## 8. Important Docker Commands

| Command | Purpose |
|---|---|
| `wsl --status` | Check WSL status |
| `wsl --update` | Update WSL |
| `wsl --list --verbose` | List installed Linux distributions |
| `docker --version` | Check Docker version |
| `docker info` | Display Docker Engine information |
| `docker images` | List downloaded images |
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker stop <container>` | Stop a container |
| `docker rm <container>` | Remove a container |

## 9. Official Documentation

- Docker Desktop Installation: https://docs.docker.com/desktop/setup/install/windows-install/
- Docker Desktop WSL 2 Backend: https://docs.docker.com/desktop/features/wsl/
- Microsoft WSL Installation: https://learn.microsoft.com/en-us/windows/wsl/install
- Docker Getting Started: https://docs.docker.com/get-started/

---

## Installation Completed!

You have successfully installed and configured Docker Desktop on Windows.

**Expected outcome:**

- Docker Desktop installed and running.
- WSL 2 backend configured.
- Docker Engine verified.
- Docker Compose available.
- Hello World container executed successfully.
- Nginx container running and accessible through a browser.
---

#### **Note – Disable Automatic Startup (Optional)**

After installing Docker Desktop, you can disable its automatic startup to avoid launching it every time Windows starts.

Steps:
1. Open **Task Manager**.
2. Navigate to **Startup apps**.
3. Find **Docker Desktop.exe**.
4. Right-click and select **Disable**.

**Important:** Disabling startup does not uninstall Docker Desktop or affect its configuration. You can manually launch Docker Desktop from the Windows Start menu whenever you need to work with containers.

**Happy Learning!**