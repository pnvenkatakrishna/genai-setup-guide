# Claude Python SDK

> Learn how the official Anthropic Python SDK works, how to create a client, make Messages API requests, understand responses, handle errors, configure retries and timeouts, and build a clean foundation for Claude applications.

---

# 1. Goal

In the previous document, we prepared the Python environment.

We now move from:

```text
Python Environment
       ↓
Anthropic SDK Installed
       ↓
API Key Configured
```

to:

```text
Python Application
       ↓
Anthropic Python SDK
       ↓
Claude API
       ↓
Claude Model
       ↓
Response
```

By the end of this document, you will understand:

* What an SDK is
* Why Anthropic provides an SDK
* How the Python SDK works
* `Anthropic()`
* `client.messages.create()`
* The Messages API
* `model`
* `max_tokens`
* `messages`
* `system`
* User and assistant messages
* Response objects
* Text content blocks
* Request IDs
* Error handling
* Retries
* Timeouts
* Synchronous requests
* Asynchronous requests
* Streaming
* Basic SDK logging
* Workspace selection
* Clean SDK project structure

---

# 2. What Is an SDK?

SDK means:

> **Software Development Kit**

An SDK provides programming libraries and tools that make it easier to communicate with a service.

Without an SDK, you can communicate with the Claude API directly using HTTP.

Conceptually:

```text
Python
   │
   ▼
HTTP Request
   │
   ▼
Claude API
```

With the official SDK:

```text
Python
   │
   ▼
Anthropic SDK
   │
   ▼
Claude API
```

The SDK handles many HTTP-level details for you.

---

# 3. Why Use the Official Anthropic SDK?

You could manually build HTTP requests using:

```text
requests
httpx
curl
Postman
```

But the official SDK provides:

* Typed request/response objects
* Authentication handling
* API methods
* Error classes
* Retry behavior
* Timeout configuration
* Streaming helpers
* Async support
* Request ID access
* Better developer experience

Anthropic's official Python SDK is designed specifically for Claude API applications.

---

# 4. Install the SDK

If you completed the previous document, you should already have:

```powershell
python -m pip install anthropic
```

Verify:

```powershell
python -c "import anthropic; print(anthropic.__version__)"
```

The current SDK requires:

```text
Python 3.10+
```

Anthropic documents `pip install anthropic` as the standard installation method.

---

# 5. Import the SDK

The basic import is:

```python
from anthropic import Anthropic
```

Then:

```python
client = Anthropic()
```

The client represents your connection to the Claude API.

---

# 6. What Is the Client?

Think of the client as the main interface between your application and Anthropic.

```text
Your Python Code
       │
       ▼
Anthropic()
       │
       ▼
Claude API
```

Example:

```python
from anthropic import Anthropic

client = Anthropic()
```

Now the application has a Claude API client.

---

# 7. API Key Handling

The SDK can read:

```text
ANTHROPIC_API_KEY
```

from the environment.

Therefore, this is enough:

```python
from anthropic import Anthropic

client = Anthropic()
```

You do not need to hard-code the API key.

The current SDK documentation explicitly supports the environment-variable approach.

---

# 8. Explicit API Key

The SDK also allows:

```python
import os
from anthropic import Anthropic

client = Anthropic(
    api_key=os.environ.get("ANTHROPIC_API_KEY")
)
```

This makes the authentication flow explicit.

However, for normal development:

```python
client = Anthropic()
```

is cleaner when `ANTHROPIC_API_KEY` is already configured.

---

# 9. Never Hard-Code a Real Key

Never do this:

```python
client = Anthropic(
    api_key="sk-ant-api03-REAL_SECRET"
)
```

Instead:

```python
client = Anthropic()
```

with:

```text
ANTHROPIC_API_KEY
```

configured securely.

---

# 10. The Messages API

The main API we will use is the **Messages API**.

The underlying HTTP endpoint is:

```text
POST /v1/messages
```

The Messages API accepts structured input messages and generates a response from the selected model.

Conceptually:

```text
Your Application
       │
       │ POST /v1/messages
       ▼
Claude API
       │
       ▼
Claude Model
       │
       ▼
Message Response
```

---

# 11. First SDK Request

The basic Python pattern is:

```python
from anthropic import Anthropic

client = Anthropic()

message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=1024,
    messages=[
        {
            "role": "user",
            "content": "Hello, Claude!",
        }
    ],
)

print(message.content)
```

