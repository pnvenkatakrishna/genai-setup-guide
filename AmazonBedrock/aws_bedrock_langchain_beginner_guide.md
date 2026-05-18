# AWS Bedrock + LangChain + Python — Complete Setup Guide (Beginner → Production Ready)

> **Audience:** Beginners, DevOps Engineers, Cloud Engineers, GenAI Engineers  
> **Goal:** Learn how to configure AWS Bedrock securely, connect using Python, invoke LLMs using LangChain, and understand production best practices.

---

# Table of Contents

1. Introduction
2. Architecture Overview
3. Prerequisites
4. AWS Account Setup
5. IAM User Creation
6. AWS CLI Installation & Configuration
7. Enable Amazon Bedrock Access
8. Test Bedrock in Console
9. Setup Python Project
10. Install Dependencies
11. Configure Environment Variables
12. Connect AWS Bedrock using LangChain
13. Run First AI Prompt
14. Connect using boto3 (Direct API)
15. Streaming Responses
16. Common Errors & Troubleshooting
17. Security Best Practices
18. Cost Awareness
19. Production Architecture
20. Learning Roadmap
21. Useful Documentation

---

# 1. What is Amazon Bedrock?

Amazon Bedrock is a **fully managed AWS service** that provides access to **foundation models (LLMs)** from providers like:

- Amazon Nova
- Anthropic Claude
- Meta Llama
- Cohere
- Mistral
- Stability AI

You can build:

✅ Chatbots  
✅ AI Assistants  
✅ RAG Applications  
✅ Code Generators  
✅ DevOps Assistants  
✅ Document Summarizers  
✅ AI Agents  

without managing GPU infrastructure.

Official Docs:

https://docs.aws.amazon.com/bedrock/

---

# 2. Architecture Overview

## Beginner Architecture

```text
Python Application
        ↓
LangChain
        ↓
AWS SDK (boto3)
        ↓
Amazon Bedrock API
        ↓
Foundation Model
        ↓
Generated Response
```

---

## Production Architecture

```text
User
 ↓
Frontend/UI
 ↓
API Gateway
 ↓
Lambda / ECS / EKS
 ↓
Amazon Bedrock
 ↓
CloudWatch Logs
 ↓
Response
```

---

# 3. Prerequisites

Install:

| Tool | Version |
|------|----------|
| Python | 3.11+ |
| AWS CLI | Latest |
| UV | Latest |
| AWS Account | Required |

Check:

```bash
python --version
aws --version
```

---

# 4. Create AWS Account

Create:

https://aws.amazon.com/

---

# 5. Create IAM User

Open:

AWS Console → IAM → Users → Create User

Example:

```text
Username:

bedrock-user
```

Enable:

```text
Programmatic Access
```

---

## Attach Permissions

For Learning:

```text
AmazonBedrockFullAccess
```

Production:

Create custom policy with least privilege.

Example:

```json
{
"Effect":"Allow",
"Action":[
"bedrock:*"
],
"Resource":"*"
}
```

---

# 6. Create Access Key

IAM User

↓

Security Credentials

↓

Create Access Key

↓

CLI

Download:

```text
Access Key
Secret Access Key
```

Store safely.

---

# 7. Install AWS CLI

Download:

https://aws.amazon.com/cli/

Verify:

```bash
aws --version
```

Expected:

```text
aws-cli/2.x
```

---

# 8. Configure AWS CLI

Run:

```bash
aws configure
```

Enter:

```text
AWS Access Key ID:
AWS Secret Access Key:
Default region:
Output:
```

Example:

```text
us-east-1
json
```

---

Verify:

```bash
aws sts get-caller-identity
```

Expected:

```json
{
"Account":"xxxx",
"Arn":"xxxx"
}
```

---

# 9. Enable Amazon Bedrock

Open:

https://console.aws.amazon.com/bedrock/

Choose region:

```text
us-east-1
```

---

# 10. Enable Model Access

Open:

```text
Bedrock
 ↓
Model Catalog
```

Enable:

Recommended:

| Model | Use |
|------|------|
| Nova Micro | Cheap testing |
| Nova Lite | Apps |
| Nova Pro | Advanced |
| Claude Sonnet | Production |

---

# 11. Test Model in Playground

Open:

```text
Playground
```

Prompt:

```text
Explain Jenkins CI/CD simply
```

Response appears:

✅ Working

---

# 12. Install UV

Windows:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Verify:

```bash
uv --version
```

---

# 13. Create Project

Create:

```bash
mkdir aws_bedrock_project

cd aws_bedrock_project
```

Initialize:

```bash
uv init
```

---

# 14. Install Dependencies

Install:

```bash
uv add \
langchain \
langchain-aws \
boto3 \
python-dotenv
```

---

# 15. Project Structure

