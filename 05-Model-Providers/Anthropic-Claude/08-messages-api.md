# Claude Messages API

> **Purpose:** Understand the Claude Messages API deeply before building applications, RAG systems, agents, or production GenAI services.

---

## 1. What You Will Learn

In this document, you will understand:

* What the Claude Messages API is
* How a request reaches Claude
* The `POST /v1/messages` endpoint
* Request headers
* Request body structure
* `model`
* `max_tokens`
* `messages`
* `system`
* User and assistant roles
* Multi-turn conversations
* Content blocks
* Text input
* Image input
* Response structure
* `stop_reason`
* Token usage
* Stateless conversations
* `count_tokens`
* Custom stop sequences
* Workspace selection
* Python SDK examples
* Raw HTTP/cURL examples
* Common mistakes
* Production considerations

---

# 2. What Is the Messages API?

The **Messages API** is Anthropic's primary API for sending input to Claude and receiving a generated response.

At a high level:

```text
Your Application
       |
       | HTTPS request
       v
Claude Messages API
       |
       | model inference
       v
Claude
       |
       | structured response
       v
Your Application
```

The API endpoint is:

```text
POST https://api.anthropic.com/v1/messages
```

The Messages API supports:

* Single-turn requests
* Stateless multi-turn conversations
* Text input
* Image input
* System instructions
* Tool use
* Streaming
* Extended thinking
* Structured output
* Prompt caching
* Other advanced capabilities

Anthropic's current API reference describes the Messages API as accepting a structured list of messages containing text and/or image content and generating the next message in the conversation.

---

# 3. The Most Important Mental Model

The most important thing to understand is:

> **The Messages API is stateless.**

Claude does not automatically maintain your application's conversation history between independent API requests.

For example:

```text
Request 1

User:
What is Docker?

Claude:
Docker is ...
```

If you later send:

```text
Request 2

User:
What are its advantages?
```

Claude does not automatically know that "its" refers to Docker unless your application sends the previous conversation context.

Therefore, your application typically sends:

```text
[
    user message,
    assistant response,
    user message
]
```

For example:

```text
[
    {
        "role": "user",
        "content": "What is Docker?"
    },
    {
        "role": "assistant",
        "content": "Docker is a containerization platform..."
    },
    {
        "role": "user",
        "content": "What are its advantages?"
    }
]
```

Claude then generates the next assistant response.

Anthropic explicitly documents the Messages API as supporting **stateless multi-turn conversations**.

---

# 4. Basic Request Flow

A basic Claude request looks like this:

```text
Application
    |
    | API key
    | model
    | max_tokens
    | messages
    v
POST /v1/messages
    |
    v
Claude Model
    |
    v
Message Response
```

Conceptually:

```json
{
  "model": "YOUR_MODEL_ID",
  "max_tokens": 1024,
  "messages": [
    {
      "role": "user",
      "content": "Explain Docker."
    }
  ]
}
```

The actual model ID should be selected from the models available to your account rather than copied blindly from an old tutorial.

---

# 5. API Endpoint

The endpoint is:

```text
POST https://api.anthropic.com/v1/messages
```

The API reference currently documents the Messages creation endpoint as:

```text
POST /v1/messages
```

---

# 6. Required Headers

A direct HTTP request normally contains:

```http
Content-Type: application/json
anthropic-version: 2023-06-01
X-Api-Key: YOUR_API_KEY
```

Example:

```bash
curl https://api.anthropic.com/v1/messages \
  -H "Content-Type: application/json" \
  -H "anthropic-version: 2023-06-01" \
  -H "X-Api-Key: $ANTHROPIC_API_KEY"
```

### Header explanation

| Header              | Purpose                                        |
| ------------------- | ---------------------------------------------- |
| `Content-Type`      | Tells the server that the request body is JSON |
| `anthropic-version` | Specifies the Anthropic API version            |
| `X-Api-Key`         | Authenticates the request                      |

The Python SDK handles these HTTP details for you.

---

# 7. Optional Workspace Header

Anthropic also supports:

```http
anthropic-workspace-id
```

Example:

```http
anthropic-workspace-id: wrkspc_XXXXXXXX
```

