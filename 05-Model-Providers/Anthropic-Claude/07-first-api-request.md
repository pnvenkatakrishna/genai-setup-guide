# First Claude API Request

> Make your first real request to Claude using the official Anthropic Python SDK, verify the response, inspect usage and request metadata, and learn how to diagnose the most common failures.

---

# 1. Goal

Previous documents prepared:

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
```

Now we will make the first real API request:

```text
Python Application
       │
       ▼
Anthropic Python SDK
       │
       ▼
Claude API
       │
       ▼
Claude Model
       │
       ▼
Response
```

By the end of this guide, you will be able to:

* Select an available Claude model
* Make a real API request
* Understand `messages.create()`
* Understand `model`
* Understand `max_tokens`
* Understand `messages`
* Read the response
* Extract text safely
* Inspect token usage
* Inspect the request ID
* Inspect the stop reason
* Handle common API errors
* Diagnose authentication failures
* Diagnose billing failures
* Diagnose rate limits
* Understand Workspace selection
* Build a clean first Claude application

---

# 2. Prerequisites

You should already have:

* Python 3.10+
* A Python virtual environment
* `anthropic` installed
* `python-dotenv` installed if using `.env`
* A Claude API key
* `ANTHROPIC_API_KEY` configured
* Claude Console billing configured
* A Workspace with API access

Verify the SDK:

```powershell
python -c "import anthropic; print(anthropic.__version__)"
```

Verify the environment variable without printing the secret:

```powershell
python -c "import os; print('API key configured' if os.getenv('ANTHROPIC_API_KEY') else 'API key missing')"
```

---

# 3. Activate the Environment

On Windows PowerShell:

```powershell
cd claude-api-demo
.\.venv\Scripts\Activate.ps1
```

You should see:

```text
(.venv)
```

in your terminal prompt.

Verify:

```powershell
python -c "import sys; print(sys.executable)"
```

The path should point to:

```text
.venv\Scripts\python.exe
```

---

# 4. Understand What We Are About to Do

The request flow is:

```text
Your Python Code
       │
       ▼
Anthropic()
       │
       ▼
client.messages.create()
       │
       ▼
POST /v1/messages
       │
       ▼
Claude API
       │
       ▼
Selected Model
       │
       ▼
Message Response
```

The current Claude API uses:

```text
POST /v1/messages
```

for the Messages API.

---

# 5. First: Discover Available Models

Do not blindly copy a model ID from an old tutorial.

Model availability changes.

The current API provides:

```text
GET /v1/models
```

and the Python SDK exposes:

```python
client.models.list()
```

for discovering available models.

Create:

```text
list_models.py
```

---

# 6. `list_models.py`

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

You should receive model IDs available to your credentials.

The exact list can vary based on the current Claude platform and access available to your organization.

---

# 7. Why Model Discovery Is Important

Avoid documentation like:

```python
model="some-old-model-id"
```

without checking whether that model is still available.

Instead:

```text
Current API
     │
     ▼
models.list()
     │
     ▼
Available models
     │
     ▼
Choose a supported model
```

This makes your learning process less dependent on outdated tutorials.

---

# 8. Selecting a Model

For this tutorial, select a model ID returned by:

```python
client.models.list()
```

For example:

```text
YOUR_MODEL_ID
```

means:

> Replace this placeholder with a currently available model ID from your environment.

The current Anthropic Python SDK documentation uses `claude-opus-5-5` in its examples, but model IDs and availability can change, so this repository deliberately teaches model discovery rather than permanently assuming one model.

---

# 9. Create `main.py`

Create:

```text
main.py
```

Start with:

```python
from anthropic import Anthropic


client = Anthropic()

message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=512,
    messages=[
        {
            "role": "user",
            "content": "Explain what an API is in simple English.",
        }
    ],
)

print(message)
```

Replace:

```text
YOUR_MODEL_ID
```

with an available model ID.

---

# 10. Run the Application

Run:

```powershell
python main.py
```

If everything is configured correctly:

```text
Python
   ↓