```text
aws_bedrock_project/

├── .env
├── main.py
├── pyproject.toml
├── .gitignore
└── .venv
```

---

# 16. Create .env

```env
AWS_REGION=us-east-1
```

---

# 17. Create .gitignore

Important:

```gitignore
.env

.venv/

__pycache__/

*.pem
```

Never push secrets.

---

# 18. Connect Bedrock using LangChain

Create:

main.py

```python
from langchain_aws import ChatBedrockConverse

from dotenv import load_dotenv

import os

load_dotenv()


def main():

    llm = ChatBedrockConverse(

        model="amazon.nova-micro-v1:0",

        region_name=os.getenv(
            "AWS_REGION"
        ),

        temperature=0,

        max_tokens=256
    )


    response = llm.invoke(

        "Explain Jenkins CI/CD in simple English"

    )

    print(response.content)


if __name__=="__main__":

    main()
```

Run:

```bash
uv run main.py
```

---

Expected:

```text
Jenkins automates build,
test and deployment.
```

---

# 19. Connect Using boto3 (Direct AWS API)

Install:

```bash
uv add boto3
```

Code:

```python
import boto3

client = boto3.client(

    service_name="bedrock-runtime",

    region_name="us-east-1"

)
```

Difference:

| Tool | Purpose |
|------|----------|
| boto3 | Direct AWS |
| LangChain | LLM orchestration |

---

# 20. Streaming Response Example

Streaming:

```python
for chunk in response:

    print(chunk)
```

Used in:

ChatGPT typing effect

---

# 21. Common Errors

---

## AccessDeniedException

Reason:

Permission issue

Fix:

Enable Bedrock

---

## NoCredentialsError

Reason:

CLI not configured

Fix:

```bash
aws configure
```

---

## Region Error

Fix:

Use:

```text
us-east-1
```

---

## ModuleNotFoundError

Fix:

```bash
uv sync
```

---

# 22. Troubleshooting Table

| Error | Reason | Fix |
|------|---------|-----|
| AccessDenied | IAM issue | Add permission |
| NoCredentials | AWS CLI | Configure |
| RegionError | Wrong region | us-east-1 |
| ImportError | Missing package | uv sync |

---

# 23. Security Best Practices

Never:

❌ Push secrets to GitHub

Never:

```env
AWS_SECRET_ACCESS_KEY
```

Commit:

Use:

```gitignore
.env
```

Always:

Use IAM least privilege.

Rotate keys regularly.

---

# 24. Cost Awareness

Bedrock pricing:

Based on:

- Input Tokens
- Output Tokens
- Model Type

Example:

| Model | Cost |
|------|------|
| Nova Micro | Low |
| Nova Lite | Medium |
| Nova Pro | Higher |
| Claude | Higher |

Monitor:

AWS Billing

↓

Cost Explorer

---

# 25. Production Architecture

Real workflow:

```text
User
 ↓

Frontend

 ↓

API Gateway

 ↓

Lambda / ECS

 ↓

Amazon Bedrock

 ↓

CloudWatch

 ↓

Response
```

---

# 26. Real Projects

Build:

### Project 1

DevOps Assistant

Topics:

- Docker
- Jenkins
- Kubernetes

---

### Project 2

Resume Analyzer

---

### Project 3

Terraform Generator

---

### Project 4

AWS Troubleshooting Bot

---

### Project 5

RAG Chatbot

---

# 27. Learning Roadmap

Phase 1:

Learn:

- Prompt Engineering
- Temperature
- Tokens
- Embeddings

---

Phase 2:

Learn:

- boto3
- Bedrock APIs
- Streaming
- Guardrails

---

Phase 3:

Learn:

- LangChain
- Vector DB
- RAG

---

Phase 4:

Learn:

- AI Agents
- MCP
- Multi-Agent

---

Phase 5:

Learn:

- LLMOps
- Monitoring
- Evaluation
- Observability

---

# 28. Useful Documentation

AWS Bedrock:

https://docs.aws.amazon.com/bedrock/

LangChain:

https://python.langchain.com/docs/

AWS CLI:

https://docs.aws.amazon.com/cli/

Boto3:

https://boto3.amazonaws.com/

---

# Final Outcome

After completing this guide you will understand:

✅ IAM

✅ AWS CLI

✅ Bedrock

✅ LangChain

✅ boto3

✅ Python Integration

✅ Security

✅ Cost Optimization

✅ Troubleshooting

✅ Production Architecture

✅ GenAI Foundations

This setup forms the base for:

- GenAI Engineer
- AI Engineer
- LLMOps Engineer
- Cloud + AI Engineer
- DevOps + GenAI Engineer

---

# Next Step

Build:

```text
AWS Bedrock

↓

LangChain

↓

RAG

↓

AI Agent

↓

Production AI Application
```

That path leads toward **GenAI Engineering**.