This header selects the Workspace for the request.

It is only necessary when the credential can act on more than one Workspace. A credential scoped to a specific Workspace may omit it.

For a beginner:

```text
Single Workspace
      |
      v
Usually no Workspace header needed
```

For multi-Workspace credentials:

```text
API Key
   |
   +---- Workspace A
   |
   +---- Workspace B
```

Your application may need to specify which Workspace should process the request.

---

# 8. Request Body

The basic request body contains:

```json
{
  "model": "YOUR_MODEL_ID",
  "max_tokens": 1024,
  "messages": [
    {
      "role": "user",
      "content": "Hello Claude"
    }
  ]
}
```

Let's understand each field.

---

# 9. `model`

The `model` parameter tells Claude which model should process the request.

Example:

```python
model="YOUR_MODEL_ID"
```

Do not blindly hard-code a model ID copied from an old article.

Instead, discover available models:

```python
models = client.models.list()

for model in models:
    print(model.id)
```

Then select an appropriate model.

This is particularly important because model availability and model IDs can change over time.

---

# 10. `max_tokens`

`max_tokens` specifies the **maximum number of tokens Claude can generate**.

Example:

```python
max_tokens=1024
```

It does **not** mean Claude must generate exactly 1024 tokens.

For example:

```text
max_tokens = 1024

Claude may generate:

250 tokens
500 tokens
900 tokens
1024 tokens
```

The model can naturally stop before reaching the maximum.

Anthropic describes `max_tokens` as the absolute maximum number of tokens to generate.

---

# 11. `messages`

The `messages` parameter contains the conversation.

Basic example:

```python
messages=[
    {
        "role": "user",
        "content": "What is Kubernetes?"
    }
]
```

The message contains two important fields:

```text
role
content
```

---

# 12. Message Roles

The most important roles you will work with are:

```text
user
assistant
```

### User

Represents input from the user/application.

```json
{
  "role": "user",
  "content": "What is Kubernetes?"
}
```

### Assistant

Represents a previous Claude response that your application is sending back as conversation history.

```json
{
  "role": "assistant",
  "content": "Kubernetes is a container orchestration platform..."
}
```

---

# 13. Important: There Is No `system` Message Role

A common mistake is:

```json
{
  "role": "system",
  "content": "You are a DevOps teacher."
}
```

Do **not** use this structure for the Messages API.

Anthropic's Messages API uses a separate top-level:

```text
system
```

parameter.

Example:

```python
message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=1024,
    system="You are an expert DevOps instructor.",
    messages=[
        {
            "role": "user",
            "content": "Explain Kubernetes."
        }
    ]
)
```

Anthropic's API reference explicitly states that there is no `"system"` role for input messages in the Messages API.

---

# 14. System Prompt

The `system` parameter provides high-level context and instructions.

Example:

```python
system="You are an expert DevOps instructor. Explain concepts using simple real-world examples."
```

Then:

```python
messages=[
    {
        "role": "user",
        "content": "What is Kubernetes?"
    }
]
```

Think of it as:

```text
System
  |
  | Defines behavior/context
  v
Claude
  |
  | Processes user message
  v
Response
```

A system prompt can define:

* Role
* Objective
* Style
* Constraints
* Domain context
* Output requirements

---

# 15. Simple System Prompt Example

```python
message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=1024,
    system=(
        "You are a DevOps instructor. "
        "Explain concepts in simple language. "
        "Always include a practical example."
    ),
    messages=[
        {
            "role": "user",
            "content": "What is Docker?"
        }
    ]
)

print(message.content)
```

Possible conceptual response:

```text
Docker is a platform for packaging applications
and their dependencies into containers.

Example:
A Python application can be packaged with its
Python runtime and dependencies into a Docker image.
```

---

# 16. Content Can Be a String

The simplest form is:

```python
messages=[
    {
        "role": "user",
        "content": "Explain Terraform."
    }
]
```

A string is shorthand for a text content block.

Conceptually, this:

```json
{
  "role": "user",
  "content": "Hello Claude"
}
```

is equivalent to:

```json
{
  "role": "user",
  "content": [
    {
      "type": "text",
      "text": "Hello Claude"
    }
  ]
}
```