The current SDK documentation uses this same `client.messages.create(...)` pattern.

---

# 12. Why We Use `YOUR_MODEL_ID`

Model IDs change over time.

Therefore, this repository should not assume that one model ID will remain current forever.

Instead:

```text
YOUR_MODEL_ID
```

means:

> Replace this with a model currently available to your organization.

You can discover available models programmatically:

```python
models = client.models.list()

for model in models:
    print(model.id)
```

The current Python API reference provides `models.list()` and `models.retrieve()`.

---

# 13. Discover Available Models

Create:

```text
list_models.py
```

Use:

```python
from anthropic import Anthropic

client = Anthropic()

models = client.models.list()

for model in models:
    print(model.id)
```

Run:

```powershell
python list_models.py
```

You will receive the models currently available to your credentials.

This is better than blindly copying an old model ID from a tutorial.

---

# 14. Model Selection

A model is the Claude model that processes your request.

Conceptually:

```text
Application
     │
     ▼
Messages API
     │
     ├── model
     │
     ▼
Selected Claude Model
     │
     ▼
Response
```

Different models can have different:

* Capabilities
* Context limits
* Speed
* Pricing
* Availability

Always check the current official model documentation before choosing a model for production.

---

# 15. `max_tokens`

Example:

```python
max_tokens=1024
```

This specifies the maximum number of output tokens the model may generate.

It is an upper limit, not a guarantee that Claude will generate that many tokens.

For example:

```text
max_tokens = 1024
```

means:

```text
Generate at most 1024 output tokens
```

The model may stop earlier.

The Messages API documentation defines `max_tokens` as the maximum number of tokens to generate before stopping.

---

# 16. `messages`

The `messages` parameter contains the conversational input.

Example:

```python
messages=[
    {
        "role": "user",
        "content": "Explain Docker in simple terms.",
    }
]
```

Conceptually:

```text
messages
   │
   └── message
         ├── role
         └── content
```

---

# 17. The `user` Role

A normal user message looks like:

```python
{
    "role": "user",
    "content": "What is Kubernetes?",
}
```

This represents input from the user.

---

# 18. The `assistant` Role

A conversation can contain previous assistant messages as part of the input history.

Example:

```python
messages=[
    {
        "role": "user",
        "content": "What is Docker?",
    },
    {
        "role": "assistant",
        "content": "Docker is a container platform.",
    },
    {
        "role": "user",
        "content": "Why do we need it?",
    },
]
```

This allows your application to send conversation history.

The Messages API is stateless: your application is responsible for providing the relevant conversation history in the request.

---

# 19. There Is No `system` Role in `messages`

This is an important Claude API concept.

Do not write:

```python
messages=[
    {
        "role": "system",
        "content": "You are a helpful assistant.",
    }
]
```

Instead, Claude uses a top-level:

```python
system=
```

parameter.

For example:

```python
message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=1024,
    system="You are a helpful DevOps teacher.",
    messages=[
        {
            "role": "user",
            "content": "Explain Kubernetes.",
        }
    ],
)
```

The official Messages API documentation explicitly states that system instructions use the top-level `system` parameter rather than a `"system"` message role.

---

# 20. `system` Instructions

A system prompt defines high-level instructions for Claude.

Example:

```python
system="You are an expert DevOps instructor. Explain concepts using simple examples."
```

Architecture:

```text
System Instructions
       │
       ▼
Claude
       ▲
       │
User Message
```

We will study system prompts in detail in a later document.

---

# 21. Basic Complete Example

Create:

```text
main.py
```

Use:

```python
from anthropic import Anthropic


client = Anthropic()

message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=512,
    system="You are a helpful technical teacher.",
    messages=[
        {
            "role": "user",
            "content": "Explain what an API is in simple English.",
        }
    ],
)

for block in message.content:
    if block.type == "text":
        print(block.text)
```

The current SDK examples use this pattern of iterating through response content blocks and reading text blocks.

---

# 22. Why Iterate Through `message.content`?

The response is not simply a string.

Conceptually:

```text
message
   │
   └── content
         │
         ├── text block
         ├── tool-use block
         ├── thinking block
         └── other supported content
```

Therefore, this is not the most robust approach:

```python
print(message.content)
```

Instead:

```python
for block in message.content:
    if block.type == "text":
        print(block.text)
```

