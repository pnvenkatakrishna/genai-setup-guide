# 02 — Claude Console Setup

> Create and understand your Claude Console environment before creating an API key or writing application code.

---

## 🎯 Goal

By the end of this guide, you should understand:

* How to access Claude Console
* What an organization is
* What the Default Workspace is
* When you need to create another Workspace
* How Workspace permissions work
* How to switch between Workspaces
* Where API keys are managed
* Why your Console role matters

We will **not create the API key yet**.

That comes in the next step.

---

# 1. What Is Claude Console?

Claude Console is Anthropic's developer platform for managing Claude API development.

It provides access to areas such as:

```text
Claude Console
│
├── API Keys
├── Workspaces
├── Billing
├── Usage
├── Organization
└── Development tools
```

Open the Console:

**https://console.anthropic.com/**

The exact appearance of the Console can change over time. Therefore, this guide focuses on the **current concepts and navigation**, rather than depending on a screenshot that may become outdated.

---

# 2. Sign In or Create an Account

Open:

https://console.anthropic.com/

Sign in with your Anthropic account.

If you do not yet have an account, follow Anthropic's current account-creation flow.

After signing in, you should reach the Claude Console.

---

# 3. Understand the Organization

An **organization** is the top-level container for your Claude Console environment.

Think of it as:

```text
Organization
│
├── Members
├── Workspaces
├── Billing
├── API Keys
└── Usage
```

For an individual developer, the organization may contain only you.

For a team, the organization can contain multiple members and multiple workspaces.

Anthropic's current organization model includes roles such as:

* Owner
* Admin
* Billing
* Developer
* User
* Membership Admin
* Claude Code User
* Other organization-level roles

