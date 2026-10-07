# Anthropic Claude API

> A practical, beginner-friendly guide to building applications with the Anthropic Claude API.

This guide is part of the **[GenAI Setup Guide](../README.md)** repository.

It is designed to take you from:

```text
No Claude API knowledge
        ↓
Understand Claude
        ↓
Set up Claude Console
        ↓
Configure API access
        ↓
Create an API key
        ↓
Set up Python
        ↓
Make your first API request
        ↓
Understand the response
        ↓
Secure your application
        ↓
Monitor usage and cost
        ↓
Build real GenAI applications
```

---

## 🎯 Goal of This Guide

The goal is not simply to show you which buttons to click.

By the end of this guide, you should understand:

* **What** Claude is
* **What** the Claude API is
* **Why** an API is needed
* **What** Claude Console is
* **How** authentication works
* **What** an API key is
* **How** workspaces fit into the architecture
* **How** billing and usage work
* **How** to configure Python
* **How** to use the official Anthropic Python SDK
* **How** to make your first API request
* **How** to understand the request and response
* **How** to protect API credentials
* **How** to troubleshoot common problems
* **How** to move from a simple API call toward production applications

---

# 🧠 1. What Is Claude?

**Claude** is a family of large language models developed by **Anthropic**.

Claude models can work with tasks such as:

* Text generation
* Code generation
* Summarization
* Analysis
* Question answering
* Image understanding
* Tool use
* Agentic workflows

Anthropic's current model lineup includes models such as:

| Model             | General positioning                               |
| ----------------- | ------------------------------------------------- |
| Claude Fable 5.1  | Demanding reasoning and long-horizon agentic work |
| Claude Opus 5.5   | Complex projects, agents and coding               |
| Claude Sonnet 5.5 | Balance of speed and intelligence                 |
| Claude Haiku 4.5  | Fast, cost-efficient workloads                    |

Model availability, capabilities and pricing change over time, so always check Anthropic's current model documentation before selecting a model for a new project.

👉 **Official model documentation:**
https://platform.claude.com/docs/en/models/overview

---

# 🔌 2. What Is the Claude API?

The **Claude API** allows your software application to communicate with Claude programmatically.

Without an API:

```text
Human
  ↓
Claude Chat Interface
  ↓
Claude
  ↓
Human
```

With an API:

```text
Application
    ↓
Claude API
    ↓
Claude Model
    ↓
API Response
    ↓
Application
```

For example, your Python application can send:

```text
"Explain Kubernetes in simple words."
```

and receive Claude's generated response programmatically.

Anthropic's Claude API is a REST API available at:

```text
https://api.anthropic.com
```

The core Messages API endpoint is:

```text
POST /v1/messages
```

---

# 💬 3. Claude Chat vs Claude API

These are related, but they are **not the same thing**.

| Claude Chat                 | Claude API                               |
| --------------------------- | ---------------------------------------- |
| Human interacts with Claude | Application interacts with Claude        |
| Uses a graphical interface  | Uses HTTP/API requests                   |
| You type prompts manually   | Code sends prompts                       |
| Response appears in the UI  | Response is returned to your application |
| Useful for interactive use  | Useful for building software             |

Think of it this way:

```text
Claude Chat
    =
You use Claude


Claude API
    =
Your application uses Claude
```

A Claude subscription and Claude API usage are separate products. API access is managed through Claude Console and its associated billing/authentication mechanisms.

---

# 🖥️ 4. What Is Claude Console?

**Claude Console** is Anthropic's developer platform for working with Claude programmatically.

You use the Console for activities such as:

* API access
* API keys
* Workspaces
* Billing
* Usage
* Playground/development
* Organization administration

You can access the Console here:

https://console.anthropic.com/

Anthropic's developer documentation identifies the Console as the place to obtain API keys and manage API access.

---

# 🏗️ 5. How Claude API Fits Together

This is the most important architecture to understand before writing code.

```text
                         ANTHROPIC
                             │
                             ▼
                    ┌─────────────────┐
                    │ Claude Console  │
                    └────────┬────────┘
                             │
               ┌─────────────┼─────────────┐
               │             │             │
               ▼             ▼             ▼
           Workspace      API Key       Billing
               │             │             │
               └─────────────┼─────────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Your Application │
                    │                 │
                    │ Python          │
                    │ Node.js         │
                    │ Java            │
                    │ Go              │
                    │ etc.            │
                    └────────┬────────┘
                             │
                             │ HTTPS
                             ▼
                    ┌─────────────────┐
                    │    Claude API   │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │  Claude Model   │
                    └────────┬────────┘
                             │
                             ▼
                         Response
```

