# Claude Local Environment Setup

> Build a clean, isolated, reproducible Python development environment for Claude API projects.

---

# 1. Goal

This guide prepares your local computer for Claude API development.

We will build the following environment:

```text
Claude API
    │
    ▼
Anthropic Python SDK
    │
    ▼
Python Application
    │
    ▼
Virtual Environment
    │
    ▼
Your Operating System
```

By the end of this guide, you will understand:

* Python requirements for the Claude SDK
* Why virtual environments are important
* Python `venv`
* `pip`
* `uv`
* Project structure
* `.env`
* `.env.example`
* `.gitignore`
* Installing the Anthropic SDK
* Verifying the environment
* Windows PowerShell setup
* Git Bash setup
* macOS/Linux setup
* Dependency management
* Common environment problems

---

# 2. Prerequisites

Before starting, you should already have:

* A Claude Console account
* An API key
* A working computer
* Internet access
* Python 3.10 or newer

Anthropic's current Python SDK requires **Python 3.10 or later**.

Check your Python version:

```powershell
python --version
```

or:

```powershell
python3 --version
```

Expected:

```text
Python 3.10+
```

For example:

```text
Python 3.13.7
```

The exact version is not important as long as it satisfies the SDK requirement.

---

# 3. Why We Need an Isolated Environment

A common beginner mistake is installing every Python package globally.

For example:

```text
Computer
│
└── Global Python
      ├── anthropic
      ├── langchain
      ├── boto3
      ├── fastapi
      ├── pandas
      └── ...
```

Eventually different projects may require different versions.

This can create dependency conflicts.

Instead:

```text
Computer
│
├── Project A
│     └── Virtual Environment
│
├── Project B
│     └── Virtual Environment
│
└── Project C
      └── Virtual Environment
```

Each project controls its own dependencies.

---

# 4. What Is a Virtual Environment?

A Python virtual environment is an isolated environment containing the Python packages required by a project.

Conceptually:

```text
Operating System
       │
       ▼
Python Installation
       │
       ├───────────────┐
       ▼               ▼
Project A          Project B
   │                  │
   ▼                  ▼
.venv              .venv
   │                  │
   ▼                  ▼
Packages            Packages
```

This prevents unrelated projects from interfering with each other.

---

# 5. Why Virtual Environments Matter for Claude Projects

Claude applications rarely remain simple.

A project may eventually contain:

```text
anthropic
python-dotenv
pydantic
fastapi
uvicorn
langchain
langgraph
chromadb
```

Another project may require different versions.

Without isolation:

```text
Project A
    │
    └── Package version conflict
              │
              ▼
          Project B breaks
```

With virtual environments:

```text
Project A
    │
    └── .venv
          └── dependencies

Project B
    │
    └── .venv
          └── different dependencies
```

---

# 6. Two Tools You Should Know

Python projects commonly use:

* `pip`
* `uv`

Both are useful.

For this repository, we will explain both, but the first environment can be created using Python's built-in `venv`.

---

# 7. Option A — Python `venv`

`venv` is included with Python.

Create a project:

```powershell
mkdir claude-api-demo
cd claude-api-demo
```

Create a virtual environment:

```powershell
python -m venv .venv
```

This creates:

```text
claude-api-demo/
└── .venv/
```

---

# 8. Windows Project Structure

After creating the environment:

```text
claude-api-demo/
└── .venv/
```

Later the project will look like:

```text
claude-api-demo/
│
├── .venv/
├── .env
├── .env.example
├── .gitignore
├── requirements.txt
└── main.py
```

The `.venv` directory is local infrastructure.

It should not be committed to Git.

---

# 9. Activate the Virtual Environment — PowerShell

On Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

After activation, you should see something similar to:

```text
(.venv) PS C:\Projects\claude-api-demo>
```

The `(.venv)` prefix indicates that the environment is active.

---

# 10. PowerShell Execution Policy Problem

Some Windows systems may prevent PowerShell from executing activation scripts.

You may see an error similar to:

```text
running scripts is disabled on this system
```

This is a PowerShell execution-policy issue, not a Claude problem.

Check the current policy:

```powershell
Get-ExecutionPolicy
```

For development environments, Windows can be configured to permit locally created scripts according to your organization's security policy.

If you are working on a managed corporate computer, do not blindly change security policies. Follow your organization's policy.

An alternative is to use Command Prompt or Git Bash.

---

# 11. Activate Using Command Prompt

If using Windows Command Prompt:

```cmd
.venv\Scripts\activate.bat
```

You should see:

```text
(.venv) C:\Projects\claude-api-demo>
```

---

# 12. Activate Using Git Bash

In Git Bash:

```bash
source .venv/Scripts/activate
```

You should see:

```text
(.venv)
```

before your shell prompt.

---

# 13. macOS/Linux

Create the project:

```bash
mkdir claude-api-demo
cd claude-api-demo
```

Create the environment:

```bash
python3 -m venv .venv
```

Activate:

```bash
source .venv/bin/activate
```

You should see:

```text
(.venv)
```

---

# 14. Verify the Active Python

After activating the environment:

```powershell
python --version
```

Then:

```powershell
python -c "import sys; print(sys.executable)"
```

The executable should point inside your project environment.

For Windows:

```text
...\claude-api-demo\.venv\Scripts\python.exe
```

For macOS/Linux:

```text
.../claude-api-demo/.venv/bin/python
```

This is an important verification step.

---

# 15. Why `sys.executable` Matters

Suppose your computer has:

```text
Python 3.13
Python 3.12
Python 3.11
```

You may accidentally install a package into one Python installation and execute your application with another.

Checking:

```python
import sys
print(sys.executable)
```

answers:

> "Which Python is actually running this application?"

This is one of the most useful Python troubleshooting techniques.

---

# 16. Upgrade Packaging Tools

After activating the environment:

```powershell
python -m pip install --upgrade pip
```

Using:

```text
python -m pip
```

is preferable to simply:

```text
pip
```

because it explicitly connects `pip` to the Python interpreter you are currently using.

---

# 17. Install the Anthropic Python SDK

Anthropic's official installation command is:

```powershell
pip install anthropic
```

The current Python SDK documentation confirms this installation method.

For maximum clarity inside an activated environment, you can also use:

```powershell
python -m pip install anthropic
```

---

# 18. Verify the Anthropic SDK

Run:

```powershell
python -c "import anthropic; print(anthropic.__version__)"
```

Expected:

```text
1.x.x
```

The exact version will change over time.

Do not hard-code an old SDK version in documentation unless the project intentionally requires it.

Anthropic's current SDK documentation also provides the runtime version check using:

```python
print(anthropic.__version__)
```

---

# 19. Why We Should Not Hard-Code the SDK Version

Avoid documentation such as:

```text
pip install anthropic==0.XX.X
```

unless the project specifically requires that version.

The Anthropic SDK evolves.

For a learning repository, the better default is:

```text
pip install anthropic
```

Then document the tested version when publishing a reproducible release.

---

# 20. Create `.gitignore`

Create:

```text
.gitignore
```

Recommended initial content:

```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class

# Virtual environment
.venv/
venv/
env/

# Environment variables / secrets
.env
.env.*
!.env.example

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db
```

This protects the project from accidentally committing local files and secrets.

---

# 21. Why `.venv/` Must Be Ignored

A virtual environment contains installed packages and machine-specific files.

Do not commit it.

Bad:

```text
git add .venv/
```

Good:

```text
.venv/
```

inside `.gitignore`.

A developer who clones the repository should recreate the environment from the project's dependency definition.

---

# 22. Create `.env.example`

Create:

```text
.env.example
```

with:

```env
ANTHROPIC_API_KEY=
```

This file documents the required environment variable without containing a real secret.

---

# 23. Create `.env`

Create:

```text
.env
```

with:

```env
ANTHROPIC_API_KEY=YOUR_API_KEY
```

Replace:

```text
YOUR_API_KEY
```

with your real key **only on your local machine**.

Do not commit `.env`.

Anthropic's Python SDK documentation specifically suggests using `python-dotenv` with a `.env` file so the API key is not stored in source control.

---