Anthropic SDK
   ↓
Authentication
   ↓
Claude API
   ↓
Model
   ↓
Response
```

You should receive a Message response.

Congratulations.

At this point, your local Python application has successfully communicated with Claude.

---

# 11. What Just Happened?

Let's break the request down.

```python
message = client.messages.create(
```

means:

> Ask the Anthropic SDK to create a new Claude message.

Then:

```python
model="YOUR_MODEL_ID"
```

selects the Claude model.

Then:

```python
max_tokens=512
```

sets the maximum output token limit.

Then:

```python
messages=[
```

provides the conversation input.

The request ultimately becomes an API call to:

```text
POST /v1/messages
```

The Messages API accepts structured input messages and generates the next message.

---

# 12. The Request Anatomy

Our request:

```python
message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=512,
    messages=[
        {
            "role": "user",
            "content": "Explain what an API is in simple English.",
        }
    ],
)
```

can be visualized as:

```text
messages.create()
│
├── model
│
├── max_tokens
│
└── messages
      │
      └── user
            │
            └── content
```

---

# 13. `model`

Example:

```python
model="YOUR_MODEL_ID"
```

This identifies which Claude model should process the request.

Do not think of:

```text
Claude
```

as one single model.

Claude is a model family with multiple models.

The available models can be discovered through:

```python
client.models.list()
```

---

# 14. `max_tokens`

Example:

```python
max_tokens=512
```

This is the maximum number of output tokens Claude may generate before stopping.

It does **not** mean:

```text
Claude must generate exactly 512 tokens
```

Instead:

```text
max_tokens = upper limit
```

The model may stop before reaching that limit.

---

# 15. `messages`

Example:

```python
messages=[
    {
        "role": "user",
        "content": "Explain Docker.",
    }
]
```

This represents the input conversation.

The API supports single-turn requests as well as stateless multi-turn conversations.

---

# 16. `role`

A message contains:

```python
{
    "role": "user",
    "content": "Hello"
}
```

The role identifies who produced the message.

Common conversational roles are:

```text
user
assistant
```

For example:

```python
messages=[
    {
        "role": "user",
        "content": "What is Docker?",
    },
    {
        "role": "assistant",
        "content": "Docker is a platform for building and running containers.",
    },
    {
        "role": "user",
        "content": "Why are containers useful?",
    },
]
```

The application provides the previous conversation history.

---

# 17. Claude API Is Stateless

This is an extremely important concept.

Suppose the user says:

```text
User:
What is Docker?
```

Then later:

```text
User:
Why is it useful?
```

Claude does not automatically know the previous message merely because it was sent earlier.

Your application needs to provide the relevant conversation history.

Conceptually:

```text
Application
   │
   ├── User: What is Docker?
   ├── Assistant: Docker is...
   └── User: Why is it useful?
            │
            ▼
       Claude API
```

The Messages API is designed for stateless multi-turn conversations, where the application sends the conversation history.

---

# 18. Extract the Actual Text

Printing:

```python
print(message)
```

is useful for debugging, but not ideal for a user-facing application.

A Message contains structured content blocks.

Use:

```python
for block in message.content:
    if block.type == "text":
        print(block.text)
```

This is the pattern shown in the current Python SDK documentation.

---

# 19. Clean First Application

Update `main.py`:

```python
from anthropic import Anthropic


client = Anthropic()

message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=512,
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

Run:

```powershell
python main.py
```

Now the terminal displays the generated text rather than the entire response object.

---

# 20. Add a System Instruction

You can provide higher-level instructions using:

```python
system=
```

Example:

```python
message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=512,
    system="You are a friendly technical teacher. Explain concepts using simple examples.",
    messages=[
        {
            "role": "user",
            "content": "Explain Kubernetes.",
        }
    ],
)
```

The `system` instruction is separate from the `messages` list.

---

# 21. Complete First Teaching Example

```python
from anthropic import Anthropic


client = Anthropic()

message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=512,
    system=(
        "You are a friendly DevOps teacher. "
        "Explain technical concepts in simple English "
        "and include one practical example."
    ),
    messages=[
        {
            "role": "user",
            "content": "What is Docker?",
        }
    ],
)

for block in message.content:
    if block.type == "text":
        print(block.text)
```

This is a useful first real-world example because it demonstrates:

```text
Model
System instruction
User message
Response
```

---

# 22. Inspect the Response

For learning, inspect:

```python
print(message)
```

You will see structured information including fields such as:

```text
id
type
role
content
model
stop_reason
usage
```

The exact representation can vary with SDK versions.

---

# 23. Message ID

You can inspect:

```python
print(message.id)
```

The Message ID identifies the generated message.

It is useful when debugging application behavior.

---

# 24. Request ID

The SDK exposes the API request ID through:

```python
print(message._request_id)
```

The current Python SDK documents `_request_id` as a public property populated from the API's `request-id` response header.

Example:

```python
print("Request ID:", message._request_id)
```

---

# 25. Why Request IDs Matter

Imagine your application reports:

```text
Something went wrong.
```

That is difficult to investigate.

A request ID gives you a specific request reference:

```text
Request failed
      │
      └── Request ID: req_...
```

When investigating a specific API request, keep the request ID.

Anthropic's SDK documentation specifically recommends it for debugging and support.

---

# 26. Inspect Usage

You can inspect usage:

```python
print(message.usage)
```

For example, the SDK can expose token counts such as:

```text
input_tokens
output_tokens
```

The current SDK documentation demonstrates:

```python
print(message.usage)
```

for inspecting request usage.

---

# 27. Why Usage Matters

Usage information is important for:

```text
Cost
Performance
Debugging
Optimization
Capacity planning
```

Think:

```text
Prompt
   ↓
Input tokens
   ↓
Model processing
   ↓
Output tokens
   ↓
Usage
   ↓
Cost
```

This becomes especially important when building Agents and RAG systems.

---

# 28. Inspect the Stop Reason

You can inspect:

```python
print(message.stop_reason)
```

The stop reason tells you why generation stopped.

For example, Claude may finish naturally or stop because it reached the configured output limit.

This becomes particularly important when building:

* Tool use
* Agents
* Structured workflows
* Long responses

---

# 29. A Useful Debugging Version

For learning, use:

```python
from anthropic import Anthropic


client = Anthropic()

message = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=512,
    messages=[
        {
            "role": "user",
            "content": "Explain what an API is in simple English.",
        }
    ],
)

print("=== RESPONSE ===")

for block in message.content:
    if block.type == "text":
        print(block.text)

print("\n=== METADATA ===")
print("Message ID:", message.id)
print("Request ID:", message._request_id)
print("Model:", message.model)
print("Stop reason:", message.stop_reason)
print("Usage:", message.usage)
```

This is excellent for learning because you can see what Claude actually returned.

---

# 30. Production Output Should Be Cleaner

Do not necessarily print all metadata to the end user.

For a real application:

```text
User
  ↓
Application
  ↓
Claude API
  ↓
Response
  ↓
User
```

Internally, your application may record:

```text
request_id
usage
latency
model
errors
```

while showing only:

```text
Claude response
```

to the user.

---

# 31. Add Error Handling

A real application must expect failures.

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
                "content": "Explain Docker.",
            }
        ],
    )

    for block in message.content:
        if block.type == "text":
            print(block.text)

