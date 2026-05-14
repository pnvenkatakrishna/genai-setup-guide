# Gemini API Beginner Setup Guide (Windows + Python + uv)

## Introduction

This document is a beginner-friendly guide to:

- Understanding what the Gemini API is
- Understanding how Generative AI applications work
- Setting up Gemini API on Windows
- Installing Python and uv
- Creating a project using modern Python practices
- Running your first AI application
- Understanding common errors and fixes
- Learning best practices for AI engineering

This guide is written for absolute beginners.

---

# 1. What is Gemini API?

Gemini is a family of AI models developed by Google.

Using the Gemini API, developers can:

- Ask AI questions
- Generate text
- Build chatbots
- Create AI assistants
- Summarize documents
- Generate code
- Build Agentic AI systems
- Build MCP-based applications later

The API allows your application to communicate with Google’s AI models.

---

# 2. What is an API?

API stands for:

Application Programming Interface

An API allows one application to talk to another application.

Example:

Your Python Program → Gemini API → Gemini Model → AI Response

Flow:

```text
Your Application
       ↓
Gemini SDK
       ↓
Gemini API
       ↓
Google Gemini Model
       ↓
AI Response
```

---

# 3. What is an SDK?

SDK stands for:

Software Development Kit

Instead of manually calling APIs, SDKs provide ready-made functions.

In this guide we use:

```python
from google import genai
```

This SDK helps Python applications communicate with Gemini easily.

---

# 4. What is uv?

uv is a modern Python package manager.

Official Website:
https://docs.astral.sh/uv/

uv is:

- Fast
- Modern
- Lightweight
- Better dependency management
- Better virtual environment handling

Many modern engineering teams are moving toward uv.

---

# 5. Software Requirements

Install the following:

| Software | Purpose |
|---|---|
| Python 3.10+ | Programming Language |
| VS Code | Code Editor |
| uv | Package Manager |
| Gemini API Key | Access AI Models |

---

# 6. Install Python

Download Python:

https://www.python.org/downloads/

Important:

While installing Python:

✅ Check:

```text
Add Python to PATH
```

After installation verify:

Open PowerShell:

```powershell
python --version
```

Expected:

```text
Python 3.x.x
```

---

# 7. Install VS Code

Download:

https://code.visualstudio.com/

Recommended Extensions:

- Python
- Pylance
- Jupyter

---

# 8. Install uv

Open PowerShell:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Close terminal and reopen.

Verify:

```powershell
uv --version
```

Example:

```text
uv 0.x.x
```

---

# 9. Create Gemini API Key

Open:

https://aistudio.google.com/app/apikey

Steps:

1. Login with Google account
2. Click "Create API Key"
3. Copy the generated key

Example:

```text
AIzaSyXXXXXXX
```

Important:

Never share your API key publicly.

---

# 10. Create Project Folder

Open PowerShell:

```powershell
mkdir Gemini-Learning
cd Gemini-Learning
```

---

# 11. Initialize Project Using uv

Run:

```powershell
uv init
```

This creates:

```text
README.md
pyproject.toml
main.py
```

---

# 12. Create Virtual Environment

Run:

```powershell
uv venv
```

This creates:

```text
.venv
```

---

# 13. Activate Virtual Environment

PowerShell:

```powershell
.venv\Scripts\Activate.ps1
```

If PowerShell blocks execution:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Then activate again.

Expected:

```text
(gemini-learning)
```

---

# 14. Install Required Packages

Install Gemini SDK:

```powershell
uv add google-genai
```

Install dotenv:

```powershell
uv add python-dotenv
```

---

# 15. Verify Installed Packages

Run:

```powershell
uv pip list
```

You should see:

```text
google-genai
python-dotenv
```

---

# 16. Create .env File

Inside project folder create:

```text
.env
```

Add:

```env
GEMINI_API_KEY=YOUR_API_KEY
```

Example:

```env
GEMINI_API_KEY=AIzaSyXXXXXX
```

Important:

- No spaces
- No quotes
- File name must be exactly `.env`

---

# 17. Create main.py

Open:

```powershell
notepad main.py
```

