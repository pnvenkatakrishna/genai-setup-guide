# Claude Billing & Usage

> Understand how Claude API billing works, how to add usage credits, monitor consumption, control costs, and troubleshoot billing problems.

---

## 1. Goal

This guide explains the **billing layer of the Claude Platform** before you create and use an API key.

By the end of this guide, you should understand:

* How Claude API billing works
* The difference between Claude subscriptions and API billing
* Prepaid usage credits
* How to purchase credits
* How auto-reload works
* Who can manage billing
* How credits are consumed
* What happens when credits run out
* How to monitor usage
* How to control API spending
* Common billing problems
* How billing relates to Workspaces and API keys

---

# 2. Important: Claude Subscription ≠ Claude API Billing

There are two different concepts that beginners often confuse.

| Product             | Purpose                                            | Billing                     |
| ------------------- | -------------------------------------------------- | --------------------------- |
| Claude on claude.ai | Chat with Claude                                   | Subscription/plan-based     |
| Claude API          | Build applications using Claude                    | Usage-based                 |
| Claude Console      | Manage API organization, workspaces, keys, billing | Used to manage API platform |
| Claude Playground   | Test API capabilities from Console                 | API usage billing           |

A Claude subscription does **not automatically mean your application can use the Claude API for free**.

Your application uses the Claude Platform/API billing system.

---

# 3. How Claude API Billing Works

For most organizations using Claude Console, API usage is currently based on **prepaid usage credits**.

The basic flow is:

```text
Purchase Credits
       │
       ▼
Organization Credit Balance
       │
       ▼
Claude API / Playground / Claude Code Usage
       │
       ▼
Credits Consumed
       │
       ▼
Remaining Balance
```

Anthropic currently states that Claude API, Playground, and Claude Code usage through a Claude Console organization can consume prepaid usage credits.

You are charged for successful API calls and completed tasks. Failed requests are not charged, although a request that was on track to succeed can still be charged if the client disconnects or times out.

---

# 4. Prepaid Usage Credits

## 4.1 What are prepaid credits?

Prepaid credits are funds that your organization adds to its Claude Platform account before using the API.

For example:

```text
Organization
     │
     ├── Purchase usage credits
     │
     ▼
Credit Balance
     │
     ├── API usage
     ├── Playground usage
     └── Claude Code usage
```

The balance decreases as billable usage occurs.

---

# 5. Why Prepaid Billing Exists

Prepaid billing provides a simple way to control API spending.

Instead of allowing unlimited usage against an unknown future bill:

```text
Application
     │
     ▼
API Usage
     │
     ▼
Credits already purchased
```

This makes it easier to control costs while learning and developing.

For a beginner project, this is especially useful because you can start with a controlled amount of credits and monitor consumption.

---

# 6. Where to Manage Billing

Billing is managed from the Claude Console.

Open:

**Claude Console → Settings → Billing**

Official Console:

https://console.anthropic.com/

Anthropic's current documentation confirms that the Billing page is under `Settings > Billing`.

---

# 7. Who Can Manage Billing?

Billing is not available to every organization member.

Current organization roles include roles such as:

* User
* Developer
* Billing
* Admin

The **Billing** role is specifically intended for managing billing-related information.

The **Admin** role has broader organization-management permissions.

Therefore, if you cannot see billing controls, your organization role may not have billing permission.

---

# 8. How to Check Billing

Go to:

```text
Claude Console
    │
    └── Settings
          │
          └── Billing
```

On the Billing page, you can review information such as:

* Available credit balance
* Credit usage
* Payment method
* Auto-reload configuration
* Billing history
* Current usage information

The exact interface can change over time, so use the labels currently displayed in your Console.

---

# 9. How to Buy Credits

For organizations using prepaid billing, the current process is:

```text
1. Sign in to Claude Console
        │
        ▼
2. Settings
        │
        ▼
3. Billing
        │
        ▼
4. Buy credits
        │
        ▼
5. Enter amount
        │
        ▼
6. Confirm purchase
```

### Current documented procedure

1. Sign in to the Claude Console.
2. You must have an **Admin** or **Billing** role.
3. Open **Settings → Billing**.
4. Select **Buy credits**.
5. Enter the amount you want to purchase.
6. Confirm the purchase.

Anthropic states that purchased credits become available immediately.

---

# 10. Do Not Hard-Code Pricing in This Guide

API pricing changes over time.

Therefore, this repository should **not** contain a permanent table such as:

```text
Model X = $X per million tokens
Model Y = $Y per million tokens
```

unless the table is explicitly marked with a date and verified against the current pricing documentation.

Instead, use the official pricing page:

https://platform.claude.com/docs/en/about-claude/pricing

This keeps the repository from becoming outdated.

---

# 11. Credits Are Not the Same as Tokens

This distinction is important.