except anthropic.APIConnectionError:
    print("Could not connect to the Claude API.")

except anthropic.AuthenticationError:
    print("Authentication failed. Check the API key.")

except anthropic.RateLimitError:
    print("Rate limit reached. Try again later.")

except anthropic.APIStatusError as error:
    print(f"Claude API returned HTTP {error.status_code}.")
```

The current Python SDK documents these typed exceptions.

---

# 32. Understand the Error Categories

A useful mental model:

```text
400
 ↓
Bad request

401
 ↓
Authentication

403
 ↓
Permission

404
 ↓
Resource not found

409
 ↓
Conflict

422
 ↓
Validation / unprocessable request

429
 ↓
Rate limit

500+
 ↓
Server-side error
```

The Python SDK exposes corresponding exception classes.

---

# 33. Authentication Failure

If you receive:

```text
401
```

check:

```text
ANTHROPIC_API_KEY
```

Then check:

```text
Key active?
Key expired?
Correct organization?
Correct credential?
```

Do not immediately modify your Python code.

First verify the credential.

---

# 34. Permission Failure

If you receive:

```text
403
```

authentication may have succeeded, but the identity may not have permission to perform the requested action.

Investigate:

```text
Organization
Workspace
Identity
Permissions
Credential scope
```

---

# 35. Billing Failure

Billing-related API failures are different from authentication failures.

If your organization has a billing problem, check:

```text
Claude Console
     ↓