This makes your application aware that responses can contain different block types.

---

# 23. Understanding the Response

A Message response contains information about the generated message.

Conceptually:

```text
Message
│
├── id
├── type
├── role
├── content
├── model
├── stop_reason
├── stop_sequence
└── usage
```

The exact response structure depends on the current API features and model.

The Python SDK converts the API response into typed objects.

---

# 24. Message ID

A response contains a message ID.

Conceptually:

```python
print(message.id)
```

The ID can be useful for debugging and tracing.

Do not confuse:

```text
Message ID
```

with:

```text
Request ID
```

They serve different purposes.

---

# 25. Request ID

The API response contains a unique request ID.

The Python SDK exposes it through:

```python
message._request_id
```

Example:

```python
print(message._request_id)
```

A request ID may look similar to:

```text
req_018...
```

Anthropic documents `_request_id` as a public SDK property specifically useful for debugging and support.

---

# 26. Why Request IDs Matter

Suppose your application reports:

```text
API request failed
```

That is not very useful to support engineers.

A request ID provides a precise reference:

```text
Request failed
     │
     └── request-id: req_...
```

If you contact Anthropic support about a particular request, include the request ID.

Anthropic's error documentation specifically recommends using the request ID when investigating individual requests.

---

# 27. Usage Information

The response also contains usage information.

For example, you can inspect:

```python
print(message.usage)
```

Depending on the current response schema, usage can include token accounting information.

Conceptually:

```text
Request
   │
   ├── Input tokens
   │
   └── Output tokens
```

Usage information is important for:

* Cost monitoring
* Performance analysis
* Debugging
* Application optimization

---

# 28. Stop Reason

Claude can stop generation for different reasons.

The response includes a stop reason.

Conceptually:

```text
stop_reason
     │
     ├── Natural completion
     ├── max_tokens
     ├── Tool use
     └── Other API-defined conditions
```

Do not assume every response ended because Claude naturally finished.

When building advanced applications, inspect the stop reason.

---

# 29. First Production-Style Response Handler

A cleaner helper function:

```python
from anthropic import Anthropic


client = Anthropic()


def extract_text(message) -> str:
    parts = []

    for block in message.content:
        if block.type == "text":
            parts.append(block.text)

    return "".join(parts)


message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=512,
    messages=[
        {
            "role": "user",
            "content": "Explain Git in simple terms.",
        }
    ],
)

print(extract_text(message))
```

This separates:

```text
API request
```

from:

```text
Response extraction
```

That becomes useful as the application grows.

---

# 30. Error Handling

API requests can fail.

Never assume:

```python
message = client.messages.create(...)
```

will always succeed.

The official Python SDK raises typed exceptions for API errors.

---

# 31. Basic Error Handling

Use:

```python
import anthropic
from anthropic import Anthropic


client = Anthropic()

try:
    message = client.messages.create(
        model="YOUR_MODEL_ID",
        max_tokens=512,
        messages=[
            {
                "role": "user",
                "content": "Hello, Claude!",
            }
        ],
    )

    for block in message.content:
        if block.type == "text":
            print(block.text)

except anthropic.APIConnectionError:
    print("Could not connect to the Claude API.")

except anthropic.APIStatusError as error:
    print(f"API error: {error.status_code}")
```

---

# 32. Common SDK Error Classes

The current Python SDK documents typed exceptions corresponding to API failures:

|               HTTP | Python exception           |
| -----------------: | -------------------------- |
|                400 | `BadRequestError`          |
|                401 | `AuthenticationError`      |
|                403 | `PermissionDeniedError`    |
|                404 | `NotFoundError`            |
|                409 | `ConflictError`            |
|                422 | `UnprocessableEntityError` |
|                429 | `RateLimitError`           |
|               500+ | `InternalServerError`      |
| Connection failure | `APIConnectionError`       |

The SDK documentation recommends catching specific exception classes where appropriate.

---

# 33. Authentication Error

Example:

```text
401
```

Usually indicates an authentication problem.

Possible causes:

* Invalid API key
* Expired key
* Disabled key
* Incorrect environment variable
* Wrong credentials

Check:

```text
ANTHROPIC_API_KEY
```

before changing application code.

---

# 34. Permission Error

Example:

```text
403
```

Authentication may have succeeded, but the identity may not have permission to perform the requested operation.

Possible causes include:

* Workspace permissions
* Organization permissions
* Feature access
* Credential scope

---

# 35. Rate Limit Error

Example:

```text
429
```

This means the request was rate-limited.

The SDK automatically retries certain transient errors, including rate limits, by default. The current default is **2 retries** with exponential backoff.

---

# 36. Server Errors

Examples:

```text
500
529
```

These can represent temporary service-side problems.

The official SDK automatically retries certain transient failures.

Do not implement another aggressive retry loop without understanding the SDK's existing retry behavior.

---

# 37. Retry Configuration

The SDK defaults to:

```text
2 retries
```

for supported transient failures.

You can configure:

```python
client = Anthropic(
    max_retries=5
)
```

Or configure a particular request:

```python
message = client.with_options(
    max_retries=5
).messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=512,
    messages=[
        {
            "role": "user",
            "content": "Hello!",
        }
    ],
)
```

The SDK documentation describes both client-level and per-request retry configuration.

---

# 38. Why Retries Matter

Imagine:

```text
Application
     │
     ▼
Claude API
     │
     ▼
Temporary 500 error
```

Without retry:

```text
Request fails
```

With controlled retry:

```text
Request
   ↓
Temporary failure
   ↓
Backoff
   ↓
Retry
   ↓
Success
```

However:

> Retries should be controlled.

Too many retries can increase:

* Latency
* Load
* Cost
* Complexity

---

# 39. Timeouts

The current Python SDK has a default request timeout of **10 minutes**.

You can configure it.

Example:

```python
client = Anthropic(
    timeout=20.0
)
```

This means:

```text
20 seconds
```

The SDK raises `APITimeoutError` when a configured request times out.

---

# 40. Why Timeouts Matter

A network request can hang because of:

* Network problems
* Slow processing
* Long-running generation
* Proxy issues
* Infrastructure problems

Without sensible timeout handling:

```text
Application
   │
   ▼
Waiting...
   │
   ▼
Waiting...
   │
   ▼
Waiting...
```

A timeout provides a boundary.

---

# 41. Timeout Example

```python
from anthropic import Anthropic

client = Anthropic(
    timeout=60.0
)
```

This configures the client timeout.

For production systems, choose the timeout based on your application's latency requirements rather than blindly copying a value.

---

# 42. Long Requests and Streaming

For long-running requests, Anthropic recommends considering streaming.

Without streaming:

```text
Request
   │
   ▼
Claude generates everything
   │
   ▼
Complete response
   │
   ▼
Application receives response
```

With streaming:

```text
Request
   │
   ▼
Claude
   │
   ├── chunk
   ├── chunk
   ├── chunk
   ├── chunk
   └── final
```

The Python SDK supports streaming through the Messages API.

---

# 43. Simple Streaming Example

```python
from anthropic import Anthropic


client = Anthropic()

with client.messages.stream(
    model="YOUR_MODEL_ID",
    max_tokens=1024,
    messages=[
        {
            "role": "user",
            "content": "Explain Kubernetes in detail.",
        }
    ],
) as stream:

    for text in stream.text_stream:
        print(text, end="", flush=True)
```

This allows text to appear incrementally.

---

# 44. Why Streaming Improves User Experience

Without streaming:

```text
User
 │
 └── waits...
       waits...
       waits...
       waits...
       ↓
    Complete answer
```

With streaming:

```text
User
 │
 ├── "Kubernetes"
 ├── " is a..."
 ├── " container..."
 ├── " orchestration..."
 └── ...
```

The user starts seeing the response sooner.

Streaming does not necessarily mean the model completes faster; it changes how the response is delivered.

---

# 45. Streaming vs Normal Requests

### Normal request

Use when:

* Response is short
* You need the complete response object
* Simplicity is important

### Streaming

Use when:

* Response may be long
* User experience matters
* You want incremental output
* Long-running generation is expected

---

# 46. Async Python

The SDK also provides:

```python
AsyncAnthropic
```

for asynchronous applications.

Example:

```python
import asyncio

from anthropic import AsyncAnthropic


async def main():
    client = AsyncAnthropic()

    message = await client.messages.create(
        model="YOUR_MODEL_ID",
        max_tokens=512,
        messages=[
            {
                "role": "user",
                "content": "Explain asynchronous programming.",
            }
        ],
    )

    for block in message.content:
        if block.type == "text":
            print(block.text)


asyncio.run(main())
```