### The important idea

Your application does **not** directly "run Claude."

Instead:

```text
Your Application
       ↓
Authentication
       ↓
Claude API
       ↓
Claude Model
       ↓
Response
```

The API acts as the interface between your application and Anthropic's models.

---

# 🔐 6. How Authentication Works

Your application must authenticate before it can make normal direct Claude API requests.

Anthropic currently supports three authentication approaches:

1. **API keys**
2. **Workload Identity Federation**
3. **App Attest**

For someone learning Claude API and building local applications, **API keys are the simplest starting point**. For production workloads, Anthropic recommends considering identity-based approaches such as Workload Identity Federation where appropriate.

### Beginner path

```text
Developer
    ↓
Claude Console
    ↓
Create API Key
    ↓
Store Secret Securely
    ↓
Application
    ↓
Claude API
```

### Production-oriented path

```text
Cloud / CI/CD / Kubernetes
            ↓
Identity Provider
            ↓
Workload Identity Federation
            ↓
Short-lived Claude access token
            ↓
Claude API
```

We will start with API keys and introduce production authentication later.

---

# 🔑 7. What Is an API Key?

An **API key** is a secret credential that allows your application to authenticate with the Claude API.

Think of it like a password for your application.

```text
Username
   +
Password
```

is commonly used to authenticate a human.

Similarly:

```text
API Key
```

is used to authenticate an application.

### Important

An API key is sensitive.

Never publish it in:

* GitHub
* Documentation
* Screenshots
* Public chat messages
* Source code
* Frontend/browser code

Anthropic recommends keeping API keys out of source control and using secure secret storage.

---

# 🏢 8. What Is a Workspace?

A **Workspace** is a logical area within a Claude Console organization.

Workspaces help organizations separate API usage, access and projects.

For example:

```text
Organization
│
├── Default Workspace
│
├── GenAI Training
│
├── RAG Project
│
└── Production
```

For a beginner working on a personal project, you may only need the default or a single workspace.

For teams, separating workloads can make access and usage management easier.

Anthropic's current authentication model supports personal keys and service-account keys that can be scoped to a workspace. Legacy workspace keys still exist, but Anthropic recommends identity-backed keys for new integrations.

---

# 💳 9. How Billing Works

API usage is separate from normal Claude chat usage.

For most self-service Console organizations, Anthropic currently uses **prepaid usage credits**.

The basic flow is:

```text
Purchase Credits
       ↓
Credit Balance
       ↓
API Requests
       ↓
Usage
       ↓
Credits Consumed
```

If your organization uses prepaid billing and the available credits run out, API and Playground usage stops until additional credits are added.

Organizations with an invoicing arrangement may use monthly billing instead.

### Important

Pricing changes over time.

Therefore, this repository will **not hard-code pricing as permanent truth**.

Always check Anthropic's current pricing/model documentation before making production cost decisions.

---

# 🐍 10. Python Development

This guide uses Python for the first API example.

Anthropic provides an official Python SDK.

Install it with:

```powershell
pip install anthropic
```

The current SDK requires:

```text
Python 3.10+
```

Anthropic's current Python SDK supports synchronous and asynchronous clients, streaming and other API functionality.

---

# 🚀 11. First API Call

Once your account, billing and API authentication are ready, the basic Python flow is:

```text
Python Application
       ↓
Anthropic Python SDK
       ↓
Authentication
       ↓
Messages API
       ↓
Claude Model
       ↓
Response
```

The official SDK pattern is:

```python
import anthropic

client = anthropic.Anthropic()

message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=1024,
    messages=[
        {
            "role": "user",
            "content": "Hello, Claude",
        }
    ],
)

for block in message.content:
    if block.type == "text":
        print(block.text)
```

The SDK can automatically read the `ANTHROPIC_API_KEY` environment variable.

We will build this step-by-step in:

👉 [06 — First API Call](docs/06-first-api-call.md)

---

# 🧩 12. What Is the Messages API?

The **Messages API** is the primary API used to send messages to Claude and receive generated responses.

The endpoint is:

```text
POST /v1/messages
```

A basic request contains concepts such as:

```text
model
max_tokens
messages
```

Example:

```json
{
  "model": "YOUR_MODEL_ID",
  "max_tokens": 1024,
  "messages": [
    {
      "role": "user",
      "content": "Explain Docker in simple words."
    }
  ]
}
```

The API then returns a structured response containing generated content and metadata.

---

# 🛡️ 13. Security First

A working API call is not enough.

A professional implementation must also protect credentials.

### ❌ Never

```python
client = anthropic.Anthropic(
    api_key="YOUR_REAL_SECRET"
)
```