Settings
     ↓
Billing
     ↓
Credit balance
Payment method
Spend limits
```

Do not regenerate API keys just because billing failed.

---

# 36. Rate Limit

If you receive:

```text
429
```

you have encountered rate limiting.

The SDK automatically retries certain transient errors, including rate-limit responses, by default. The current default is two retries.

Do not create an uncontrolled retry loop.

---

# 37. Server Error

If the API returns:

```text
500+
```

the problem may be temporary server-side behavior.

The SDK automatically retries certain transient errors.

Your application should still have sensible error handling.

---

# 38. Network Failure

A network failure can occur before Claude returns an HTTP response.

The SDK exposes:

```python
anthropic.APIConnectionError
```

Example:

```python
except anthropic.APIConnectionError:
    print("Network connection to Claude failed.")
```

Possible causes:

* No Internet connection
* Proxy problem
* Firewall
* DNS problem
* TLS/network issue

---

# 39. Test Your API Key Without Printing It

Never do:

```python
print(os.getenv("ANTHROPIC_API_KEY"))
```

Instead:

```python
import os

if os.getenv("ANTHROPIC_API_KEY"):
    print("API key is configured.")
else:
    print("API key is missing.")
```

The real test is an actual API request.

---

# 40. Workspace Selection

If your credential can access multiple Workspaces, the API can receive:

```text
anthropic-workspace-id
```

The value is a Workspace ID such as:

```text
wrkspc_...
```

The header is only needed for credentials that can act across more than one Workspace. A credential already associated with a specific Workspace can omit it.

---

# 41. Python Workspace Example

The SDK supports passing extra headers through request options.

For a multi-Workspace credential, the concept is:

```python
message = client.with_options(
    extra_headers={
        "anthropic-workspace-id": "YOUR_WORKSPACE_ID"
    }
).messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=512,
    messages=[
        {
            "role": "user",
            "content": "Hello, Claude!",
        }
    ],
)
```

Use the actual Workspace ID from your organization.

If your key already belongs to one Workspace, you generally do not need this header.

---

# 42. Do Not Guess Workspace IDs

Never write:

```text
wrkspc_12345
```

and assume it works.

Get the actual Workspace ID from your Claude organization.

Incorrect Workspace IDs can produce request or access errors.

---

# 43. Count Tokens Before Sending a Request

The Python SDK also provides:

```python
client.messages.count_tokens()
```

The API exposes:

```text
POST /v1/messages/count_tokens
```

for counting input tokens before generating a response.

Example:

```python
count = client.messages.count_tokens(
    model="YOUR_MODEL_ID",
    messages=[
        {
            "role": "user",
            "content": "Explain Kubernetes.",
        }
    ],
)

