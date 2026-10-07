# Claude API Keys & Authentication

> Learn how Claude API authentication works, which API key type to use, how to create and scope a key, how to store it securely, and how to verify your setup.

---

## 1. Goal

This guide explains how applications authenticate with the Claude API.

By the end of this guide, you should understand:

* What an API key is
* How Claude API authentication works
* The current authentication methods
* Personal API keys
* Service account API keys
* Legacy workspace API keys
* Workspace-scoped vs multi-workspace keys
* API key expiration
* Creating an API key
* Naming keys correctly
* Storing keys securely
* Environment variables
* Windows PowerShell
* Git Bash
* macOS/Linux
* API-key verification
* Key rotation
* Key disabling and deletion
* What to do if a key is exposed
* Why API keys should never be committed to GitHub
* When to move from API keys to Workload Identity Federation

---

# 2. What Is an API Key?

An API key is a secret credential that allows an application to authenticate with the Claude API.

Think of it as:

```text
Your Application
       │
       │ API Key
       ▼
Claude API
       │
       ▼
Authentication
       │
       ▼
Claude Model
```

The API key tells Anthropic:

> "This request is coming from an authenticated identity that has permission to use the Claude API."

---

# 3. API Key ≠ Password

An API key is not the same thing as your Claude Console password.

### Console password

Used to sign in to the Claude Console.

```text
Browser
   ↓
Claude Console
   ↓
Account authentication
```

### API key

Used by software to authenticate API requests.

```text
Application
   ↓
API key
   ↓
Claude API
```

Therefore:

```text
Console password
       ≠
API key
```

Never use your Console password inside application code.

---

# 4. Current Claude Authentication Methods

Anthropic currently documents three authentication approaches:

| Method                       | Typical use                                                 |
| ---------------------------- | ----------------------------------------------------------- |
| API key                      | Local development, prototypes, scripts, servers             |
| Workload Identity Federation | Production workloads, CI/CD, Kubernetes, cloud environments |
| App Attest                   | Distributed iOS/macOS applications calling Claude directly  |

For this beginner-to-developer repository, we will start with:

```text
API Key
```

Then later cover Workload Identity Federation for production environments.