Replace content with:

```python
from google import genai
from dotenv import load_dotenv
import os

# Load .env file
load_dotenv()

# Read API Key
api_key = os.getenv("GEMINI_API_KEY")

# Create Gemini Client
client = genai.Client(api_key=api_key)

# Generate AI Response
response = client.models.generate_content(
    model="gemini-3.1-flash-lite",
    contents="What is the capital of India?"
)

# Print Response
print("\nAI RESPONSE:\n")
print(response.text)
```

---

# 18. Run the Application

Run:

```powershell
uv run main.py
```

Expected Output:

```text
AI RESPONSE:

The capital of India is New Delhi.
```

---

# 19. Understanding the Code

## Import SDK

```python
from google import genai
```

Imports the Gemini SDK.

---

## Load Environment Variables

```python
load_dotenv()
```

Reads values from the `.env` file.

---

## Read API Key

```python
api_key = os.getenv("GEMINI_API_KEY")
```

Gets the API key from environment variables.

---

## Create Client

```python
client = genai.Client(api_key=api_key)
```

Creates a Gemini API client.

---

## Generate Response

```python
response = client.models.generate_content()
```

Sends prompt to Gemini model.

---

## Print Response

```python
print(response.text)
```

Displays AI response.

---

# 20. Common Beginner Errors

## Error 1: ModuleNotFoundError

Example:

```text
No module named 'google.generativeai'
```

Reason:

Old SDK used.

Fix:

Use:

```powershell
uv add google-genai
```

---

## Error 2: API Key Not Found

Reason:

- Wrong `.env` file
- Wrong variable name

Correct:

```env
GEMINI_API_KEY=YOUR_KEY
```

---

## Error 3: Quota Exceeded

Example:

```text
429 RESOURCE_EXHAUSTED
```

Reason:

- Free quota exceeded
- Billing not enabled
- New project limits

Fix:

- Create new API key
- Create new project
- Enable billing if needed

---

## Error 4: Wrong Model Name

Always verify model names in:

https://aistudio.google.com/

Example:

```python
model="gemini-3.1-flash-lite"
```

---

# 21. Best Practices

## Never Hardcode API Keys

BAD:

```python
api_key="AIza..."
```

GOOD:

```python
os.getenv("GEMINI_API_KEY")
```

---

## Use .gitignore

Create:

```text
.gitignore
```

Add:

```text
.env
.venv
```

This prevents secret leakage.

---

## Use Virtual Environments

Virtual environments isolate project dependencies.

Important for:

- DevOps
- AI engineering
- Production systems

---

# 22. Practice Prompts

Try changing:

```python
contents="Explain Docker in simple words"
```

Examples:

```python
contents="Explain Kubernetes like a teacher"
```

```python
contents="Create Terraform for AWS EC2"
```

```python
contents="Write Bash script for disk monitoring"
```

```python
contents="Ask me Jenkins interview questions"
```

---

# 23. What You Learned

By completing this setup you learned:

| Skill | Purpose |
|---|---|
| Python | Programming |
| uv | Package Management |
| Virtual Environment | Isolation |
| dotenv | Secret Management |
| Gemini API | AI Integration |
| SDK | API Communication |
| Environment Variables | Security |

---

# 24. What to Learn Next

Recommended learning order:

1. Prompt Engineering
2. Chat History
3. Streaming Responses
4. Function Calling
5. RAG
6. Vector Databases
7. Agentic AI
8. MCP
9. LangChain
10. FastAPI

---

# 25. Recommended Resources

## Gemini API Documentation

https://ai.google.dev/gemini-api/docs

---

## Google AI Studio

https://aistudio.google.com/

---

## uv Documentation

https://docs.astral.sh/uv/

---

## VS Code

https://code.visualstudio.com/

---

# 26. Final Summary

You successfully built your first Generative AI application using:

- Python
- uv
- Gemini API
- Environment variables
- Modern SDKs

This is the foundation for building:

- AI chatbots
- AI agents
- MCP systems
- RAG applications
- DevOps AI assistants
- AI automation platforms

You are now learning real AI engineering workflows.