The current SDK supports both synchronous and asynchronous clients.

---

# 47. When Should You Use Async?

Use synchronous code first when learning.

```text
Learning
   ↓
Anthropic()
   ↓
client.messages.create()
```

Move to async when your application needs concurrency.

For example:

```text
Web application
      │
      ├── Request A
      ├── Request B
      ├── Request C
      └── Request D
```

Async programming can allow your application to manage concurrent I/O more efficiently.

---

# 48. Sync vs Async

| Approach        | Client                       | Best starting point |
| --------------- | ---------------------------- | ------------------- |
| Synchronous     | `Anthropic`                  | Yes                 |
| Asynchronous    | `AsyncAnthropic`             | Later               |
| Streaming       | `messages.stream()`          | After basic API     |
| Async streaming | `AsyncAnthropic` + streaming | Advanced            |

Learn the synchronous API first.

---

# 49. Workspace Selection

If your API credential can access multiple Workspaces, the request can specify:

```text
anthropic-workspace-id
```

The value is the Workspace ID.

For credentials already tied to a specific Workspace, the header can generally be omitted.

The current Messages API reference documents this behavior.

---

# 50. Why Workspace Selection Matters

Imagine:

```text
Organization
│
├── Development
├── Testing
└── Production
```

Your identity can access multiple Workspaces.

A request needs to know:

```text
Which Workspace should receive this usage?
```

Therefore:

```text
API Key
   │
   ▼
Workspace Selection
   │
   ▼
Claude API
```

This becomes important for organizational usage and cost tracking.

---

# 51. SDK Logging

The SDK uses Python's standard `logging` module.

Anthropic documents an environment variable:

```text
ANTHROPIC_LOG
```

which can be set to:

```text
debug
```

or:

```text
info
```

Example in PowerShell:

```powershell
$env:ANTHROPIC_LOG="debug"
```

Use debug logging carefully.

Never expose API keys or sensitive application data in logs.

Anthropic documents SDK logging configuration in the Python SDK documentation.

---

# 52. Raw Response Access

Advanced applications may need HTTP response headers.

The SDK supports:

```python
client.messages.with_raw_response.create(...)
```

Example:

```python
response = client.messages.with_raw_response.create(
    model="YOUR_MODEL_ID",
    max_tokens=512,
    messages=[
        {
            "role": "user",
            "content": "Hello!",
        }
    ],
)

print(response.headers.get("request-id"))

message = response.parse()
```

This is an advanced feature.

For normal applications:

```python
client.messages.create(...)
```

is sufficient.

The current SDK documentation describes `with_raw_response` for accessing headers and raw response data.

---

# 53. SDK Architecture

The Python SDK can be understood as:

```text
Your Python Code
       │
       ▼
Anthropic Client
       │
       ├── Authentication
       ├── HTTP communication
       ├── Serialization
       ├── Response parsing
       ├── Error handling
       ├── Retries
       └── Timeouts
       │
       ▼
Claude API
       │
       ▼
Messages API
       │
       ▼
Claude Model
```

This is why using the official SDK is usually easier than manually implementing every HTTP detail.

---

# 54. Minimal Claude Application

At this point, the cleanest beginner application is:

```python
from anthropic import Anthropic


client = Anthropic()

message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=512,
    messages=[
        {
            "role": "user",
            "content": "Explain DevOps in simple English.",
        }
    ],
)

for block in message.content:
    if block.type == "text":
        print(block.text)
```

This is the fundamental Claude Python pattern.

---

# 55. A Better Application Structure

Instead of putting everything into one file:

```text
main.py
```

a growing application can become:

```text
claude-api-demo/
│
├── .env
├── .env.example
├── .gitignore
├── requirements.txt
│
├── app/
│   ├── __init__.py
│   ├── client.py
│   ├── prompts.py
│   └── main.py
│
└── tests/
    └── test_client.py
```

We do not need this complexity for the first request.

Start simple.

---

# 56. Recommended Development Progression

Follow this sequence:

```text
1. Create client
      ↓
2. Send one message
      ↓
3. Read response
      ↓
4. Add system instructions
      ↓
5. Handle errors
      ↓
6. Inspect usage
      ↓
7. Add request IDs
      ↓
8. Add streaming
      ↓
9. Add async
      ↓
10. Build application architecture
```

Do not start with Agents or RAG before understanding the basic Messages API.