Anthropic documents both forms.

---

# 17. Content Blocks

For more advanced requests, `content` can be an array of content blocks.

Example:

```python
messages=[
    {
        "role": "user",
        "content": [
            {
                "type": "text",
                "text": "Explain this architecture."
            }
        ]
    }
]
```

This becomes especially useful when combining:

```text
Text
+
Images
+
Documents
+
Tool results
+
Other supported content
```

---

# 18. Text + Image Input

Claude's Messages API supports image content.

Example:

```python
message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=1024,
    messages=[
        {
            "role": "user",
            "content": [
                {
                    "type": "image",
                    "source": {
                        "type": "url",
                        "url": "https://example.com/image.jpg"
                    }
                },
                {
                    "type": "text",
                    "text": "Describe this image."
                }
            ]
        }
    ]
)
```

Anthropic's current Vision documentation supports image content through URL, base64, and uploaded Files API references.

---

# 19. Base64 Image Example

An image can also be supplied using base64.

Conceptually:

```python
messages=[
    {
        "role": "user",
        "content": [
            {
                "type": "image",
                "source": {
                    "type": "base64",
                    "media_type": "image/png",
                    "data": image_data
                }
            },
            {
                "type": "text",
                "text": "Describe this image."
            }
        ]
    }
]
```

Supported image formats currently include:

```text
JPEG
PNG
GIF
WebP
```

---

# 20. Files API for Repeated Images

If the same image needs to be reused across multiple requests, Anthropic's Files API can be used to upload it once and reference the resulting `file_id`.

Conceptually:

```text
Image
  |
  | Upload once
  v
Files API
  |
  v
file_id
  |
  +---- Request 1
  |
  +---- Request 2
  |
  +---- Request 3
```

This can reduce repeated image payloads in multi-turn workflows.

---

# 21. Multi-Turn Conversation

Suppose the user asks:

```text
User:
What is Docker?
```

Claude answers:

```text
Docker is a containerization platform...
```

Then the user asks:

```text
Why is it useful?
```

Your application should send the previous conversation:

```python
messages=[
    {
        "role": "user",
        "content": "What is Docker?"
    },
    {
        "role": "assistant",
        "content": "Docker is a containerization platform..."
    },
    {
        "role": "user",
        "content": "Why is it useful?"
    }
]
```

Then Claude can interpret:

```text
"It"
```

as referring to Docker.

---

# 22. Complete Multi-Turn Example

```python
import anthropic

client = anthropic.Anthropic()

messages = [
    {
        "role": "user",
        "content": "What is Docker?"
    }
]

response = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=1024,
    messages=messages
)

assistant_text = "".join(
    block.text
    for block in response.content
    if block.type == "text"
)

print("Claude:", assistant_text)

messages.append(
    {
        "role": "assistant",
        "content": assistant_text
    }
)

messages.append(
    {
        "role": "user",
        "content": "Why is it useful?"
    }
)

response = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=1024,
    messages=messages
)

assistant_text = "".join(
    block.text
    for block in response.content
    if block.type == "text"
)

print("Claude:", assistant_text)
```

The important concept is:

```text
Application owns conversation history.
```

Claude receives the history you provide.

---

# 23. Conversation Architecture

A production application commonly maintains something like:

```text
User
 |
 v
Application
 |
 +---- Conversation Store
 |       |
 |       +---- User message
 |       +---- Assistant message
 |       +---- User message
 |       +---- Assistant message
 |
 v
Messages API
 |
 v
Claude
```

The conversation store could be:

```text
PostgreSQL
Redis
DynamoDB
MongoDB
Application memory
```

depending on the architecture.

---

# 24. Consecutive Roles

Anthropic's API supports multiple `user` and `assistant` messages.

For example:

```python
messages=[
    {
        "role": "user",
        "content": "Hello"
    },
    {
        "role": "user",
        "content": "I am learning DevOps"
    }
]
```

The API documentation notes that consecutive user or assistant turns are combined into a single turn.

For beginner applications, however, keeping the conversation logically structured is usually easier to understand:

```text
user
assistant
user
assistant
user
```

---