# 24. Install `python-dotenv`

Install:

```powershell
python -m pip install python-dotenv
```

This package loads variables from `.env` into the application's environment.

Architecture:

```text
.env
 │
 │ python-dotenv
 ▼
Environment Variables
 │
 ▼
ANTHROPIC_API_KEY
 │
 ▼
Anthropic SDK
```

---

# 25. Why Use `.env`?

Without `.env`:

```python
client = Anthropic(
    api_key="REAL_SECRET"
)
```

The secret lives in source code.

With `.env`:

```text
.env
    │
    └── ANTHROPIC_API_KEY
              │
              ▼
         Environment
              │
              ▼
        Python program
```

The application code does not contain the secret.

---

# 26. Load `.env` in Python

Create:

```text
main.py
```

Use:

```python
import os

from dotenv import load_dotenv

load_dotenv()

api_key = os.getenv("ANTHROPIC_API_KEY")

if api_key:
    print("ANTHROPIC_API_KEY is configured")
else:
    print("ANTHROPIC_API_KEY is NOT configured")
```

Notice that the code does **not print the secret**.

---

# 27. Better Secret Verification

Do not do:

```python
print(api_key)
```

Instead:

```python
if api_key:
    print("API key is configured")
else:
    print("API key is missing")
```

This is safer for:

* Terminal recordings
* CI/CD logs
* Screenshots
* Tutorials
* Debug logs

---

# 28. Anthropic SDK Environment Variable

The Anthropic SDK can automatically use:

```text
ANTHROPIC_API_KEY
```

So this is enough:

```python
from anthropic import Anthropic

client = Anthropic()
```

The SDK reads the API key from the environment.

Anthropic's current Python SDK documentation confirms this behavior.

---

# 29. Recommended `main.py`

For environment verification:

```python
from anthropic import Anthropic

client = Anthropic()

print("Anthropic client initialized successfully")
```

If `ANTHROPIC_API_KEY` is unavailable, the SDK will not have the required credential for API usage.

---

# 30. Do Not Mix Secret Loading Approaches Unnecessarily

You have several possibilities:

### Environment variable

```text
ANTHROPIC_API_KEY
```

### `.env`

```text
.env
    ↓
python-dotenv
    ↓
environment
```

### Secret manager

```text
Cloud Secret Manager
       ↓
Application
```

For local development:

```text
.env
```

is convenient.

For production:

```text
Secret Manager / Workload Identity
```

is generally more appropriate.

---

# 31. Project Structure

At this point, your project can look like:

```text
claude-api-demo/
│
├── .venv/
│
├── .env
├── .env.example
├── .gitignore
├── main.py
└── requirements.txt
```

Remember:

```text
.venv/  → local only
.env    → local secret only
```

---

# 32. Create `requirements.txt`

For a simple project:

```text
anthropic
python-dotenv
```

This records the project's direct dependencies.

---

# 33. Install from `requirements.txt`

Another developer can recreate the environment using:

```powershell
python -m pip install -r requirements.txt
```

This is useful for:

* Git repositories
* Team development
* CI/CD
* Reproducing environments

---

# 34. `requirements.txt` vs `pyproject.toml`

Python projects can manage dependencies in different ways.

### Simple learning project

```text
requirements.txt
```

### Modern Python application

```text
pyproject.toml
```

A mature project may eventually use:

```text
pyproject.toml
uv.lock
```

or another dependency-management system.

For this first Claude API project, keep the setup simple.

We will introduce `uv` later.

---

# 35. What Is `uv`?

`uv` is a fast Python package and project manager.

It can handle:

* Python environments
* Package installation
* Dependency management
* Lock files
* Project management

It is increasingly useful for modern Python development.

However:

> You do not need `uv` to use the Claude API.

The official Anthropic Python SDK works with normal Python environments and `pip`.

---

# 36. `pip` vs `uv`

| Feature                     | pip + venv  | uv        |
| --------------------------- | ----------- | --------- |
| Built into Python ecosystem | Yes         | No        |
| Simple                      | Yes         | Yes       |
| Package installation        | Yes         | Yes       |
| Virtual environments        | With `venv` | Yes       |
| Lockfile workflow           | Limited     | Strong    |
| Modern project management   | Basic       | Strong    |
| Good for learning           | Excellent   | Excellent |