---

# 57. Common Beginner Mistakes

## Mistake 1 — Wrong API key

```text
ANTHROPIC_API_KEY
```

must contain the correct credential.

---

## Mistake 2 — Wrong Python environment

Always check:

```powershell
python -c "import sys; print(sys.executable)"
```

---

## Mistake 3 — Hard-coded API key

Never commit secrets.

---

## Mistake 4 — Old model ID

Do not blindly copy model IDs from old tutorials.

Use the current model documentation or:

```python
client.models.list()
```

---

## Mistake 5 — Treating response as a string

Do not assume:

```python
message.content
```

is always one simple string.

Handle content blocks.

---

## Mistake 6 — Ignoring errors

Always add appropriate error handling as the application becomes more important.

---

## Mistake 7 — Implementing duplicate retries

The SDK already retries certain transient errors by default.

Understand the SDK's retry behavior before adding your own retry loop.

---

# 58. Environment Verification

Before making your first API request, confirm:

```text
Python
   ↓
.venv
   ↓
anthropic package
   ↓
ANTHROPIC_API_KEY
   ↓
Anthropic()
```

Run:

```powershell
python -c "from anthropic import Anthropic; print('Anthropic SDK import successful')"
```

Then:

```powershell
python -c "import os; print('API key configured' if os.getenv('ANTHROPIC_API_KEY') else 'API key missing')"
```

---

# 59. API Verification Comes Next

The previous checks prove:

```text
Python works
SDK works
Environment variable exists
```

They do **not** prove:

```text
API key is valid
Billing works
Workspace access works
Claude API request works
```

The next document will perform the actual API call.

---

# 60. Knowledge Check

You should now be able to answer:

### Q1. What is an SDK?

A software development kit that simplifies integration with a service.

### Q2. What Python package provides the official Claude SDK?

```text
anthropic
```

### Q3. What is the main client?

```python
Anthropic()
```

### Q4. What method creates a Claude message?

```python
client.messages.create()
```

### Q5. What API endpoint does it use?

```text
POST /v1/messages
```

### Q6. Where does the system prompt go?

```python
system="..."
```

not as a `"system"` role inside `messages`.

### Q7. What does `max_tokens` control?

The maximum number of output tokens generated.

### Q8. What environment variable is used for the API key?

```text
ANTHROPIC_API_KEY
```

### Q9. What property provides the request ID?

```python
message._request_id
```

### Q10. Does the SDK automatically retry some transient failures?

Yes. The current default is two retries for supported transient failures.

---

# 61. Verification Checklist

Before moving on:

* [ ] Anthropic SDK installed
* [ ] `Anthropic()` works
* [ ] `ANTHROPIC_API_KEY` is configured
* [ ] I understand `client.messages.create()`
* [ ] I understand `model`
* [ ] I understand `max_tokens`
* [ ] I understand `messages`
* [ ] I understand `user` and `assistant` roles
* [ ] I understand the top-level `system` parameter
* [ ] I understand response content blocks
* [ ] I know how to extract text
* [ ] I understand request IDs
* [ ] I understand basic SDK errors
* [ ] I understand retries
* [ ] I understand timeouts
* [ ] I understand streaming at a high level
* [ ] I understand sync vs async
* [ ] I know how Workspace selection works

---

# 62. Official References

Always use the current official documentation when API behavior changes.

* [Anthropic Python SDK](https://platform.claude.com/docs/en/cli-sdks-libraries/sdks/python)
* [Python API Reference](https://platform.claude.com/docs/en/api/python)
* [Create a Message](https://platform.claude.com/docs/en/api/messages/create)
* [Claude API Errors](https://platform.claude.com/docs/en/api/errors)
* [Streaming Messages](https://platform.claude.com/docs/en/build-with-claude/streaming)
* [Authentication](https://platform.claude.com/docs/en/manage-claude/authentication)

---

# 63. Next Step

We now understand the SDK.

The next document will make the **first real Claude API request**.

Sequence:

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

Next file:

```text
docs/07-first-api-request.md
```

That document will take the project from:

```text
SDK installed
```

to:

```text
Python
  ↓
Anthropic SDK
  ↓
Claude API
  ↓
Claude Model
  ↓
Real Response
```

It will include the complete working example, model discovery, request verification, response inspection, error diagnosis, request ID, usage, and a clean first project implementation.