### Tokens

Tokens represent the amount of text processed by a model.

For example:

```text
User prompt
   ↓
Input tokens

Claude response
   ↓
Output tokens
```

### Credits

Credits represent the organization's prepaid monetary balance used to pay for eligible Claude usage.

Conceptually:

```text
Tokens
   │
   ▼
Model-specific pricing
   │
   ▼
Usage cost
   │
   ▼
Organization credit balance
```

Do not confuse:

```text
Token = unit of model processing
Credit = prepaid billing balance
```

---

# 12. What Happens When Credits Run Out?

If your organization has no remaining prepaid credits:

```text
Credit Balance
      │
      ▼
     $0
      │
      ▼
API requests cannot continue
```

Anthropic currently states that when prepaid credits are exhausted, the organization cannot continue calling the API or using the Playground until additional credits are added.

Therefore:

```text
No credits
   ↓
No API usage
   ↓
Add credits
   ↓
API access resumes
```

---

# 13. Auto-Reload

Claude Console supports **auto-reload** for prepaid credits.

Auto-reload allows the system to automatically purchase additional credits when the balance falls below a threshold.

Example:

```text
Current balance
     │
     ▼
$8
     │
     │ below configured threshold
     ▼
Auto-reload triggered
     │
     ▼
Additional credits purchased
     │
     ▼
New balance
```

---

# 14. How Auto-Reload Works

The current documented setup is:

1. Open **Settings → Billing**.
2. Find the **Auto-reload** section.
3. Click **Edit**.
4. Enable or disable auto-reload.
5. If enabled, configure:

   * Minimum balance that triggers the purchase
   * Amount to reload

Anthropic documents these controls on the Billing page.

---

# 15. Should You Enable Auto-Reload?

For learning and experimentation, understand the difference between:

### Manual credits

```text
You purchase
     ↓
Use credits
     ↓
Balance decreases
     ↓
You decide when to purchase again
```

### Auto-reload

```text
You purchase
     ↓
Use credits
     ↓
Balance becomes low
     ↓
Automatic purchase
```

Auto-reload is convenient, but it means your payment method can be charged automatically.

For a learning environment, understand this behavior before enabling it.

For production systems, automatic replenishment can prevent unexpected service interruption, but it should be combined with proper spending controls and monitoring.

---

# 16. Credit Expiration

Purchased credits are subject to Anthropic's Credit Terms.

The current Anthropic Help Center states that purchased credits:

* Expire one year from the purchase date
* Cannot have their expiration date extended
* Appear in invoice history after expiration
* Are non-refundable

Always check the current Credit Terms because billing policies can change.

---

# 17. Monthly Invoicing

Not every organization uses prepaid credits.

Some organizations have a monthly invoicing arrangement through Anthropic's Sales team.

In that model:

```text
API Usage
    │
    ▼
Monthly usage aggregation
    │
    ▼
Invoice
    │
    ▼
Payment
```

Anthropic currently describes this as monthly billing in arrears for organizations that have an invoicing arrangement.

For a normal individual learner following this repository, prepaid usage credits are the more relevant model.

---

# 18. Payment Method

Organizations using Console billing can manage their payment method from:

```text
Settings
   ↓
Billing
   ↓
Payment method
```

The current documented flow allows an Admin or Billing user to update the payment method from the Billing page.

---

# 19. Billing and Workspace

This is an important architectural concept.

A Workspace does **not create a completely independent billing organization**.

Instead:

```text
Organization
│
├── Billing
│
├── Workspace A
│     ├── API keys
│     └── Usage
│
├── Workspace B
│     ├── API keys
│     └── Usage
│
└── Workspace C
      ├── API keys
      └── Usage
```

Workspaces help organize API usage, team access, keys, and cost controls while billing remains centrally managed by the organization.

---

# 20. Why Workspace Matters for Cost Management

Imagine a company has:

```text
Organization
│
├── Development
├── Testing
├── Production
└── Research
```

Each Workspace can help separate workloads.

For example:

```text
Development
    ↓
Experimental API usage

Testing
    ↓
Automated test workloads

Production
    ↓
Customer traffic

Research
    ↓
Model experiments
```

This makes it easier to understand where API usage originates.

---

# 21. Billing vs API Key

These are different concepts.

### Billing

Answers:

> "How does the organization pay for Claude usage?"

### API key

Answers:

> "How does my application authenticate with Claude?"

Conceptually:

```text
Organization
│
├── Billing
│     └── Pays for usage
│
└── API Key
      └── Authenticates application
```

You need both concepts to understand the complete workflow.

---

# 22. Billing vs Authentication

Do not make this mistake:

```text
I added money
        ↓
Therefore my application is authenticated
```

That is incorrect.

Billing and authentication are separate layers.

### Billing

```text
Can the organization pay for usage?
```