The exact permissions available to a user depend on their organization role. ([platform.claude.com](https://platform.claude.com/docs/en/api/cli/beta/organization?utm_source=chatgpt.com))

---

# 4. What Is a Workspace?

A **Workspace** is a logical area inside an organization.

Anthropic describes Workspaces as a way to organize API usage, manage team access, and control costs.

You can use separate Workspaces for:

```text
Organization
│
├── Learning
├── Development
├── Testing
└── Production
```

This allows different projects or environments to be managed separately while remaining under the same organization. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

---

# 5. The Default Workspace

Every organization has a **Default Workspace**.

This Workspace is created automatically.

The Default Workspace:

* Cannot be renamed
* Cannot be archived
* Cannot be deleted

You do **not** need to create a Workspace simply to start learning Claude API.

For a beginner or individual developer, the Default Workspace may be enough. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

### Important

Do not confuse:

```text
Organization
```

with:

```text
Workspace
```

The relationship is:

```text
Organization
      │
      ├── Default Workspace
      │
      ├── Development Workspace
      │
      └── Production Workspace
```

---

# 6. Do I Need to Create a New Workspace?

### For learning

Usually:

> **No.**

Start with the Default Workspace unless you have a reason to separate the project.

### For teams

A separate Workspace can be useful when you need to separate:

* Projects
* Environments
* Teams
* API keys
* Usage
* Access
* Costs

Example:

```text
Organization
│
├── Default Workspace
│
├── GenAI Training
│
├── RAG Development
│
└── Production
```

---

# 7. Who Can Create a Workspace?

This is an important permission detail.

Anthropic's current documentation states that:

> **Only organization admins can create Workspaces.**

Organization users and developers must be added to Workspaces by an administrator. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

Therefore, if you don't see an option to create a Workspace, **do not assume that something is broken**.

Your organization role may simply not have permission.

---

# 8. Creating an Additional Workspace

You only need this step if you are an organization administrator and want a separate Workspace.

In Claude Console:

```text
Settings
   ↓
Workspaces
   ↓
Create workspace
```

Anthropic's current Console documentation describes this workflow. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

Enter a meaningful Workspace name.

Examples:

```text
GenAI-Learning
RAG-Development
Production
```

Avoid meaningless names such as:

```text
test123
abc
new
temp
```

A good name should explain the purpose of the Workspace.

---

# 9. Workspace Naming Strategy

For a community or team environment, use a consistent naming convention.

For example:

```text
Learning
Development
Staging
Production
```

Or project-oriented:

```text
GenAI-Training
RAG-Project
Agent-Project
Production
```

The goal is not to create many Workspaces.

The goal is to create **useful boundaries**.

---

# 10. Workspace Roles

Workspace access is separate from simply being a member of the organization.

Anthropic currently documents Workspace roles including:

| Workspace role              | General purpose                                             |
| --------------------------- | ----------------------------------------------------------- |
| Workspace User              | Use Playground                                              |
| Workspace Limited Developer | Create/manage API keys and use API with limited permissions |
| Workspace Developer         | Create/manage API keys and use API                          |
| Workspace Admin             | Full Workspace control                                      |
| Workspace Billing           | View Workspace billing information                          |

The Workspace Billing role is inherited from the organization's billing role rather than manually assigned. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

### Why does this matter?

Imagine:

```text
Venkat
  │
  ├── Organization role: Developer
  │
  └── Workspace role: Workspace Developer
```

The user may be able to develop and create API keys.

But another user might have:

```text
User
  │
  └── Workspace role: Workspace User
```

That user may not have the same API-management permissions.

---

# 11. Organization Role vs Workspace Role

This is one of the easiest concepts to misunderstand.

Think of two layers:

```text
              ORGANIZATION
                   │
          ┌────────┴────────┐
          │                 │
       Members           Billing
          │
          ▼
       WORKSPACE
          │
     ┌────┼────┐
     │    │    │
   User  Dev  Admin
```

Your organization role determines your broader organization-level access.

Your Workspace role determines what you can do inside a particular Workspace.

Anthropic also documents role inheritance. For example, organization admins automatically receive Workspace Admin access across Workspaces. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

---

# 12. Switching Workspaces

If your organization contains multiple Workspaces, you can switch between them using the Workspace selector in the Console.

Conceptually:

```text
Current Workspace
       │
       ▼
Workspace Selector
       │
       ├── Learning
       ├── Development
       └── Production
```

The active Workspace matters because Workspace-scoped resources and permissions depend on the Workspace you are working in.

Anthropic documents the Workspace selector in the Console's top-left area. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

---

# 13. Why Does Workspace Matter for API Keys?

This becomes important when we create authentication.

API keys can be associated with Workspace access.

For example:

```text
Organization
      │
      ├── Learning
      │      └── API Key
      │
      └── Production
             └── API Key
```

This gives organizations a way to separate API access between environments.

A key scoped to one Workspace can only access resources within that Workspace. Anthropic also supports keys with access across multiple Workspaces. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

We will cover the key types and scoping in:

**[04 — API Key](04-api-key.md)**

---

# 14. Workspace and Billing

Workspaces also help organizations separate usage and costs.

Think about a company with:

```text
Organization
│
├── Training
│   └── Development usage
│
├── RAG
│   └── RAG application usage
│
└── Production
    └── Customer application usage
```

Centralized billing can remain at the organization level while Workspaces provide useful separation for access and usage management.

Anthropic specifically describes Workspaces as a mechanism for organizing API usage and controlling costs. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

---

# 15. Where Are API Keys Managed?

API keys can be viewed and created from:

```text
Claude Console
      ↓
Settings
      ↓
API keys
```

Anthropic's current API documentation explicitly directs users to **Settings → API keys** in the Claude Console for viewing and creating API keys. ([platform.claude.com](https://platform.claude.com/docs/en/api/cli/beta/organization/api_keys?utm_source=chatgpt.com))

Workspace-specific API keys can also be managed from the relevant Workspace, depending on your role and the current Console interface. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

---

# 16. Do Not Create an API Key Yet

At this stage, stop here.

We want to understand the environment before creating credentials.

Our sequence is:

```text
Account
   ↓
Organization
   ↓
Workspace
   ↓
Permissions
   ↓
API Key
   ↓
Application
```

The next document will cover the API key in detail.

---

# 17. What If I Cannot See a Menu?

Don't immediately assume the Console is broken.

Use this diagnostic process:

```text
Menu missing
    │
    ▼
Check current Workspace
    │
    ▼
Check organization role
    │
    ▼
Check Workspace role
    │
    ▼
Check administrator permissions
```

### Example

You try to create a Workspace but don't see:

```text
Create workspace
```

Possible reason:

```text
You are not an organization admin.
```

Anthropic currently restricts Workspace creation to organization admins. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

---

# 18. Verification Checklist

Before moving to the next page, you should be able to answer **Yes** to these questions:

```text
[ ] I can sign in to Claude Console.

[ ] I know which organization I am using.

[ ] I understand what a Workspace is.

[ ] I know that every organization has a Default Workspace.

[ ] I understand that I don't need a new Workspace just to learn.

[ ] I understand that only organization admins can create Workspaces.

[ ] I know that Workspace roles affect permissions.

[ ] I know where API keys are managed.

[ ] I have not exposed or shared an API key.
```

---

# 19. Troubleshooting

## Problem: "I cannot create a Workspace."

### Check

Are you an organization administrator?

Only organization admins can create additional Workspaces. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

---

## Problem: "I cannot access a Workspace."

Your organization role does not automatically mean you have access to every Workspace.

Organization users and developers must be explicitly added to Workspaces by an administrator. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

---

## Problem: "I cannot create an API key."

Check:

```text
Organization role
       +
Workspace role
       +
Current Workspace
```

A Workspace User does not have the same API-management permissions as a Workspace Developer or Workspace Admin. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

---

## Problem: "I don't see the same Console screen as this guide."

That's possible.

The Console UI can change.

Use the current Anthropic documentation and look for the equivalent:

```text
Settings
API Keys
Workspaces
Billing
```

The concepts are more important than the exact position of a button.

---

# 20. Expert Notes

### Expert Note 1 — Don't create Workspaces unnecessarily

More Workspaces do not automatically mean better architecture.

Create a Workspace when you have a genuine reason to separate:

* Teams
* Projects
* Environments
* Access
* Usage
* Cost

For personal learning:

```text
Default Workspace
```

is usually sufficient.

---

### Expert Note 2 — Separate development and production

For a real team, consider:

```text
Development Workspace
       ↓
Testing / Staging Workspace
       ↓
Production Workspace
```

This creates clearer boundaries than using one key and one environment for everything.

---

### Expert Note 3 — Permissions are part of security

Security is not only:

```text
"Protect the API key."
```

It also includes:

```text
Who can create keys?
Who can use the API?
Who can view billing?
Who can access production?
Who can manage the Workspace?
```

Good GenAI infrastructure combines **authentication + authorization + secret management + cost controls**.

---

### Expert Note 4 — Default Workspace is special

Anthropic's current documentation notes that the Default Workspace cannot be renamed, archived, or deleted. It also behaves differently in some API and reporting contexts. ([platform.claude.com](https://platform.claude.com/docs/en/manage-claude/workspaces?utm_source=chatgpt.com))

For a beginner, you don't need to manage those differences manually.

Just remember:

> **Default Workspace is automatically available; additional Workspaces are optional.**

---

# 21. Next Step

We now understand:

```text
Claude Console
      ↓
Organization
      ↓
Workspace
      ↓
Roles & Permissions
```

Next we need to configure:

```text
Authentication
      ↓
API Key
      ↓
Secure Storage
```

Continue to:

**[03 — Billing](03-billing.md)**

Then:

**[04 — API Key](04-api-key.md)**

---

## Official References

* [Claude Platform Documentation](https://platform.claude.com/docs/)
* [Workspaces](https://platform.claude.com/docs/en/manage-claude/workspaces)
* [Authentication](https://platform.claude.com/docs/en/manage-claude/authentication)
* [API Keys](https://platform.claude.com/docs/en/api/cli/beta/organization/api_keys)
* [Organization API](https://platform.claude.com/docs/en/api/cli/beta/organization)

---

> **Documentation principle:** Don't troubleshoot blindly. First identify the layer: organization → workspace → role → authentication → application.