# 25. Assistant Prefill / Partial Response

An advanced feature is starting the final assistant message with an `assistant` message.

Example:

```python
messages=[
    {
        "role": "user",
        "content": "What is the Greek name for the Sun?"
    },
    {
        "role": "assistant",
        "content": "The answer is ("
    }
]
```

Claude continues from the supplied assistant content.

This can be useful when you need to constrain or guide the beginning of a response.

Anthropic documents this behavior in the Messages API reference.

---

# 26. Response Structure

A successful Messages API response is a structured object.

Conceptually:

```json
{
  "id": "msg_...",
  "type": "message",
  "role": "assistant",
  "content": [
    {
      "type": "text",
      "text": "..."
    }
  ],
  "model": "YOUR_MODEL_ID",
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "usage": {
    "input_tokens": 100,
    "output_tokens": 50
  }
}
```

The exact response can contain additional fields depending on enabled features.

The API currently returns a `Message` object for a normal non-streaming request.

---

# 27. `content`

The most important response field for a beginner is:

```python
message.content
```

It contains content blocks.

A response may contain a text block:

```python
[
    {
        "type": "text",
        "text": "Docker is..."
    }
]
```

Therefore, don't blindly assume the entire response is a plain string.

A safe beginner extraction pattern is:

```python
text = "".join(
    block.text
    for block in message.content
    if block.type == "text"
)

print(text)
```

---

# 28. `role`

The generated message normally has:

```text
role = assistant
```

Example:

```python
print(message.role)
```

Possible output:

```text
assistant
```

---

# 29. `id`

Each message has an identifier.

Example:

```python
print(message.id)
```

You may see something similar to:

```text
msg_01...
```

This is useful for:

* Logging
* Debugging
* Tracing
* Diagnostics
* Correlating API requests

---

# 30. `model`

The response also identifies the model used.

```python
print(message.model)
```

This is useful when your application supports multiple models.

---

# 31. `stop_reason`

`stop_reason` tells you why Claude stopped generating.

A normal completion commonly has:

```text
end_turn
```

If you specify custom `stop_sequences` and Claude encounters one, the response can contain:

```text
stop_sequence
```

In production systems, don't assume every response stopped for exactly the same reason.

---

# 32. Token Usage

The response contains usage information.

Example:

```python
print(message.usage)
```

Conceptually:

```text
input_tokens
output_tokens
```

This information is important for:

* Cost tracking
* Performance monitoring
* Prompt optimization
* Debugging
* Capacity planning

---

# 33. Input vs Output Tokens

Think about a request as:

```text
                Claude
                  ^
                  |
Input tokens ---> | <--- Output tokens
```

### Input tokens

Information sent to Claude:

```text
System prompt
+
Conversation history
+
User message
+
Images/documents/tool results
```

### Output tokens

Information generated by Claude:

```text
Claude's response
```

For a multi-turn application, the amount of input can grow because your application may repeatedly send conversation history.

This is one reason production applications need to think about:

* Context management
* Summarization
* Prompt caching
* Retrieval
* Conversation truncation

---

# 34. Counting Tokens Before Sending

Anthropic provides a token-counting endpoint.

Python SDK:

```python
count = client.messages.count_tokens(
    model="YOUR_MODEL_ID",
    messages=[
        {
            "role": "user",
            "content": "Explain Kubernetes."
        }
    ]
)

print(count.input_tokens)
```

This can be useful when:

* Estimating request size
* Checking context usage
* Building cost controls
* Preparing large prompts
* Designing RAG systems

---

# 35. Custom Stop Sequences

You can tell Claude to stop when it encounters a specific sequence.

Example:

```python
response = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=1024,
    stop_sequences=["END"],
    messages=[
        {
            "role": "user",
            "content": "Generate a short report and finish with END."
        }
    ]
)
```

If Claude stops because it encountered the custom sequence, `stop_reason` can be:

```text
stop_sequence
```

and the matched sequence is available through `stop_sequence`.

---

# 36. Streaming

The Messages API can stream output incrementally.

Conceptually:

```text
Claude starts generating
        |
        +--> token/chunk 1
        |
        +--> token/chunk 2
        |
        +--> token/chunk 3
        |
        +--> ...
```