print("Input tokens:", count.input_tokens)
```

---

# 44. Why Token Counting Matters

Before making expensive or large requests, token counting can help you understand input size.

This becomes useful for:

```text
Large documents
RAG
Long conversations
Agent context
Prompt optimization
Cost estimation
```

Architecture:

```text
Input
  ↓
Count tokens
  ↓
Evaluate size
  ↓
Send request
```

---

# 45. Do Not Confuse Token Counting With Generation

These are different operations.

### Count tokens

```text
How large is my input?
```

### Messages API

```text
Generate a response.
```

Conceptually:

```text
count_tokens()
      ↓
Input size

messages.create()
      ↓
Claude response
```

---

# 46. Response Content Can Contain Different Block Types

Do not build your application around the assumption:

```text
Response = one string
```

Instead:

```text
Response
   │
   └── content[]
         │
         ├── text
         ├── tool use
         ├── thinking
         └── other supported blocks
```

This becomes especially important later when we study:

```text
Tool Use
Agents
MCP
Extended Thinking
Structured workflows
```

---

# 47. A Reusable Text Extraction Function

Create:

```python
def extract_text(message) -> str:
    parts = []

    for block in message.content:
        if block.type == "text":
            parts.append(block.text)

    return "".join(parts)
```

Then:

```python
response_text = extract_text(message)

print(response_text)
```

This is cleaner than repeating the extraction logic throughout your application.

---

# 48. Complete Beginner Application

A clean first application:

```python
import anthropic
from anthropic import Anthropic


def extract_text(message) -> str:
    parts = []

    for block in message.content:
        if block.type == "text":
            parts.append(block.text)

    return "".join(parts)


def main() -> None:
    client = Anthropic()

    try:
        message = client.messages.create(
            model="YOUR_MODEL_ID",
            max_tokens=512,
            system=(
                "You are a helpful technical teacher. "
                "Explain concepts clearly for beginners."
            ),
            messages=[
                {
                    "role": "user",
                    "content": "What is Docker?",
                }
            ],
        )

        print(extract_text(message))

        print("\n--- Request Information ---")
        print("Request ID:", message._request_id)
        print("Model:", message.model)
        print("Stop reason:", message.stop_reason)
        print("Usage:", message.usage)

    except anthropic.AuthenticationError:
        print("Authentication failed. Check ANTHROPIC_API_KEY.")

    except anthropic.RateLimitError:
        print("Rate limit reached. Try again later.")

    except anthropic.APIConnectionError:
        print("Could not connect to the Claude API.")

    except anthropic.APIStatusError as error:
        print(f"Claude API error: HTTP {error.status_code}")


if __name__ == "__main__":
    main()
```

Replace:

```text
YOUR_MODEL_ID
```

with a currently available model.

---

# 49. What This Application Demonstrates

This small application already contains several production concepts:

```text
Authentication
       ↓
SDK client
       ↓
Messages API
       ↓
System instruction
       ↓
User message
       ↓
Response parsing
       ↓
Request ID
       ↓
Usage
       ↓
Error handling
```

That is a strong foundation.

---

# 50. Run It

Run:

```powershell
python main.py
```

Expected structure:

```text
Claude response...

--- Request Information ---
Request ID: req_...
Model: ...
Stop reason: ...
Usage: ...
```

The exact response and usage values will vary.

---

# 51. What Counts as Success?

Your first API request is successful when:

```text
✓ Python starts
✓ Anthropic SDK imports
✓ API key is loaded
✓ Request reaches Claude
✓ Claude returns a response
✓ Application extracts response text
```

You have now completed the basic Claude API integration.

---

# 52. What Does NOT Count as API Success?

This:

```text
API key configured
```

does not prove API access.

This:

```text
Anthropic SDK installed
```

does not prove API access.

This:

```text
Anthropic() created
```

does not necessarily prove the API request succeeded.

The definitive test is:

```text
client.messages.create(...)
```

returning a successful response.

---

# 53. Common Failure: `401`

Symptom:

```text
AuthenticationError
```

Check:

```text
1. API key exists
2. Correct API key
3. Key not expired
4. Key not disabled
5. Correct environment
```

Verify without exposing the key:

```powershell
python -c "import os; print('configured' if os.getenv('ANTHROPIC_API_KEY') else 'missing')"
```

---

# 54. Common Failure: `403`

Check:

```text
1. Organization
2. Workspace
3. Permissions
4. Credential scope
```

If using a multi-Workspace credential:

```text
anthropic-workspace-id
```

may need to be specified.

---

# 55. Common Failure: `404`

A `404` can indicate that the requested resource is not found.

Check:

```text
Model ID
Workspace ID
Other resource identifiers
```

Do not assume the model ID from an old tutorial is still valid.

Run:

```python
models = client.models.list()