For this repository:

```text
Beginner path
    ↓
venv + pip
```

Then:

```text
Modern Python path
    ↓
uv
```

---

# 37. Verify Everything

Run these commands.

### Python

```powershell
python --version
```

### Python location

```powershell
python -c "import sys; print(sys.executable)"
```

### pip

```powershell
python -m pip --version
```

### Anthropic SDK

```powershell
python -c "import anthropic; print(anthropic.__version__)"
```

### python-dotenv

```powershell
python -c "import dotenv; print('python-dotenv is installed')"
```

### Environment variable

```powershell
python -c "import os; print('ANTHROPIC_API_KEY is configured' if os.getenv('ANTHROPIC_API_KEY') else 'ANTHROPIC_API_KEY is NOT configured')"
```

---

# 38. Complete Environment Verification

You can also create:

```text
verify_environment.py
```

with:

```python
import os
import sys

import anthropic
from dotenv import load_dotenv


load_dotenv()

print("=== Claude Environment Verification ===")

print(f"Python: {sys.version.split()[0]}")
print(f"Python executable: {sys.executable}")
print(f"Anthropic SDK: {anthropic.__version__}")

if os.getenv("ANTHROPIC_API_KEY"):
    print("ANTHROPIC_API_KEY: configured")
else:
    print("ANTHROPIC_API_KEY: NOT configured")

print("Environment verification completed.")
```

Run:

```powershell
python verify_environment.py
```

---

# 39. Expected Verification

You should see something similar to:

```text
=== Claude Environment Verification ===
Python: 3.13.x
Python executable: C:\...\claude-api-demo\.venv\Scripts\python.exe
Anthropic SDK: 1.x.x
ANTHROPIC_API_KEY: configured
Environment verification completed.
```

The exact Python and SDK versions will vary.

---

# 40. Do Not Treat Environment Verification as API Verification

This is an important distinction.

If you see:

```text
ANTHROPIC_API_KEY: configured
```

that only means the application can read a value.

It does **not** prove:

* The key is valid
* The key is active
* The key has Workspace access
* Billing is available
* The API request will succeed

The definitive test comes from making an API request.

That will be covered in the next stage.

---

# 41. Common Problem — `ModuleNotFoundError`

Example:

```text
ModuleNotFoundError: No module named 'anthropic'
```

Likely causes:

```text
Wrong Python environment
       OR
Package not installed
```

Check:

```powershell
python -c "import sys; print(sys.executable)"
```

Then:

```powershell
python -m pip show anthropic
```

If it is missing:

```powershell
python -m pip install anthropic
```

---

# 42. Common Problem — Wrong Python

You may have:

```text
C:\Python313\python.exe
```

but your project is using:

```text
C:\Projects\claude-api-demo\.venv\Scripts\python.exe
```

Always verify:

```powershell
python -c "import sys; print(sys.executable)"
```

This single command solves many Python environment problems.

---

# 43. Common Problem — `.env` Not Loading

If:

```text
ANTHROPIC_API_KEY is NOT configured
```

check:

### 1. File name

It must be:

```text
.env
```

not:

```text
.env.txt
```

### 2. File location

For a simple project:

```text
claude-api-demo/
├── .env
└── main.py
```

### 3. Variable name

Correct:

```env
ANTHROPIC_API_KEY=...
```

Incorrect:

```env
ANTHROPIC_APIKEY=...
```

or:

```env
ANTHROPIC_KEY=...
```

### 4. `load_dotenv()`

Make sure:

```python
from dotenv import load_dotenv

load_dotenv()
```

runs before:

```python
os.getenv("ANTHROPIC_API_KEY")
```

---

# 44. Common Problem — `.env.txt`

Windows can hide file extensions.

You may think you created:

```text
.env
```

but actually have:

```text
.env.txt
```

Check using PowerShell:

```powershell
Get-ChildItem -Force
```

You should see:

```text
.env
```

not:

```text
.env.txt
```

---