Instead of waiting for the entire response:

```text
Request
   |
   |--------------------------|
   |                          |
   v                          v
Wait                       Complete
                         response
```

streaming allows:

```text
Request
   |
   +--> partial output
   +--> partial output
   +--> partial output
   +--> final output
```

In the Python SDK, Anthropic recommends:

```python
client.messages.stream(...)
```

for streaming.

A dedicated streaming document should be created later rather than mixing all streaming concepts into this introductory API document.

---

# 37. Important Parameter: `temperature`

You may find older Claude tutorials containing:

```python
temperature=0
```

Be careful.

The current API reference marks `temperature` as **deprecated** and states that models released after Claude Opus 4.6 do not support setting it, except for backward-compatible handling of `1.0`.

Therefore, **do not add `temperature` to new beginner examples unless the selected model's current documentation explicitly supports it.**

This is an important example of why copying old GenAI tutorials can produce confusing API errors.

---

# 38. `top_p` and `top_k`

The same warning applies to:

```text
top_p
top_k
```

The current API reference marks both as deprecated for newer models and states that models released after Claude Opus 4.6 do not support them in the old form.

For this reason, they are intentionally not used in the beginner examples in this repository.

---

# 39. Python SDK Example

Here is the clean beginner implementation:

```python
import anthropic

client = anthropic.Anthropic()

response = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=1024,
    system="You are a helpful DevOps instructor.",
    messages=[
        {
            "role": "user",
            "content": "Explain Kubernetes in simple terms."
        }
    ]
)

text = "".join(
    block.text
    for block in response.content
    if block.type == "text"
)

print(text)
```

---

# 40. Inspect the Complete Response

During learning, it is useful to inspect the returned object:

```python
print(response)
```

You can also inspect:

```python
print("ID:", response.id)
print("Model:", response.model)
print("Role:", response.role)
print("Stop reason:", response.stop_reason)
print("Usage:", response.usage)
```

This helps you understand that Claude's response is a structured API object rather than simply a string.

---

# 41. Raw cURL Example

If you want to understand what the Python SDK is doing underneath, you can call the API directly.

```bash
curl https://api.anthropic.com/v1/messages \
  -H "Content-Type: application/json" \
  -H "anthropic-version: 2023-06-01" \
  -H "X-Api-Key: $ANTHROPIC_API_KEY" \
  -d '{
    "model": "YOUR_MODEL_ID",
    "max_tokens": 1024,
    "messages": [
      {
        "role": "user",
        "content": "Explain Docker in simple terms."
      }
    ]
  }'
```

The SDK is essentially giving you a more convenient programming interface over this HTTP API.

---

# 42. Python SDK vs Raw HTTP

| Approach         | Best for                                   |
| ---------------- | ------------------------------------------ |
| Python SDK       | Application development                    |
| cURL             | Learning/debugging HTTP                    |
| REST client      | API testing                                |
| Raw HTTP library | Custom integrations                        |
| SDK              | Recommended for normal Python applications |

For your first Python application:

```text
Use Python SDK
```

For understanding the underlying architecture:

```text
Learn cURL + HTTP
```

Both are valuable.

---

# 43. Request Anatomy

Memorize this structure:

```text
Messages API Request
│
├── Headers
│   ├── Content-Type
│   ├── anthropic-version
│   ├── X-Api-Key
│   └── anthropic-workspace-id (optional)
│
└── Body
    ├── model
    ├── max_tokens
    ├── system (optional)
    ├── messages
    │   ├── role
    │   └── content
    └── other optional features
```

---

# 44. Response Anatomy

Memorize this structure:

```text
Messages API Response
│
├── id
├── type
├── role
├── content
│   └── content blocks
├── model
├── stop_reason
├── stop_sequence
└── usage
    ├── input_tokens
    └── output_tokens
```

Additional fields can appear when advanced features are enabled.

---

# 45. Common Beginner Mistakes

## Mistake 1 — Using an old model ID

Bad:

```python
model="some-model-from-an-old-blog"
```

Better:

```python
models = client.models.list()

for model in models:
    print(model.id)
```