### Authentication

```text
Is this application authorized to call the API?
```

### API request

```text
Application
     │
     ├── API key
     │
     ▼
Claude API
     │
     ├── Authentication
     ├── Authorization
     ├── Usage accounting
     └── Model processing
```

---

# 23. Usage Monitoring

Do not simply purchase credits and forget about usage.

Monitor:

```text
Requests
   ↓
Input tokens
   ↓
Output tokens
   ↓
Model usage
   ↓
Cost
```

The Claude Console provides usage and cost information.

For organizations that need programmatic reporting, Anthropic provides a **Usage and Cost Admin API** for Claude Platform organizations.

---

# 24. Usage and Cost API

For larger organizations, billing data may need to be integrated into internal systems.

Anthropic provides a Usage and Cost Admin API that can be used for:

* Historical usage analysis
* Cost reconciliation
* Usage monitoring
* Internal reporting
* Cost optimization
* Operational analysis

This is an advanced topic.

You do **not** need the Usage and Cost API for your first Claude application.

First learn:

```text
Console
   ↓
Billing
   ↓
API Key
   ↓
First API request
```

Then learn organization-level administration and reporting.

---

# 25. Spend Limits

Billing balance and spend limits are not the same thing.

### Credit balance

Represents available prepaid usage.

### Spend limit

Controls how much usage can be incurred under the applicable limit.

The Claude Console allows organizations to configure spend limits from the Billing page for supported configurations. Anthropic documents the path as:

```text
Settings
   ↓
Billing
   ↓
Spend limits
   ↓
Adjust limit
```

When a configured organization or workspace spend limit is reached, API requests can be rejected until the limit is raised or the applicable period resets.

---

# 26. Credit Balance vs Spend Limit

Think of them as two different safety mechanisms.

```text
                Organization
                     │
          ┌──────────┴──────────┐
          │                     │
     Credit Balance        Spend Limit
          │                     │
     Money available       Usage ceiling
          │                     │
          └──────────┬──────────┘
                     │
                  API Usage
```

Example:

```text
Credit balance = $100

Spend limit = $20

```

The exact behavior depends on the organization's billing configuration and applicable limits, but conceptually:

```text
Available funds ≠ Allowed spending limit
```

---

# 27. API Billing Error

The Claude API has a specific billing error category.

Anthropic documents:

```text
HTTP 402
billing_error
```

This indicates an issue with billing or payment information.

For example:

```text
Application
    │
    ▼
Claude API
    │
    ▼
Billing problem
    │
    ▼
HTTP 402
```

Do not confuse this with:

```text
401 → Authentication problem
402 → Billing problem
400 → Request/validation problem
```

---

# 28. Common Billing Problems

## Problem 1 — Billing page is missing

Possible reasons:

* Your organization role does not have billing permission.
* You are in a different organization.
* You are looking at the wrong Console account.
* Your organization uses a different billing arrangement.

Check:

```text
Organization
   ↓
Current Workspace
   ↓
Organization role
   ↓
Settings → Billing
```

---

## Problem 2 — Cannot buy credits

Check:

* Are you an Admin or Billing user?
* Is a valid payment method configured?
* Are there payment-provider issues?
* Are you in the correct organization?
* Is the billing configuration different from prepaid billing?

---

## Problem 3 — API returns billing error

Check:

```text
1. Credit balance
2. Payment method
3. Billing status
4. Spend limits
5. API key validity
6. Current organization/workspace
```

A billing error should not automatically be treated as an API-key problem.

---

## Problem 4 — Credits disappeared faster than expected

Investigate:

```text
Model used
      ↓
Input tokens
      ↓
Output tokens
      ↓
Request frequency
      ↓
Application loops
      ↓
Repeated requests
      ↓
Total usage
```

Common application-level causes include:

* Infinite loops
* Uncontrolled agent execution
* Excessively large prompts
* Large context windows
* Repeated retries
* High-frequency API calls
* Unnecessary model calls
* Sending entire documents repeatedly

---

# 29. Cost-Control Best Practices

For development, follow these principles.

### 1. Start small

Do not purchase large amounts before understanding your usage pattern.

### 2. Monitor usage

Check usage regularly during development.

### 3. Avoid unnecessary requests

Every model call should have a purpose.

### 4. Control loops

Agentic applications can make multiple model calls.

Always understand:

```text
User request
    ↓
Agent
    ↓
Tool
    ↓
LLM
    ↓
Tool
    ↓
LLM
    ↓
...
```

One user request can result in multiple model calls.

### 5. Use appropriate models

Do not automatically use the most expensive model for every task.

Choose a model based on:

* Quality requirements
* Latency requirements
* Context requirements
* Reasoning requirements
* Cost

Always verify current model pricing before making production decisions.

### 6. Use production cost controls

For larger applications, investigate:

* Spend limits
* Usage monitoring
* Prompt caching
* Batch processing
* Rate limits
* Application-level quotas
* Logging
* Alerts

---

# 30. Important Agentic AI Cost Consideration

This is particularly important when building Agents.

A simple chatbot may make:

```text
1 user request
      ↓
1 LLM call
```

An agent may make:

```text
1 user request
      ↓
Planning
      ↓
LLM call
      ↓
Tool call
      ↓
LLM call
      ↓
Another tool
      ↓
LLM call
      ↓
Final answer
```

Therefore:

```text
1 user interaction
        ≠
1 API request
```

This is one of the most important cost concepts when building Agentic AI systems.

---

# 31. Production Billing Architecture

A mature application should not depend on the user manually checking the Billing page every day.

A production architecture may look like:

```text
                    ┌──────────────────┐
                    │   Application    │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │   Claude API     │
                    └────────┬─────────┘
                             │
                ┌────────────┴────────────┐
                │                         │
                ▼                         ▼
         Usage / Cost Data          Application Logs
                │                         │
                └────────────┬────────────┘
                             ▼
                    ┌──────────────────┐
                    │ Monitoring / BI  │
                    └────────┬─────────┘
                             │
                             ▼
                       Cost Controls
```

For larger organizations, Anthropic's Usage and Cost API can be integrated into internal monitoring and reporting systems.

---

# 32. Billing Security

Billing access should be treated as privileged access.

Do not:

* Share payment information unnecessarily
* Share organization credentials
* Give billing permissions to everyone
* Store payment information in Git
* Commit API keys into GitHub
* Put billing secrets inside source code

Use role-based access.

Example:

```text
Developer
    ↓
Develops application

Billing
    ↓
Manages billing

Admin
    ↓
Manages organization
```

---

# 33. What You Should Know Before Creating the API Key

Before moving to the next document, verify:

### Account

* [ ] I can sign in to Claude Console.
* [ ] I know which organization I am using.

### Workspace

* [ ] I understand the Default Workspace.
* [ ] I know my current Workspace.
* [ ] I understand that Workspaces organize API usage.

### Billing

* [ ] I can locate Settings → Billing.
* [ ] I understand prepaid credits.
* [ ] I understand that API usage is usage-based.
* [ ] I know where to check my credit balance.
* [ ] I understand auto-reload.
* [ ] I understand that credits have expiration terms.
* [ ] I understand that billing and authentication are different.

### Security

* [ ] I will not commit API keys to Git.
* [ ] I will not share API keys.
* [ ] I will use environment variables or a secret manager.

---

# 34. Beginner Mental Model

Remember this:

```text
Claude Console
      │
      ├── Organization
      │
      ├── Workspace
      │
      ├── Billing
      │     └── Usage credits
      │
      └── API Key
             │
             ▼
        Your Application
             │
             ▼
        Claude API
```

This is the foundation for everything we build next.

---

# 35. Expert Mental Model

At an organizational level:

```text
Organization
│
├── Identity / Roles
│
├── Workspaces
│     ├── Members
│     ├── API keys
│     ├── Usage
│     └── Controls
│
├── Billing
│     ├── Credits
│     ├── Payment method
│     ├── Auto-reload
│     └── Spend controls
│
└── Applications
      ├── Development
      ├── Testing
      └── Production
```

This separation is important because **identity, authorization, billing, workspace organization, and application authentication are different concerns**.

---

# 36. Official References

Always verify billing information against the current official documentation.

* [Claude Platform Documentation](https://platform.claude.com/docs/)
* [Claude Pricing](https://platform.claude.com/docs/en/about-claude/pricing)
* [Claude Help Center — API Billing](https://support.claude.com/en/articles/8977456-how-do-i-pay-for-my-claude-api-usage)
* [Claude Workspaces](https://platform.claude.com/docs/en/manage-claude/workspaces)
* [Usage and Cost API](https://platform.claude.com/docs/en/manage-claude/usage-cost-api)
* [Rate Limits](https://platform.claude.com/docs/en/api/rate-limits)
* [API Errors](https://platform.claude.com/docs/en/api/errors)

---

# 37. Next Step

Billing is now understood.

The next layer is **authentication**.

The sequence is:

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
06 First API Request
```

Next document:

**`docs/04-api-key.md`**

There we will cover:

* What an API key actually is
* Personal API keys
* Workspace-scoped keys
* Service account keys
* Key permissions
* Creating a key
* Naming a key
* Secure storage
* Environment variables
* Windows PowerShell
* Git Bash
* macOS/Linux
* API-key verification
* What NOT to do
* Key rotation
* Key revocation
* GitHub secret protection
* Production secret management

> **Important:** Never paste your real API key into this repository, screenshots, chat messages, README files, `.env` files committed to Git, or public GitHub repositories.