for model in models:
    print(model.id)
```

and select a currently available model.

---

# 56. Common Failure: `429`

This indicates rate limiting.

Possible causes:

* High request volume
* Too many concurrent requests
* Organization limits
* Application loops

The SDK retries supported rate-limit failures by default.

For sustained workloads, design explicit concurrency and backoff controls.

---

# 57. Common Failure: `500+`

Possible causes:

* Temporary service issue
* Infrastructure issue
* Transient failure

The SDK automatically retries certain server errors.

If the problem continues:

```text
Record request ID
Check current Anthropic status/documentation
Retry later
Investigate application behavior
```

---

# 58. Common Failure: No Internet

If you receive:

```text
APIConnectionError
```

check:

```text
Internet
DNS
Proxy
Firewall
VPN
Corporate network
```

Try a simple network check before changing your Claude code.

---

# 59. Common Failure: `.env` Not Loaded

If the API key is missing:

Check:

```text
.env
```

Make sure:

```env
ANTHROPIC_API_KEY=...
```

exists.

If using `python-dotenv`:

```python
from dotenv import load_dotenv

load_dotenv()
```

must execute before reading environment variables.

---

# 60. Common Failure: Wrong Model

If the selected model is unavailable:

```text
Model-related error
```

Do not immediately modify the rest of your application.

First run:

```python
from anthropic import Anthropic

client = Anthropic()

for model in client.models.list():
    print(model.id)
```

Choose an available model.

---

# 61. Common Failure: Request Too Large

If your input becomes very large, the request may exceed applicable context or input limits.

This becomes common with:

```text
RAG
PDFs
Large repositories
Long conversations
Agent memory
```

Possible solutions include:

```text
Chunking
Summarization
Retrieval
Context management
Prompt optimization
Token counting
```

We will study these later.

---

# 62. Common Failure: Output Cut Off

If the response ends because it reached the output limit:

```text
stop_reason
```

can help identify the situation.

Increase:

```python
max_tokens
```

when appropriate.

But do not blindly set an extremely large value.

Large generation limits can increase:

* Cost
* Latency
* Network duration

---

# 63. Long-Running Requests

For long responses, streaming is often preferable.

The current Python SDK supports:

```python
client.messages.stream(...)
```

and:

```python
client.messages.create(..., stream=True)
```

for streaming responses.

A simple streaming example:

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

print()
```

---

# 64. Why Streaming Is Different

Normal request:

```text
Request
  ↓
Wait
  ↓
Complete response
```

Streaming:

```text
Request
  ↓
First text
  ↓
More text
  ↓
More text
  ↓
Final text
```

Streaming improves perceived responsiveness for long responses.

---

# 65. First API Request Architecture

You have now built:

```text
                         Claude Platform
                              │
                              ▼
                         Claude API
                              │
                    POST /v1/messages
                              │
                              ▼
                        Claude Model
                              │
                              ▲
                              │
                    Anthropic Python SDK
                              ▲
                              │
                         Python App
                              ▲
                              │
                       .venv + Python
                              ▲
                              │
                    ANTHROPIC_API_KEY
```

This is the fundamental architecture behind your first Claude application.

---

# 66. Important Security Reminder

Never log:

```text
ANTHROPIC_API_KEY
```

Never print:

```text
sk-ant-...
```

Never commit:

```text
.env
```

Never put the key in:

```text
GitHub
README
screenshots
logs
tutorial recordings
```

If exposed:

```text
Disable/Delete
      ↓
Create replacement
      ↓
Update application
      ↓
Verify
```

---

# 67. First API Request Checklist

### Environment

* [ ] `.venv` activated
* [ ] Python 3.10+
* [ ] `anthropic` installed
* [ ] API key configured

### Model

* [ ] Available models checked
* [ ] Current model selected

### Request

* [ ] `client.messages.create()` used
* [ ] `model` supplied
* [ ] `max_tokens` supplied
* [ ] `messages` supplied

### Response

* [ ] Response received
* [ ] Text extracted
* [ ] Request ID understood
* [ ] Usage inspected
* [ ] Stop reason understood

### Reliability

* [ ] Authentication errors understood
* [ ] Rate limits understood
* [ ] Connection errors understood
* [ ] Server errors understood

---

# 68. Knowledge Check

You should now be able to answer:

### Q1. What endpoint does `client.messages.create()` call?

```text
POST /v1/messages
```

### Q2. How can you discover available models?

```python
client.models.list()
```

### Q3. What does `max_tokens` mean?

The maximum number of output tokens Claude may generate.

### Q4. Is `max_tokens=512` a guarantee of 512 generated tokens?

No.

### Q5. Is the Messages API stateful?

No. Your application provides relevant conversation history.

### Q6. Where do system instructions go?

The top-level:

```python
system=
```

parameter.

### Q7. How do you extract text?

```python
for block in message.content:
    if block.type == "text":
        print(block.text)
```

### Q8. How do you inspect usage?

```python
message.usage
```

### Q9. How do you inspect the request ID?

```python
message._request_id
```

### Q10. What does HTTP 401 generally indicate?

Authentication failure.

### Q11. What does HTTP 429 indicate?

Rate limiting.

### Q12. What should you do if a model ID from an old tutorial fails?

List currently available models and choose a supported model.

---

# 69. Official References

Use the official documentation as the source of truth:

* [Claude Python SDK](https://platform.claude.com/docs/en/cli-sdks-libraries/sdks/python)
* [Python API Reference](https://platform.claude.com/docs/en/api/python)
* [Create a Message](https://platform.claude.com/docs/en/api/messages/create)
* [Authentication](https://platform.claude.com/docs/en/manage-claude/authentication)
* [API Errors](https://platform.claude.com/docs/en/api/errors)
* [Streaming](https://platform.claude.com/docs/en/build-with-claude/streaming)

---

# 70. Next Step

You have successfully crossed the most important initial boundary:

```text
Learning about Claude
        ↓
Configuring Claude
        ↓
Authenticating
        ↓
Installing SDK
        ↓
Making a real API request
        ↓
Receiving Claude's response
```

The next file is:

```text
docs/08-messages-api.md
```

There we will go much deeper into the **Messages API**, including:

```text
Messages
├── User messages
├── Assistant messages
├── System prompts
├── Multi-turn conversations
├── Content blocks
├── Text content
├── Image content
├── Message history
├── Stateless architecture
├── `max_tokens`
├── Stop reasons
├── Temperature / generation controls where applicable
├── Token usage
├── Context windows
├── Request structure
├── Response structure
└── Production patterns
```

After that, the learning path becomes:

```text
07 First API Request
        ↓
08 Messages API
        ↓
09 System Prompts
        ↓
10 Tokens & Context
        ↓
11 Streaming
        ↓
12 Tool Use
        ↓
13 Structured Outputs
        ↓
14 Files & Documents
        ↓
15 RAG
        ↓
16 Agents
        ↓
17 MCP
```

> **Core principle:** First understand the raw Messages API extremely well. Agents, RAG, MCP, and other higher-level systems are built on top of these fundamentals.