if that secret is committed to source control.

### ✅ Local development

Use an environment variable:

```text
ANTHROPIC_API_KEY=your-api-key
```

or a `.env` file that is excluded from Git.

### ✅ Production

Use an appropriate secret-management or identity solution.

Examples include:

```text
AWS Secrets Manager
Azure Key Vault
Google Secret Manager
GitHub Actions Secrets
Kubernetes Secrets
Workload Identity Federation
```

Anthropic recommends secret management, key rotation, expiration, and disabling/deleting keys that may have leaked.

---

# 📚 14. Learning Path

Follow these pages in order:

### Foundation

1. [Introduction](docs/01-introduction.md)
2. [Console Setup](docs/02-console-setup.md)

### Account and Access

3. [Billing](docs/03-billing.md)
4. [API Key](docs/04-api-key.md)

### Development

5. [Python Setup](docs/05-python-setup.md)
6. [First API Call](docs/06-first-api-call.md)

### Understanding

7. [Understanding the API](docs/07-understanding-api.md)

### Production Awareness

8. [Security](docs/08-security.md)
9. [Usage & Cost](docs/09-usage-and-cost.md)

### Problem Solving

10. [Troubleshooting](docs/10-troubleshooting.md)

---

# 🛠️ 15. What You Can Build After This

Once you understand the basic API, you can progress toward:

```text
Claude API
    │
    ├── Chat Applications
    │
    ├── Text Generation
    │
    ├── Document Analysis
    │
    ├── Vision Applications
    │
    ├── Structured Outputs
    │
    ├── Tool Use
    │
    ├── RAG
    │
    ├── AI Agents
    │
    ├── MCP
    │
    └── Production GenAI Applications
```

The direct Claude API also provides additional APIs and capabilities beyond the basic Messages API, including token counting, Files, Models and Message Batches.

---

# 🧭 16. What This Repository Will Cover

```text
Anthropic Claude
│
├── Fundamentals
│   ├── Claude
│   ├── Claude API
│   └── Claude Console
│
├── Account Setup
│   ├── Organization
│   ├── Workspace
│   └── Billing
│
├── Authentication
│   ├── API Keys
│   ├── Personal Keys
│   ├── Service Accounts
│   └── Production Authentication
│
├── Development
│   ├── Python
│   ├── SDK
│   ├── Messages API
│   └── Error Handling
│
├── Security
│   ├── Secrets
│   ├── Key Expiration
│   ├── Rotation
│   └── Production Identity
│
└── Advanced
    ├── Streaming
    ├── Tool Use
    ├── RAG
    ├── Agents
    ├── MCP
    └── Production
```

---

# ⚠️ 17. Keeping This Guide Current

AI platforms evolve quickly.

Model IDs, pricing, Console screens, SDK behavior and API capabilities can change.

Therefore:

> **Do not treat this repository as a frozen tutorial.**

When updating this documentation:

1. Check Anthropic's current official documentation.
2. Verify the API behavior.
3. Test the code.
4. Update the relevant Markdown page.
5. Update examples if required.
6. Record significant changes in `CHANGELOG.md`.

Prefer official Anthropic sources over third-party tutorials when documenting current API behavior.

---

# 📖 Official Documentation

### Claude Platform

https://platform.claude.com/docs/

### API Overview

https://platform.claude.com/docs/en/api/overview

### Get Started

https://platform.claude.com/docs/en/get-started

### Authentication

https://platform.claude.com/docs/en/manage-claude/authentication

### Python SDK

https://platform.claude.com/docs/en/cli-sdks-libraries/sdks/python

### Messages API

https://platform.claude.com/docs/en/api/messages/create

### Models

https://platform.claude.com/docs/en/models/overview

### Billing

https://support.claude.com/en/articles/8977456-how-do-i-pay-for-my-claude-api-usage

---

# 🤝 Community Contributions

Found something outdated or incorrect?

You can:

* Open an issue
* Suggest an improvement
* Submit a pull request
* Improve an explanation
* Add a tested example

Before contributing:

> **Verify first. Document second.**

See:

[CONTRIBUTING.md](CONTRIBUTING.md)

---

# ⭐ Support the Project

If this guide helps you learn Claude API or build a GenAI project:

* ⭐ Star the repository
* 🔗 Share it with your developer community
* 🛠️ Contribute improvements
* 📚 Keep learning

---

## Part of the GenAI Setup Guide

```text
GenAI Setup Guide
        │
        └── 05-Model-Providers
                │
                └── Anthropic-Claude
```

**Learn the concept → understand the architecture → configure it → test it → secure it → build with it.**