# 45. Common Problem — API Key Printed Accidentally

If your terminal output contains something like:

```text
sk-ant-...
```

stop sharing the output.

If a real key was exposed:

```text
Disable/Delete key
        ↓
Create replacement
        ↓
Update environment
```

Do not assume that hiding the screenshot later makes the credential safe.

---

# 46. Common Problem — Git Accidentally Tracks `.env`

Check:

```powershell
git status
```

If `.env` appears as an untracked file, verify `.gitignore`.

You can also check whether Git is ignoring it:

```powershell
git check-ignore -v .env
```

A correct result should show the `.gitignore` rule responsible for ignoring `.env`.

---

# 47. Common Problem — `.venv` Appears in Git

Run:

```powershell
git status
```

If `.venv/` appears:

1. Check `.gitignore`
2. Make sure `.venv/` is present
3. If it was already tracked, ignoring it is not enough
4. Remove it from Git tracking without deleting your local environment:

```powershell
git rm -r --cached .venv
```

Then:

```powershell
git status
```

---

# 48. Clean Project Structure

A clean starting project:

```text
claude-api-demo/
│
├── .venv/                  # Local only
│
├── .env                    # Secret - never commit
├── .env.example            # Safe template
├── .gitignore              # Git exclusions
│
├── main.py                 # Application
├── verify_environment.py   # Environment checks
└── requirements.txt        # Dependencies
```

---

# 49. Recommended `.gitignore`

Use:

```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class

# Virtual environments
.venv/
venv/
env/

# Environment / secrets
.env
.env.*
!.env.example

# IDEs
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db
```

---

# 50. Recommended `.env.example`

Use:

```env
ANTHROPIC_API_KEY=
```

Do not put:

```text
sk-ant-...
```

inside this file.

---

# 51. Recommended `requirements.txt`

For this stage:

```text
anthropic
python-dotenv
```

Later, when the project grows, we can introduce:

```text
pyproject.toml
```

and lockfile-based dependency management.

---

# 52. Development Workflow

Your normal workflow should now look like:

```text
Open terminal
     ↓
Go to project
     ↓
Activate .venv
     ↓
Load environment
     ↓
Run application
     ↓
Test Claude API
     ↓
Deactivate environment
```

Windows:

```powershell
cd claude-api-demo
.\.venv\Scripts\Activate.ps1
python main.py
```

---

# 53. Deactivate

When finished:

```powershell
deactivate
```

The `(.venv)` prefix should disappear.

This does not delete the environment.

It only stops using it in the current terminal session.

---

# 54. Re-enter the Project Later

You do not need to recreate the environment every time.

Next day:

```powershell
cd claude-api-demo
.\.venv\Scripts\Activate.ps1
```

Then:

```powershell
python main.py
```

---

# 55. Recreate the Environment

If the environment becomes corrupted, delete:

```text
.venv/
```

and recreate:

```powershell
python -m venv .venv
```

Activate:

```powershell
.\.venv\Scripts\Activate.ps1
```

Install dependencies:

```powershell
python -m pip install -r requirements.txt
```

This demonstrates why dependency files are important.

---

# 56. Reproducibility

A repository should contain enough information for another developer to reproduce the environment.

Conceptually:

```text
Git Repository
│
├── requirements.txt
├── .env.example
├── .gitignore
└── source code
```

Developer clones:

```text
Repository
    ↓
Create .venv
    ↓
Install requirements
    ↓
Create .env
    ↓
Provide own API key
    ↓
Run application
```

The repository should never contain your secret.

---

# 57. Environment Variables in Production

`.env` is convenient for local development.

Production systems should generally use a dedicated secret-management mechanism.

Examples:

```text
AWS Secrets Manager
Google Secret Manager
Azure Key Vault
GitHub Actions Secrets
Kubernetes Secrets
Enterprise secret-management systems
```

For suitable production workloads, Workload Identity Federation can reduce the need for long-lived API keys.

---

# 58. Local Development vs Production

### Local

```text
.env
   ↓
python-dotenv
   ↓
ANTHROPIC_API_KEY
   ↓
Anthropic SDK
```