Then select a currently available model.

---

## Mistake 2 — Putting `system` inside messages

Incorrect:

```python
messages=[
    {
        "role": "system",
        "content": "You are a DevOps teacher."
    }
]
```

Correct:

```python
system="You are a DevOps teacher."
```

---

## Mistake 3 — Assuming `max_tokens` means exact output length

Incorrect understanding:

```text
max_tokens=1000
        =
Claude must generate 1000 tokens
```

Correct:

```text
max_tokens=1000
        =
Claude can generate at most 1000 tokens
```

---

## Mistake 4 — Treating `response.content` as a string

Avoid:

```python
print(response.content.upper())
```

Instead, extract the text block:

```python
text = "".join(
    block.text
    for block in response.content
    if block.type == "text"
)

print(text)
```

---

## Mistake 5 — Expecting Claude to remember previous API requests

This is wrong:

```text
Request 1:
What is Docker?

Request 2:
What are its advantages?
```

without sending the previous context.

Your application needs to manage conversation history.

---

## Mistake 6 — Copying old `temperature` examples

Old tutorials may contain:

```python
temperature=0
```

Current Anthropic documentation marks this parameter as deprecated for newer models.

Avoid it in new examples unless the model documentation explicitly supports it.

---

## Mistake 7 — Sending API keys directly in source code

Never do:

```python
client = anthropic.Anthropic(
    api_key="sk-ant-..."
)
```

in committed application code.

Use an environment variable:

```text
ANTHROPIC_API_KEY
```

---

# 46. Production Conversation Pattern

A real application might look like:

```text
                    ┌─────────────────┐
                    │      User       │
                    └────────┬────────┘
                             │
                             v
                    ┌─────────────────┐
                    │   Application   │
                    └────────┬────────┘
                             │
                  ┌──────────┴──────────┐
                  │                     │
                  v                     v
          Conversation Store       Application Logic
                  │                     │
                  └──────────┬──────────┘
                             │
                             v
                    ┌─────────────────┐
                    │ Messages API    │
                    └────────┬────────┘
                             │
                             v
                         Claude
```

The application is responsible for managing:

* Conversation history
* Authentication
* Model selection
* Context size
* Error handling
* Retries
* Cost controls
* Logging
* Security

---

# 47. Messages API in a RAG Application

This API becomes especially important when building RAG.

A simplified RAG architecture is:

```text
User Question
      |
      v
Application
      |
      v
Retriever
      |
      v
Vector Database
      |
      v
Relevant Documents
      |
      v
Prompt Construction
      |
      v
Messages API
      |
      v
Claude
      |
      v
Answer
```

The retrieved documents can become part of the request sent to Claude.

For example:

```text
System Instructions
+
Retrieved Context
+
User Question
```

then:

```text
Messages API
        |
        v
Claude
```

This is one of the most important patterns you will use later in your GenAI projects.

---

# 48. Messages API in Agentic AI

For an agent:

```text
User
 |
 v
Claude
 |
 +---- tool call
 |
 v
Application executes tool
 |
 v
Tool result
 |
 v
Claude
 |
 v
Final response
```

The Messages API supports tool-related content blocks and tool definitions.

For example, Claude can return a `tool_use` block, your application executes the requested tool, and the result can be sent back using a `tool_result` block.

Tool use deserves its own dedicated document and should not be mixed into the beginner Messages API lesson.

---

# 49. Messages API + System + User + Assistant

The core architecture can be remembered as:

```text
                 SYSTEM
                    |
                    v
          "How should Claude behave?"
                    |
                    v
USER --------------> Claude
                    |
                    v
              ASSISTANT
                    |
                    v
USER --------------> Claude
                    |
                    v
              ASSISTANT
```

The system prompt defines the overall behavior.

The messages represent the conversation.

Claude generates the next assistant response.

---

# 50. Beginner Checklist

Before moving forward, make sure you understand:

* [ ] What the Messages API is
* [ ] `POST /v1/messages`
* [ ] API authentication headers
* [ ] `model`
* [ ] `max_tokens`
* [ ] `messages`
* [ ] `user` role
* [ ] `assistant` role
* [ ] Top-level `system`
* [ ] Stateless conversations
* [ ] Conversation history
* [ ] Content blocks
* [ ] Text input
* [ ] Image input
* [ ] Response `content`
* [ ] `stop_reason`
* [ ] Token usage
* [ ] `count_tokens`
* [ ] Streaming concept
* [ ] Why old `temperature` examples can be problematic
* [ ] Why model IDs should not be blindly copied

---

# 51. Knowledge Check

### Question 1

What endpoint creates a Claude message?

<details>
<summary>Answer</summary>

```text
POST /v1/messages
```

</details>

---

### Question 2

Where should the system instruction go?

<details>
<summary>Answer</summary>

Use the top-level:

```python
system="..."
```

There is no `system` role for Messages API input messages.

</details>

---

### Question 3

Is the Messages API stateful?

<details>
<summary>Answer</summary>

No.

The API supports stateless multi-turn conversations. Your application supplies the conversation history.

</details>

---

### Question 4

What does `max_tokens` mean?

<details>
<summary>Answer</summary>

It specifies the maximum number of output tokens Claude can generate. It is not a guarantee that Claude will generate that many tokens.

</details>

---

### Question 5

Why shouldn't you blindly copy a model ID from an old tutorial?

<details>
<summary>Answer</summary>

Model availability and model IDs can change. Discover the models currently available to your account and choose from those.

</details>

---

### Question 6

Why is `response.content` not necessarily a plain string?

<details>
<summary>Answer</summary>

The response contains structured content blocks. A response may contain text and, depending on enabled capabilities, other block types.

</details>

---

# 52. Recommended Learning Order

Do not try to learn every advanced Messages API feature at once.

Use this order:

```text
1. Basic request
      ↓
2. System prompt
      ↓
3. Multi-turn conversation
      ↓
4. Response parsing
      ↓
5. Token usage
      ↓
6. Token counting
      ↓
7. Images
      ↓
8. Streaming
      ↓
9. Prompt caching
      ↓
10. Tool use
      ↓
11. Structured outputs
      ↓
12. Agents
```

This keeps the learning curve manageable.

---

# 53. What You Should Be Able to Explain in an Interview

You should eventually be able to answer:

### What is the Claude Messages API?

> It is Anthropic's API for sending structured messages to Claude and receiving generated responses.

### Is it stateful?

> The Messages API is stateless. For multi-turn conversations, the application sends the relevant conversation history with each request.

### What are the important request parameters?

```text
model
max_tokens
messages
system
```

along with optional features such as streaming, tools, stop sequences, and other model/API capabilities.

### Where is the system prompt specified?

```text
Top-level `system` parameter.
```

### What is the difference between `max_tokens` and output tokens?

```text
max_tokens = maximum allowed output
output_tokens = what Claude actually generated
```

### How do you maintain conversation history?

```text
Application stores previous turns
        ↓
Application sends relevant history
        ↓
Messages API
```

---

# 54. Official References

Always prefer Anthropic's current documentation over old tutorials.

* [Claude API — Create a Message](https://platform.claude.com/docs/en/api/messages/create)
* [Claude API — Python SDK](https://platform.claude.com/docs/en/cli-sdks-libraries/sdks/python)
* [Claude Vision](https://platform.claude.com/docs/en/build-with-claude/vision)
* [Prompt Engineering Overview](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview)

---

# 55. Final Mental Model

If you remember only one diagram from this document, remember this:

```text
                 YOUR APPLICATION
                        |
                        |
              ┌─────────┴─────────┐
              |                   |
        System Prompt       Conversation
              |                History
              |                   |
              └─────────┬─────────┘
                        |
                        v
               Messages API
                        |
               POST /v1/messages
                        |
                        v
                   CLAUDE MODEL
                        |
                        v
                 Structured Response
                        |
             ┌──────────┼──────────┐
             |          |          |
           Text       Usage    Stop Reason
             |
             v
          Your User
```

The fundamental pattern is:

```text
Input
  ↓
Messages API
  ↓
Claude
  ↓
Structured Response
```

Everything else — RAG, agents, tool use, vision, streaming, structured outputs, and production applications — builds on this foundation.
