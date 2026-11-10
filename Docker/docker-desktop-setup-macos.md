# Docker Desktop – Installation & Setup Guide (macOS)

## 1. Introduction

Docker Desktop is an application that allows developers to build, run and manage Docker containers on macOS.

It provides:

- Docker Engine
- Docker CLI
- Docker Compose
- Container and image management

**How does Docker work on macOS?**

Docker Desktop uses a lightweight Linux virtual machine to run Linux containers on macOS.

**Important:**
- Ubuntu installation is not required.
- WSL is not required.
- VirtualBox or VMware is not required.
- Docker Desktop manages its own Linux environment.

## 2. Prerequisites

Before installing Docker Desktop, ensure that you have:

- A supported macOS version.
- At least 4 GB RAM.
- An Intel or Apple Silicon Mac supported by Docker.
- Internet connection.
- Administrator access if requested.

### Identify Your Mac Processor

1. Click the Apple menu.
2. Select **About This Mac**.
3. Check the Chip or Processor information.

| Mac Type | Examples |
|---|---|
| Apple Silicon | M1, M2, M3, M4 |
| Intel | Intel Core i5, i7 |

**Note:** The current Homebrew Docker Desktop Cask requires macOS 14 or later. Always check the latest compatibility requirements before installation.

## 3. Install Homebrew

Homebrew is a package manager for macOS. It allows users to install and manage applications using Terminal commands.

### Step 1: Check Homebrew Installation

Open Terminal and execute:

```bash
brew --version
```

If Homebrew is already installed, it displays the installed version.

### Step 2: Install Homebrew

If Homebrew is not installed, visit:

https://brew.sh/

Follow the official installation instructions.

### Step 3: Verify Homebrew Installation

```bash
brew --version
```

## 4. Install Docker Desktop Using Homebrew

### Step 1: Update Homebrew

```bash
brew update
```

This updates Homebrew's package information.

### Step 2: Install Docker Desktop

```bash
brew install --cask docker-desktop
```

**Understanding the command:**

| Component | Purpose |
|---|---|
| `brew` | Homebrew package manager |
| `install` | Installs an application |
| `--cask` | Installs a macOS desktop application |
| `docker-desktop` | Docker Desktop package identifier |

### Step 3: Launch Docker Desktop

After installation completes, execute:

```bash
open -a Docker
```

Alternatively:

1. Open Finder.
2. Navigate to Applications.
3. Double-click Docker.

### Step 4: Complete Initial Setup

1. Accept the Docker Subscription Service Agreement.
2. Complete the initial setup prompts.
3. Allow the required permissions if macOS requests them.
4. Wait until Docker Desktop indicates that the Docker Engine is running.

## 5. Configure Docker Desktop

1. Open Docker Desktop.
2. Complete any remaining setup prompts.
3. Allow the required permissions.
4. Wait until Docker Desktop indicates that the Docker Engine is running.

**Note:** Docker Desktop manages its own Linux environment. You do not need to install Ubuntu, WSL or a separate virtual machine.

## 6. Verify Docker Installation

Open Terminal and execute the following commands.

### Check Docker Version

```bash
docker --version
```

### Check Docker Compose

```bash
docker compose version
```

### Check Docker Engine

```bash
docker info
```

### Run a Test Container

```bash
docker run hello-world
```

**Expected output:**

```text
Hello from Docker!
```

If you see this message, Docker Desktop is working successfully.

## 7. Run Your First Nginx Container

Let's run a web server using Docker.

### Step 1: Download the Nginx Image

```bash
docker pull nginx
```

### Step 2: Create and Run an Nginx Container

```bash
docker run -d --name my-nginx -p 8080:80 nginx
```

### Step 3: Verify the Running Container

```bash
docker ps
```

### Step 4: Access Nginx Through the Browser

Open your browser and visit:

http://localhost:8080

You should see the Nginx welcome page.

### Step 5: Stop the Container

```bash
docker stop my-nginx
```

### Step 6: Remove the Container

```bash
docker rm my-nginx
```

## 8. Disable Automatic Startup (Optional)

Docker Desktop may start automatically whenever you log in to macOS.

If you don't want Docker Desktop to launch automatically:

1. Open **System Settings**.
2. Navigate to **General → Login Items & Extensions**.
3. Under **Open at Login**, find Docker Desktop.
4. Select Docker Desktop.
5. Click the **– (Remove)** button.

**Note:** This disables automatic application launch at login. You can manually open Docker Desktop from the Applications folder whenever you need it.

## 9. Important Docker Commands

| Command | Purpose |
|---|---|
| `brew --version` | Check Homebrew version |
| `brew update` | Update Homebrew |
| `brew upgrade --cask docker-desktop` | Upgrade Docker Desktop |
| `docker --version` | Check Docker version |
| `docker info` | Display Docker Engine information |
| `docker compose version` | Check Docker Compose |
| `docker images` | List downloaded images |
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker stop my-nginx` | Stop a container |
| `docker rm my-nginx` | Remove a container |

## 10. Troubleshooting

| Problem | Solution |
|---|---|
| `brew` command not found | Install Homebrew and configure its PATH |
| Docker command not found | Launch Docker Desktop and check Docker CLI configuration |
| Docker Engine not running | Open Docker Desktop and wait for startup |
| Docker Desktop won't open | Check macOS compatibility and installation |
| Port already in use | Choose another host port, such as 8081 |
| Permission prompt appears | Review and authorize the requested permission |

## 11. Official Documentation

- [Docker Desktop – macOS Installation](https://docs.docker.com/desktop/setup/install/mac-install/)
- [Docker Desktop Documentation](https://docs.docker.com/desktop/)
- [Homebrew Official Website](https://brew.sh/)
- [Docker Desktop – Homebrew Cask](https://formulae.brew.sh/cask/docker-desktop)
- [Docker Getting Started](https://docs.docker.com/get-started/)
- [Nginx Official Docker Image](https://hub.docker.com/_/nginx)

---

**Happy Learning!**