### Production

```text
Secret Manager
       ↓
Application
       ↓
Anthropic SDK
       ↓
Claude API
```

### Identity-based production

```text
Cloud Identity
       ↓
Workload Identity Federation
       ↓
Claude API
```

These are different deployment patterns.

---

# 59. Optional: `uv`

If `uv` is already installed, you can create a modern project with:

```powershell
uv init claude-api-demo
cd claude-api-demo
```

Then add the Anthropic SDK:

```powershell
uv add anthropic
```

And `python-dotenv`:

```powershell
uv add python-dotenv
```

The project will use modern Python project metadata and dependency management.

We will cover `uv` more deeply in a separate section rather than mixing both workflows together here.

---

# 60. Which Setup Should You Use?

For this repository's first Claude application:

```text
Python 3.10+
       ↓
venv
       ↓
pip
       ↓
anthropic
       ↓
python-dotenv
       ↓
.env
       ↓
Claude API
```

This path is intentionally simple.

Once the fundamentals are understood:

```text
venv + pip
      ↓
uv
      ↓
Modern Python project
```

---

# 61. Environment Security Rules

Always follow these rules:

### Rule 1

Never commit `.env`.

### Rule 2

Never commit API keys.

### Rule 3

Never print API keys.

### Rule 4

Never put secrets in README files.

### Rule 5

Never put secrets in screenshots.

### Rule 6

Never put secrets in GitHub Issues or Discussions.

### Rule 7

Use `.env.example` for documentation.

### Rule 8

Use secret managers in production.

### Rule 9

Rotate exposed credentials immediately.

### Rule 10

Use identity-based authentication where appropriate.

---

# 62. Final Environment Checklist

Before continuing:

### Python

* [ ] Python 3.10+ installed
* [ ] Python version verified
* [ ] Correct Python executable verified

### Virtual environment

* [ ] `.venv` created
* [ ] `.venv` activated
* [ ] `.venv` added to `.gitignore`

### SDK

* [ ] Anthropic SDK installed
* [ ] SDK version verified

### Environment

* [ ] `.env` created
* [ ] `.env.example` created
* [ ] `.env` ignored by Git
* [ ] `ANTHROPIC_API_KEY` configured

### Security

* [ ] Real API key is not in source code
* [ ] Real API key is not in Git
* [ ] API key is not printed
* [ ] `.env.example` contains no secret

### Dependencies

* [ ] `requirements.txt` created
* [ ] Dependencies can be installed from it

---

# 63. Final Project Structure

At the end of this stage:

```text
claude-api-demo/
│
├── .venv/
│
├── .env
├── .env.example
├── .gitignore
├── main.py
├── verify_environment.py
└── requirements.txt
```

The important security distinction is:

```text
Committed to Git
│
├── .env.example
├── .gitignore
├── main.py
├── verify_environment.py
└── requirements.txt

NOT committed
│
├── .env
└── .venv/
```

---

# 64. Architecture We Have Built

We now have:

```text
Claude Console
      │
      ▼
API Key
      │
      ▼
Local Environment
      │
      ├── Python
      ├── .venv
      ├── Anthropic SDK
      └── ANTHROPIC_API_KEY
      │
      ▼
Python Application
      │
      ▼
Claude API
```

The next step is to actually communicate with Claude.

---

# 65. Next Step

The environment is ready.

Next:

**`docs/06-python-sdk.md`**

We will learn:

* What an SDK is
* Why use the Anthropic SDK
* How the Python client works
* `Anthropic()`
* `client.messages.create()`
* Messages API
* `model`
* `max_tokens`
* `messages`
* User messages
* Assistant responses
* Response objects
* Text blocks
* Error handling
* Request IDs
* Basic logging
* Sync vs async clients
* A clean first Claude application

Then:

```text
07 — First API Request
08 — Messages API Deep Dive
09 — System Prompts
10 — Tokens & Context
11 — Streaming
12 — Tool Use
13 — Structured Outputs
14 — RAG
15 — Agents
```

> **Important:** Do not use a real API key in the examples committed to GitHub. The repository should contain placeholders and environment-variable based configuration only.