Anthropic currently recommends API keys for getting started quickly, while Workload Identity Federation is appropriate when you already have a platform-issued identity you can federate. ([Authentication](https://platform.claude.com/docs/en/manage-claude/authentication))

---

# 5. How API Authentication Works

A normal Claude API request contains an authentication credential.

Conceptually:

```text
Application
     │
     │ HTTPS request
     │
     ├── Authorization: Bearer <API_KEY>
     │
     ├── anthropic-version
     │
     └── JSON request body
     │
     ▼
Claude API
```

The current API documentation uses the `Authorization: Bearer <token>` header for API-key authentication.

The older:

```text
x-api-key
```

header remains supported as a legacy fallback, but new documentation should prefer the `Authorization` header. ([API overview](https://platform.claude.com/docs/en/api/overview))

---

# 6. Never Put the API Key in the Request Body

Do **not** do this:

```json
{
  "api_key": "sk-ant-...",
  "model": "...",
  "messages": []
}
```

Authentication belongs in the HTTP headers.

Conceptually:

```text
HTTP Headers
├── Authorization
├── anthropic-version
└── content-type

Request Body
├── model
├── max_tokens
└── messages
```

Keeping authentication separate from application data is an important API design principle.

---

# 7. Current API Key Types

Anthropic currently documents these API-key types:

1. **Personal key**
2. **Service account key**
3. **Workspace key — legacy**

For new integrations, identity-backed personal and service-account keys are preferred over legacy workspace keys. ([Authentication](https://platform.claude.com/docs/en/manage-claude/authentication))

---

# 8. Personal API Key

A personal API key acts as **you**.

Conceptually:

```text
You
 │
 └── Personal API Key
          │
          ▼
       Claude API
```

The request inherits the permissions of your user identity.

### Best use

Use a personal key for:

* Personal development
* Local experiments
* Learning
* Individual scripts
* Your own development environment

Example:

```text
Venkat
  │
  └── Personal API Key
          │
          └── Local Claude project
```

---

# 9. Important Limitation of Personal Keys

A personal key represents a person.

Therefore, do not treat your personal key as a permanent shared production credential.

For example:

```text
Developer A
     │
     └── Personal Key
             │
             ▼
       Production Server
```

If Developer A leaves the organization, the identity-backed key will no longer be usable.

This is exactly why shared applications should have their own identity.

---

# 10. Service Account API Key

A service account represents an application or workload rather than a human developer.

Conceptually:

```text
Application
     │
     └── Service Account
             │
             └── API Key
                    │
                    ▼
                Claude API
```

This is the preferred key model for shared or unattended workloads when using static API keys.

### Typical use cases

* Production backend
* CI/CD
* Automation
* Shared development services
* Scheduled jobs
* Server applications

---

# 11. Personal Key vs Service Account Key

| Characteristic        | Personal Key         | Service Account Key           |
| --------------------- | -------------------- | ----------------------------- |
| Represents            | Human user           | Application/workload identity |
| Best for              | Personal development | Shared/automated workloads    |
| Shared production use | Not recommended      | Appropriate                   |
| Tied to user          | Yes                  | No                            |
| Good for CI/CD        | Usually not          | Yes                           |
| Good for learning     | Yes                  | Usually unnecessary           |

Simple rule:

```text
My laptop
    ↓
Personal key

Shared application
    ↓
Service account key
```

---

# 12. Legacy Workspace API Keys

Anthropic still supports workspace API keys, but they are now considered **legacy**.

A legacy workspace key:

```text
Workspace
    │
    └── Workspace API Key
```

does not represent a person or service account.

Anthropic recommends identity-backed personal/service-account keys or Workload Identity Federation for new integrations. ([Authentication](https://platform.claude.com/docs/en/manage-claude/authentication))

Therefore, this repository will **teach workspace keys for understanding and migration**, but we will not use them as the default for new projects.

---

# 13. Workspace Scope

An API key can be scoped to a particular Workspace.

For example:

```text
Organization
│
├── Development
│
├── Testing
│
└── Production
```

A key scoped to Development can be restricted to:

```text
Development
    │
    └── API Key
```

This is useful because it limits where the key can operate.

---

# 14. Single-Workspace Key

A single-workspace key is restricted to one Workspace.

Example:

```text
Organization
│
├── Development
│     └── Key A ✓
│
├── Testing
│     └── Key A ✗
│
└── Production
      └── Key A ✗
```

This provides a useful security boundary.

For example:

```text
Development Key
       ↓
Development Workspace only
```

---

# 15. Multi-Workspace Key

A personal or service-account key can also be created without restricting it to one Workspace.

When such a key is used, the request can specify the target Workspace using:

```text
anthropic-workspace-id
```

Example:

```text
Application
     │
     ├── API Key
     │
     └── anthropic-workspace-id
                │
                ▼
          Target Workspace
```

Anthropic requires the Workspace ID header when a multi-workspace identity-linked API key is used. ([Authentication](https://platform.claude.com/docs/en/manage-claude/authentication))

---

# 16. Workspace ID

Workspace IDs use the format:

```text
wrkspc_...
```

Example:

```text
wrkspc_01...
```

Do not confuse:

```text
Organization ID
       ≠
Workspace ID
       ≠
API Key
```

These represent different resources.

---

# 17. How to Find a Workspace ID

The Claude Console provides Workspace information under:

```text
Settings
   ↓
Workspaces
```

The Workspace ID is shown in the Workspace information.

Anthropic also provides an API for listing Workspaces.

For most beginner applications, you do not need to manually manage Workspace IDs if you create a key specifically for one Workspace.

---

# 18. Recommended Setup for This Repository

For our learning project, use:

```text
Claude Console
      │
      ▼
Your Organization
      │
      ▼
Your Workspace
      │
      ▼
Personal API Key
      │
      ▼
Local Development
      │
      ▼
Claude API
```

Why?

Because you are learning and building locally.

A service account becomes more appropriate when we build:

```text
Production
CI/CD
Shared applications
Automation
Team infrastructure
```

---

# 19. Before Creating the Key

Make sure you have completed:

```text
01 Introduction
        ↓
02 Console Setup
        ↓
03 Billing
        ↓
04 API Key
```

Before creating the key, verify:

* [ ] Claude Console works
* [ ] Correct organization selected
* [ ] Correct Workspace selected
* [ ] Billing is configured
* [ ] You understand API usage costs
* [ ] You know where the API key will be stored

---

# 20. Where to Create an API Key

Open:

```text
Claude Console
     ↓
Settings
     ↓
API keys
```

Anthropic's current documentation explicitly directs users to:

**Settings → API keys**

for viewing and creating their own API keys. ([API Keys](https://platform.claude.com/docs/en/api/http/beta/organization/api_keys))

---

# 21. Creating Your First Personal API Key

The current Console flow is conceptually:

```text
Settings
   ↓
API keys
   ↓
Create key
   ↓
Choose key type
   ↓
Choose identity
   ↓
Choose Workspace scope
   ↓
Choose expiration
   ↓
Create
```

For your own local development:

```text
Key type
   ↓
Personal

Linked account
   ↓
Your account

Workspace
   ↓
Your development Workspace

Expiration
   ↓
Choose according to your development/security needs
```

The Console UI can change, so always follow the labels displayed in the current Console.

---

# 22. Key Naming

Do not create keys with meaningless names such as:

```text
test
key1
claude
mykey
abc
```

Use names that explain their purpose.

Good examples:

```text
genai-setup-guide-local
claude-learning-windows
genai-dev-local
claude-rag-development
```

A useful naming pattern is:

```text
<project>-<environment>-<purpose>
```

Example:

```text
genai-setup-guide-local-development
```

---

# 23. Why Key Naming Matters

Imagine you eventually have:

```text
genai-setup-guide-local
genai-rag-dev
genai-rag-prod
agent-service-prod
ci-github-actions
```

You can immediately understand what each credential is for.

Good names improve:

* Security
* Auditing
* Troubleshooting
* Rotation
* Team administration

Anthropic also recommends meaningful names for API keys. ([Admin API](https://platform.claude.com/docs/en/manage-claude/admin-api))

---

# 24. API Key Expiration

Current Claude API key creation supports expiration options.

Depending on your organization's policy, the Console can offer options such as:

* 3 hours
* 1 day
* 7 days
* 30 days
* Custom duration
* Never

An organization may impose a maximum expiration policy, which can restrict available choices.

Expiration is configured when the key is created and cannot be changed afterward. ([Authentication](https://platform.claude.com/docs/en/manage-claude/authentication))

---

# 25. Why Expiration Matters

Suppose an API key is accidentally leaked:

```text
API Key leaked
      │
      ▼
Attacker obtains key
      │
      ▼
Key remains valid
```

If the key has an expiration:

```text
API Key leaked
      │
      ▼
Expiration reached
      │
      ▼
Key stops working
```

Expiration therefore limits the lifetime of an accidentally exposed credential.

However:

> Expiration is not a replacement for secure secret management.

---

# 26. Should Development Keys Expire?

For learning projects, short-lived keys can be useful.

For example:

```text
Temporary experiment
        ↓
Short-lived key
        ↓
Experiment complete
        ↓
Key expires
```

For a long-running local development environment, a longer lifetime may be more convenient.

For production, use proper secret management and credential rotation rather than relying only on a long-lived API key.

---

# 27. What Happens When a Key Expires?

An expired API key cannot be reactivated.

Requests using it return an authentication error.

You must create a new key.

Conceptually:

```text
Expired Key
     ↓
401 authentication_error
     ↓
Create new key
     ↓
Update secret
     ↓
Application works again
```

Anthropic documents `401 authentication_error` for requests made with expired keys. ([Authentication](https://platform.claude.com/docs/en/manage-claude/authentication))

---

# 28. API Key Storage

This is one of the most important sections in the entire repository.

Never hard-code your API key into source code.

### Bad

```python
client = Anthropic(
    api_key="sk-ant-api03-REAL_SECRET_HERE"
)
```

Do not commit this to Git.

---

# 29. Correct Local Development Pattern

Use an environment variable.

```text
Operating System
       │
       └── ANTHROPIC_API_KEY
                │
                ▼
          Python process
                │
                ▼
          Anthropic SDK
                │
                ▼
           Claude API
```

Anthropic's SDKs can automatically read:

```text
ANTHROPIC_API_KEY
```

from the environment. ([Authentication](https://platform.claude.com/docs/en/manage-claude/authentication))

---

# 30. Windows PowerShell

For a temporary environment variable in the current PowerShell session:

```powershell
$env:ANTHROPIC_API_KEY="YOUR_API_KEY"
```

Verify that the variable exists without printing the actual secret:

```powershell
if ($env:ANTHROPIC_API_KEY) {
    Write-Host "ANTHROPIC_API_KEY is set"
} else {
    Write-Host "ANTHROPIC_API_KEY is NOT set"
}
```

### Important

Do **not** run:

```powershell
echo $env:ANTHROPIC_API_KEY
```

while recording a tutorial or screen-sharing.

That prints the secret.

---

# 31. Windows Persistent Environment Variable

For persistent local development, Windows environment variables can be configured through Windows settings or PowerShell.

However, do not blindly add secrets to shell profiles that might later be committed, synchronized, or shared.

For this repository, we will eventually use a safer project-level development pattern with a local `.env` file and `.gitignore`.

---

# 32. Git Bash

In Git Bash:

```bash
export ANTHROPIC_API_KEY="YOUR_API_KEY"
```

Verify safely:

```bash
if [ -n "$ANTHROPIC_API_KEY" ]; then
  echo "ANTHROPIC_API_KEY is set"
else
  echo "ANTHROPIC_API_KEY is NOT set"
fi
```

Do not print the secret itself.

---

# 33. macOS/Linux

In Bash or Zsh:

```bash
export ANTHROPIC_API_KEY="YOUR_API_KEY"
```

Verify:

```bash
if [ -n "$ANTHROPIC_API_KEY" ]; then
  echo "ANTHROPIC_API_KEY is set"
else
  echo "ANTHROPIC_API_KEY is NOT set"
fi
```

---

# 34. `.env` Files

For local application development, a `.env` file is commonly used.

Example:

```text
ANTHROPIC_API_KEY=YOUR_API_KEY
```

However:

> A `.env` file containing a real API key must never be committed to Git.

---

# 35. `.gitignore`

Your project should contain:

```gitignore
.env
.env.*
!.env.example
```

This allows you to keep:

```text
.env
```

private while committing:

```text
.env.example
```

as documentation.

---

# 36. `.env.example`

Create:

```text
.env.example
```

with:

```text
ANTHROPIC_API_KEY=
```

This file contains no real secret.

A developer can then create:

```text
.env
```

locally.

Architecture:

```text
Project
│
├── .env              ← Secret, NOT committed
├── .env.example      ← Template, committed
└── .gitignore
```

---

# 37. Never Put API Keys in README Files

Bad:

````markdown
## API Key

```text
sk-ant-api03-real-secret
````

````

Even if the repository is private today, it may become public later.

Documentation should always use placeholders:

```text
YOUR_API_KEY
````

or:

```text
sk-ant-...
```

---

# 38. Never Put API Keys in Git History

This is important.

Deleting a secret from the latest commit does not necessarily remove it from Git history.

Example:

```text
Commit 1
   ↓
API key committed ❌

Commit 2
   ↓
API key deleted

Commit 3
   ↓
Repository looks clean
```

The secret may still exist in:

```text
Git history
```

Therefore, if a real key is committed:

```text
1. Disable/delete the exposed key immediately
2. Create a replacement key
3. Remove the secret from repository history if necessary
4. Check other copies/logs
```

Do not simply delete the line and assume the credential is safe.

---

# 39. What If Your API Key Is Exposed?

Treat it as compromised.

Do not wait to see whether someone uses it.

Recommended response:

```text
API key exposed
      ↓
Disable/delete key
      ↓
Create replacement key
      ↓
Update application secret
      ↓
Check usage
      ↓
Investigate exposure
```

Anthropic recommends disabling or deleting keys suspected of being leaked. ([Authentication](https://platform.claude.com/docs/en/manage-claude/authentication))

---

# 40. Disable vs Delete

Anthropic distinguishes between disabling and deleting a key.

### Disable

Temporarily makes the key inactive.

```text
Active
  ↓
Disabled
```

This is reversible.

### Delete

Permanently archives the key.

```text
Active
  ↓
Deleted / Archived
```

Deletion is not the same as temporary disabling.

The Console/API key management documentation states that disabling is reversible, while deletion archives the key permanently. ([Authentication](https://platform.claude.com/docs/en/manage-claude/authentication))

---

# 41. API Key Rotation

Rotation means replacing an existing credential with a new one.

Example:

```text
Old Key
   │
   ▼
Create New Key
   │
   ▼
Update Application
   │
   ▼
Verify Application
   │
   ▼
Disable/Delete Old Key
```

Do not immediately delete the old production key before confirming that the new key works.

---

# 42. Safe Rotation Procedure

Use:

```text
1. Create new key
        ↓
2. Store new key securely
        ↓
3. Update application
        ↓
4. Deploy
        ↓
5. Verify API requests
        ↓
6. Monitor
        ↓
7. Disable old key
        ↓
8. Delete old key when appropriate
```

This minimizes downtime.

---

# 43. API Key and GitHub

Never put a real Claude API key into:

```text
README.md
.py files
.ipynb files
JSON files
YAML files
GitHub Actions YAML
Dockerfiles
Docker Compose files
Terraform files
shell scripts
PowerShell scripts
Git history
GitHub Issues
GitHub Discussions
Screenshots
```

Use GitHub's secret-management facilities for CI/CD workflows instead.

---

# 44. Local vs CI/CD vs Production

Different environments require different approaches.

| Environment                | Recommended authentication                               |
| -------------------------- | -------------------------------------------------------- |
| Personal local development | Personal API key                                         |
| Shared development         | Service account key or appropriate identity-backed setup |
| CI/CD                      | Service account or Workload Identity Federation          |
| Production cloud workload  | Workload Identity Federation where supported             |
| Distributed iOS/macOS app  | App Attest where applicable                              |

Anthropic currently recommends Workload Identity Federation for production workloads where a platform-issued identity is available. ([Authentication](https://platform.claude.com/docs/en/manage-claude/authentication))

---

# 45. Why Workload Identity Federation Exists

Traditional API key:

```text
Application
    │
    └── Long-lived secret
            │
            ▼
        Claude API
```

Workload Identity Federation:

```text
Cloud / CI / Kubernetes
          │
          ▼
Platform Identity
          │
          ▼
Short-lived credential
          │
          ▼
Claude API
```

The advantage is reducing dependence on long-lived static secrets.

This becomes particularly valuable for:

* AWS
* Google Cloud
* Azure
* Kubernetes
* CI/CD

We will cover this later in the repository.

---

# 46. Python SDK Authentication

The Anthropic Python SDK can automatically use:

```text
ANTHROPIC_API_KEY
```

from the environment.

Example:

```python
from anthropic import Anthropic

client = Anthropic()
```

The SDK reads the environment variable.

This is preferable to putting the key directly in the Python source code.

---

# 47. Explicit API Key in Python

The SDK also supports explicitly passing the key:

```python
from anthropic import Anthropic

client = Anthropic(
    api_key="YOUR_API_KEY"
)
```

This can be useful for understanding how authentication works, but do not replace `YOUR_API_KEY` with a real secret inside source code that will be committed to Git.

For normal local development:

```python
from anthropic import Anthropic

client = Anthropic()
```

with:

```text
ANTHROPIC_API_KEY
```

configured in the environment is the safer pattern.

---

# 48. API Key Verification

Do not verify a key by printing it.

Bad:

```text
print(API_KEY)
```

Good:

```text
API_KEY exists
        ↓
SDK initializes
        ↓
API request succeeds
```

A real API request will be our definitive authentication test in the next stage.

---

# 49. Authentication Errors

Authentication problems are different from billing problems.

For example:

```text
401
authentication_error
```

generally indicates an authentication problem.

Possible causes:

* Invalid API key
* Expired API key
* Disabled API key
* Deleted API key
* Incorrect environment variable
* Wrong credential
* Secret not loaded by the application

---

# 50. Authentication Troubleshooting

Use this order:

```text
1. Is ANTHROPIC_API_KEY set?
          ↓
2. Is it the correct key?
          ↓
3. Is the key active?
          ↓
4. Has it expired?
          ↓
5. Does the identity have Workspace access?
          ↓
6. Is the Workspace configuration correct?
          ↓
7. Does the application actually load the variable?
```

Do not immediately create five new keys.

First identify the actual failure.

---

# 51. Workspace Authentication Errors

If you use a personal or service-account key that is not restricted to one Workspace, the request may need:

```text
anthropic-workspace-id
```

If the required Workspace ID is missing, the API can return a `400 invalid_request_error`.

If the Workspace ID is invalid or inaccessible, the API can return an appropriate error such as `400` or `404`. ([Authentication](https://platform.claude.com/docs/en/manage-claude/authentication))

For beginners, a single-workspace key can simplify this configuration.

---

# 52. Security Checklist

Before using your API key:

### Secret handling

* [ ] API key is not inside source code
* [ ] API key is not inside README
* [ ] API key is not inside Git history
* [ ] `.env` is ignored
* [ ] `.env.example` contains no secret
* [ ] API key is not printed in logs

### Console

* [ ] Correct organization
* [ ] Correct Workspace
* [ ] Correct key type
* [ ] Appropriate expiration
* [ ] Appropriate Workspace scope

### Application

* [ ] `ANTHROPIC_API_KEY` is configured
* [ ] SDK can read the environment variable
* [ ] Authentication will be tested with a real request

---

# 53. Recommended Naming Convention

For this repository:

```text
genai-setup-guide-local
```

is a good example for a local learning key.

Other examples:

```text
genai-setup-guide-dev
genai-rag-local
claude-agent-dev
claude-mcp-learning
```

Use:

```text
<project>-<environment>-<purpose>
```

---

# 54. Complete Authentication Mental Model

Keep this architecture in mind:

```text
                         Organization
                              │
              ┌───────────────┴───────────────┐
              │                               │
          Workspace                       Billing
              │                               │
              │                         Usage / Cost
              │
       Identity-backed key
              │
       ┌──────┴──────┐
       │             │
    Personal      Service Account
       │             │
       └──────┬──────┘
              │
              ▼
        Your Application
              │
              │ HTTPS
              ▼
         Claude API
              │
              ▼
       Authentication
              │
              ▼
        Claude Model
```

---

# 55. What We Are Using in This Repository

For the initial Python examples:

```text
Authentication
      ↓
Personal API Key
      ↓
Environment Variable
      ↓
ANTHROPIC_API_KEY
      ↓
Anthropic Python SDK
      ↓
Claude API
```

Later we will introduce:

```text
Service Accounts
Workload Identity Federation
CI/CD secrets
Cloud identity
Production secret management
```

---

# 56. What NOT to Do

Never do this:

```python
API_KEY = "sk-ant-api03-xxxxxxxxxxxxxxxx"
```

Never do this:

```bash
git add .
git commit -m "add api key"
git push
```

Never do this:

```text
Send your API key to a trainer/friend
```

Never do this:

```text
Upload screenshot containing API key
```

Never do this:

```text
Put API key in public documentation
```

Never do this:

```text
Reuse one personal key across unrelated production systems
```

---

# 57. Knowledge Check

Before continuing, you should be able to answer these questions:

### Q1. What does an API key do?

It authenticates an application request to the Claude API.

### Q2. Is an API key the same as your Claude Console password?

No.

### Q3. Which key should I use for my own local development?

A personal API key.

### Q4. Which key is appropriate for a shared unattended application?

A service account key is the identity-backed option for shared workloads.

### Q5. Are legacy workspace keys the preferred choice for new integrations?

No. Anthropic currently recommends identity-backed keys or Workload Identity Federation.

### Q6. Where do I create an API key?

```text
Claude Console
→ Settings
→ API keys
```

### Q7. Where should the secret be stored locally?

Use secure environment/secret storage rather than source code.

### Q8. What environment variable does the Anthropic SDK use?

```text
ANTHROPIC_API_KEY
```

### Q9. What should I do if a key is exposed?

Disable/delete it and create a replacement.

### Q10. Is key expiration a replacement for secret management?

No.

---

# 58. Verification Checklist

Before moving to the next document:

* [ ] I understand API-key authentication.
* [ ] I understand personal keys.
* [ ] I understand service-account keys.
* [ ] I understand legacy workspace keys.
* [ ] I understand Workspace scoping.
* [ ] I know where to create an API key.
* [ ] I know how to name a key.
* [ ] I understand expiration.
* [ ] I understand key rotation.
* [ ] I know how to configure `ANTHROPIC_API_KEY`.
* [ ] I understand why `.env` must not be committed.
* [ ] I understand what to do if a key is leaked.
* [ ] I understand the difference between authentication and billing.

---

# 59. Next Step

Authentication is now understood.

The next layer is the **local development environment**.

The sequence becomes:

```text
01 Introduction
      ↓
02 Console Setup
      ↓
03 Billing
      ↓
04 API Key
      ↓
05 Environment Setup
      ↓
06 Python SDK
      ↓
07 First API Request
```

Next document:

**`docs/05-environment-setup.md`**

There we will build the actual local development environment:

* Windows
* PowerShell
* Python
* Virtual environment
* `uv`
* `pip`
* Project structure
* `.env`
* `.gitignore`
* Anthropic SDK
* Dependency management
* Verification
* Common Windows problems
* Reproducible setup

> **Security rule:** Never put your real Claude API key in this repository. Use `ANTHROPIC_API_KEY` through secure local secret handling.
