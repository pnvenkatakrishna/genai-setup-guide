# Claude Token Counting

> **Purpose:** Understand tokens, input-token estimation, the Messages API token-counting endpoint, context management, cost planning, and practical token-budgeting patterns.

---

# 1. What You Will Learn

By the end of this document, you will understand:

* What tokens are
* Why tokens matter
* Input tokens vs output tokens
* Why tokens are not the same as characters or words
* How tokenization affects GenAI applications
* Anthropic's token-counting endpoint
* `client.messages.count_tokens()`
* `/v1/messages/count_tokens`
* Counting tokens before sending a request
* Counting system prompts
* Counting conversation history
* Counting tools
* Counting images
* Counting PDFs
* Token-counting limitations
* Token-counting estimates
* Tokenizer differences between model generations
* Rate limits
* Token counting and cost planning
* Token counting in RAG
* Token counting in agents
* Practical safeguards
* Common mistakes

---

# 2. What Is a Token?

A **token** is a unit of text processed by a language model.

Humans generally think in:

```text
Characters
Words
Sentences
Paragraphs
```

LLMs process text as:

```text
Tokens
```

For example:

```text
I am learning DevOps.
```

is converted into a sequence of tokens before the model processes it.

The exact tokenization depends on the tokenizer used by the model.

---

# 3. Tokens Are Not Exactly Words

A common beginner assumption is:

```text
1 word = 1 token
```

This is not correct.

For example:

```text
Kubernetes
```

might be represented by one or multiple tokens depending on the model's tokenizer.

Similarly:

```text
containerization
```

may be split into multiple token units.

Therefore:

```text
100 words
```

does **not** necessarily mean:

```text
100 tokens
```

---

# 4. Why Do Tokens Matter?

Tokens matter because they affect:

* Context-window usage
* Input processing
* Output generation
* API usage
* Cost
* Rate-limit planning
* Prompt design
* RAG design
* Agent context
* Conversation history

Think of your application like this:

```text
                 Claude
                   |
        +----------+----------+
        |                     |
        v                     v
   Input Tokens          Output Tokens
        |                     |
        v                     v
 Context / Prompt          Response
```

---

# 5. Input Tokens

Input tokens are tokens sent **to Claude**.

For example:

```text
System prompt
+
Conversation history
+
User question
+
Retrieved documents
+
Images/documents/tool information
```

can contribute to the input.

Conceptually:

```text
Input
│
├── System instructions
├── Conversation history
├── User message
├── RAG context
├── Tool definitions
└── Other supported content
        |
        v
   Input tokens
```

---

# 6. Output Tokens

Output tokens are tokens generated **by Claude**.

For example:

```text
User:
Explain Kubernetes.
```

Claude generates:

```text
Kubernetes is a container orchestration platform...
```

The generated response consumes output tokens.

So:

```text
Input tokens
      +
Output tokens
      =
Total token usage concept
```

The exact billing calculation depends on the model and current pricing rules, so don't assume one universal formula for every Anthropic model.

---

# 7. The Most Important Distinction

Remember:

```text
Input tokens
=
What your application sends to Claude
```

and:

```text
Output tokens
=
What Claude generates
```

For example:

```text
Application
     |
     | 2,000 input tokens
     v
   Claude
     |
     | 500 output tokens
     v
Application
```

The API response's usage information reports the actual usage associated with the request.

---

# 8. What Is Token Counting?

Token counting lets you estimate the number of input tokens **before creating the message**.

Anthropic provides:

```text
POST /v1/messages/count_tokens
```

The Python SDK exposes this as:

```python
client.messages.count_tokens(...)
```

The endpoint returns the total number of input tokens for the supplied request structure.

---

# 9. Why Would You Count Tokens Before Sending?

Token counting can help you:

```text
1. Manage prompt size
2. Plan context usage
3. Manage costs
4. Make model-routing decisions
5. Prepare RAG context
6. Avoid oversized requests
7. Optimize prompts
8. Build application safeguards
```

Anthropic specifically documents token counting for managing rate limits and costs, model routing, and fitting prompts to a target length.

---

# 10. Token Counting Architecture

Without token counting:

```text
Application
     |
     v
Messages API
     |
     v
Claude
```

With token counting:

```text
Application
     |
     v
Count Tokens
     |
     v
Check Prompt Size
     |
     +---- Too large ----> Modify / trim / retrieve less
     |
     +---- Acceptable ---> Send to Claude
```

This is particularly useful in production systems.

---

# 11. The Token Counting Endpoint

The endpoint is:

```text
POST https://api.anthropic.com/v1/messages/count_tokens
```

The Python API reference documents:

```text
messages.count_tokens(**kwargs)
```

as:

```text
POST /v1/messages/count_tokens
```

and returns a `MessageTokensCount` object.

---

# 12. Basic Python Example

```python
import anthropic

client = anthropic.Anthropic()

response = client.messages.count_tokens(
    model="YOUR_MODEL_ID",
    messages=[
        {
            "role": "user",
            "content": "Hello, Claude"
        }
    ],
)

print(response.input_tokens)
```

Example conceptual output:

```text
3
```

The actual number depends on the model's tokenizer and the exact input.

---

# 13. Why We Use `YOUR_MODEL_ID`

Do not copy a model ID from an old tutorial and assume it will always be available.

Instead:

```python
models = client.models.list()

for model in models:
    print(model.id)
```

Then select a currently available model.

This is especially important for token counting because:

> **The token count is tied to the model you specify.**

Anthropic's documentation explicitly states that the token-counting endpoint counts using the tokenizer associated with the `model` parameter.

---

# 14. Counting a System Prompt

Token counting supports system prompts.

Example:

```python
response = client.messages.count_tokens(
    model="YOUR_MODEL_ID",
    system="You are an expert DevOps instructor.",
    messages=[
        {
            "role": "user",
            "content": "Explain Kubernetes."
        }
    ],
)

print(response.input_tokens)
```

The count represents the input request structure rather than only the user question.

---

# 15. Counting Conversation History

Suppose your conversation contains:

```text
User:
What is Docker?

Assistant:
Docker is a containerization platform.

User:
Why is it useful?
```

You can count the complete input:

```python
response = client.messages.count_tokens(
    model="YOUR_MODEL_ID",
    messages=[
        {
            "role": "user",
            "content": "What is Docker?"
        },
        {
            "role": "assistant",
            "content": "Docker is a containerization platform."
        },
        {
            "role": "user",
            "content": "Why is it useful?"
        },
    ],
)

print(response.input_tokens)
```

This helps you understand how conversation history contributes to prompt size.

---

# 16. Conversation Growth

This is one of the most important production concepts.

Imagine:

```text
Turn 1
User → Claude

Turn 2
User → previous history + Claude

Turn 3
User → previous history + Claude

Turn 4
User → previous history + Claude
```

The input can grow as conversation history grows.

Conceptually:

```text
Turn 1
████

Turn 2
████████

Turn 3
████████████

Turn 4
████████████████
```

If the application sends the complete conversation every time, the amount of input context can become significant.

---

# 17. Token Counting in Chat Applications

A production chat application may do:

```text
User message
     |
     v
Load conversation history
     |
     v
Count tokens
     |
     v
Is context acceptable?
     |
   /   \
 Yes    No
 |       |
 v       v
Send    Trim/summarize
        history
```

This gives your application a way to enforce its own context-management policy.

---

# 18. Token Counting in RAG

Token counting is extremely useful in RAG.

Suppose the user asks:

```text
How does our leave policy work?
```

The retriever returns:

```text
Document 1
Document 2
Document 3
Document 4
Document 5
Document 6
```

If you blindly insert everything into the prompt:

```text
System prompt
+
6 documents
+
user question
```

the prompt may become unnecessarily large.

A better architecture is:

```text
User question
      |
      v
Retriever
      |
      v
Relevant chunks
      |
      v
Token count
      |
      v
Fit target
      |
      v
Claude
```

---

# 19. RAG Context Budget

Imagine you define an application-level target:

```text
Available context budget:
20,000 tokens
```

Your application might allocate:

```text
System instructions      1,000
Conversation history     4,000
Retrieved context       12,000
User question            1,000
Safety margin             2,000
-------------------------------
Total                    20,000
```

This is an **application design example**, not a universal Anthropic limit.

The exact context window depends on the selected model and current API capabilities.

---

# 20. Token Counting and Chunking

RAG chunking should not be based only on character count.

For example:

```text
Chunk A = 2,000 characters
Chunk B = 2,000 characters
Chunk C = 2,000 characters
```

does not mean:

```text
Each chunk = same number of tokens
```

Different content can tokenize differently.

For production RAG systems, token-aware chunking or post-retrieval token budgeting can be more reliable than assuming a fixed character-to-token ratio.

---

# 21. Token Counting with Tools

The token-counting endpoint also supports client-side tools.

Example:

```python
response = client.messages.count_tokens(
    model="YOUR_MODEL_ID",
    tools=[
        {
            "name": "get_weather",
            "description": "Get the current weather in a given location.",
            "input_schema": {
                "type": "object",
                "properties": {
                    "location": {
                        "type": "string"
                    }
                },
                "required": ["location"]
            }
        }
    ],
    messages=[
        {
            "role": "user",
            "content": "What's the weather like in Hyderabad?"
        }
    ],
)

print(response.input_tokens)
```

Anthropic's current documentation confirms that token counting supports client tools and the Advisor tool.

---

# 22. Server Tools Limitation

An important current limitation:

The token-counting endpoint does **not** support every server-side tool.

Anthropic currently documents unsupported server tools including:

```text
Web search
Web fetch
Code execution
Tool search
```

with the Advisor tool being an exception among those server tools.

Requests containing unsupported server tools can return:

```text
invalid_request_error
```

For those cases, the actual token usage is reported in the Messages API response instead.

---

# 23. Token Counting with Images

Token counting supports image inputs.

Example:

```python
import base64

with open("diagram.png", "rb") as image_file:
    image_data = base64.standard_b64encode(
        image_file.read()
    ).decode("utf-8")

response = client.messages.count_tokens(
    model="YOUR_MODEL_ID",
    messages=[
        {
            "role": "user",
            "content": [
                {
                    "type": "image",
                    "source": {
                        "type": "base64",
                        "media_type": "image/png",
                        "data": image_data,
                    },
                },
                {
                    "type": "text",
                    "text": "Describe this diagram."
                },
            ],
        }
    ],
)

print(response.input_tokens)
```

Anthropic's current documentation supports base64 image input for token counting.

---

# 24. Image URL Limitation

The token-counting endpoint does not support image blocks using a URL or file source in the same way as the Messages API.

For token counting, send the image as base64 when required.

This distinction is important:

```text
Messages API
    |
    +---- supports additional image source forms

Token Counting API
    |
    +---- certain URL/file image sources are not supported
```

Anthropic explicitly documents this limitation.

---

# 25. Token Counting with PDFs

Token counting also supports PDF input when supplied as base64.

Example:

```python
import base64

with open("document.pdf", "rb") as pdf_file:
    pdf_base64 = base64.standard_b64encode(
        pdf_file.read()
    ).decode("utf-8")

response = client.messages.count_tokens(
    model="YOUR_MODEL_ID",
    messages=[
        {
            "role": "user",
            "content": [
                {
                    "type": "document",
                    "source": {
                        "type": "base64",
                        "media_type": "application/pdf",
                        "data": pdf_base64,
                    },
                },
                {
                    "type": "text",
                    "text": "Summarize this document."
                },
            ],
        }
    ],
)

print(response.input_tokens)
```

Anthropic documents base64-encoded PDFs as supported for token counting. URL and file document sources are not supported by this endpoint.

---

# 26. Token Counting with Thinking

For models that support the relevant thinking capabilities, previous thinking blocks can affect input-token accounting.

Anthropic's current documentation notes that:

* Previous assistant thinking blocks can count toward input tokens on models that retain them.
* On models that retain only the last turn, earlier thinking blocks may be stripped.
* Current assistant-turn thinking counts toward input tokens.

The exact behavior depends on the model's current context-management behavior.

Therefore, do not assume:

```text
visible text only
=
total input tokens
```

---

# 27. Token Counting Is an Estimate

This is extremely important.

Token counting does **not** guarantee that the eventual Messages API request will report exactly the same input-token number.

Anthropic explicitly describes the token count as an **estimate**.

In some cases, actual input-token usage may differ by a small amount.

Therefore:

```text
count_tokens()
        |
        v
Estimated input tokens
```

not:

```text
count_tokens()
        |
        v
Guaranteed billing number
```

---

# 28. Why Can the Estimate Differ?

Anthropic notes that token counts may include tokens automatically added by Anthropic for system optimizations.

Those system-added tokens are not billed to you.

Therefore:

```text
Estimated API input count
```

and:

```text
Billable content
```

should not be treated as exactly identical concepts.

---

# 29. Model-Specific Tokenization

Different model generations can use different tokenizers.

Anthropic currently documents that Claude 4.7 and later models and Claude Mythos Preview use a newer tokenizer, with the same input text producing approximately 30% more tokens than on earlier models in many cases.

The exact difference depends on the content and workload.

Therefore:

> **Always count using the model you actually plan to use.**

---

# 30. Do Not Reuse Old Token Counts

Suppose you previously measured:

```text
Prompt:
10,000 tokens
```

using an older model.

You later migrate to another model generation.

Do not automatically assume:

```text
Same prompt
=
10,000 tokens
```

Instead:

```python
client.messages.count_tokens(
    model="NEW_MODEL_ID",
    messages=[...]
)
```

Anthropic specifically recommends recounting prompts against the model you plan to use when tokenizer behavior differs.

---

# 31. Token Counting Is Free

Anthropic's current documentation states that the token-counting endpoint is free to use.

However, it is still subject to requests-per-minute rate limits based on your usage tier.

Therefore:

```text
Free to use
≠
Unlimited requests
```

---

# 32. Token Counting Has Separate Rate Limits

Token counting and message creation have separate rate limits.

Using the token-counting endpoint does not consume the message-creation rate limit.

Anthropic currently documents separate rate limits for token counting.

This is useful when designing production applications.

---

# 33. Current Documented Token-Counting Rate Limits

Anthropic's current documentation lists:

| Usage tier | Token-counting requests/minute |
| ---------- | -----------------------------: |
| Start      |                          5,000 |
| Build      |                         10,000 |
| Scale      |                         20,000 |

These values are current documentation values and can change over time.

Always verify the current Anthropic rate-limit documentation before designing around a specific limit.

---

# 34. Basic Token-Budgeting Pattern

A simple application can use:

```python
MAX_INPUT_TOKENS = 20_000

count = client.messages.count_tokens(
    model="YOUR_MODEL_ID",
    system=system_prompt,
    messages=messages,
)

if count.input_tokens > MAX_INPUT_TOKENS:
    raise ValueError(
        "Prompt is too large. Reduce conversation history or context."
    )
```

This is an application-level safeguard.

Do not confuse:

```text
MAX_INPUT_TOKENS
```

with Anthropic's model context limit.

Your application can intentionally set a lower internal threshold.

---

# 35. Better Production Pattern

Instead of simply rejecting the request:

```text
Too large
   |
   X
```

you can progressively reduce context:

```text
Count
  |
  v
Too large?
  |
  +---- No ---> Send
  |
  Yes
  |
  v
Remove low-priority history
  |
  v
Count again
  |
  v
Still large?
  |
  +---- Yes ---> Reduce RAG context
  |
  v
Count again
  |
  v
Send
```

This is a practical context-management pattern.

---

# 36. Token Counting + Conversation Summarization

For long-running chat applications:

```text
Conversation
     |
     v
Token count
     |
     v
Too large
     |
     v
Summarize old conversation
     |
     v
Keep recent messages
     |
     v
Count again
     |
     v
Send to Claude
```

For example:

```text
Old messages
      ↓
Conversation summary
      ↓
Recent messages
      ↓
Current question
```

This reduces unnecessary historical context.

---

# 37. Token Counting + RAG

A production RAG pipeline can use token counting like this:

```text
User Query
    |
    v
Retrieve 20 chunks
    |
    v
Rank chunks
    |
    v
Add chunks incrementally
    |
    v
Count tokens
    |
    v
Budget exceeded?
   / \
 Yes  No
  |    |
  v    v
Stop  Add more
  |
  v
Messages API
```

This is much better than blindly injecting every retrieved document.

---

# 38. Token Counting + Model Routing

Suppose your application supports multiple models:

```text
Model A
Model B
Model C
```

You can count the prompt against different models:

```python
count_a = client.messages.count_tokens(
    model="MODEL_A",
    messages=messages,
)

count_b = client.messages.count_tokens(
    model="MODEL_B",
    messages=messages,
)
```

Because tokenization can differ between models, this can help inform routing decisions.

Anthropic explicitly lists model routing as a use case for token counting.

---

# 39. Token Counting Does Not Mean You Should Count Everything Twice

A common beginner mistake is:

```text
Every request
   |
   +--> count_tokens()
   |
   +--> messages.create()
```

without considering whether the extra request provides useful value.

Token counting is most useful when you actually need:

* Budget enforcement
* Context management
* Routing
* Prompt optimization
* Large RAG context management
* Cost controls

For a tiny request such as:

```text
Hello Claude
```

token counting may add unnecessary complexity.

---

# 40. When Token Counting Is Especially Valuable

Use it when:

```text
Large prompts
Long conversations
RAG
Agents
Many tools
Large documents
PDF workflows
Images
Strict internal budgets
Model routing
Cost-sensitive applications
```

---

# 41. When It May Be Unnecessary

For a simple application:

```python
response = client.messages.create(
    model="YOUR_MODEL_ID",
    max_tokens=512,
    messages=[
        {
            "role": "user",
            "content": "What is Docker?"
        }
    ]
)
```

you may not need to call `count_tokens()` first.

Keep the architecture simple until token management becomes relevant.

---

# 42. Token Counting vs Actual Usage

This distinction is essential.

### Before request

```python
count = client.messages.count_tokens(...)
```

gives an estimate of input tokens.

### After request

```python
response.usage
```

provides usage information from the actual Messages API request.

Conceptually:

```text
Before
  |
  v
count_tokens()
  |
  v
Estimated input size
  |
  v
messages.create()
  |
  v
Actual API request
  |
  v
response.usage
```

---

# 43. Recommended Monitoring Pattern

In production:

```python
count = client.messages.count_tokens(
    model=model,
    system=system_prompt,
    messages=messages,
)

print("Estimated input tokens:", count.input_tokens)

response = client.messages.create(
    model=model,
    max_tokens=1024,
    system=system_prompt,
    messages=messages,
)

print("Actual input tokens:", response.usage.input_tokens)
print("Output tokens:", response.usage.output_tokens)
```

This gives you visibility into:

```text
Estimated input
Actual input
Actual output
```

---

# 44. A Simple Token Budget Manager

You can create a small helper:

```python
def count_input_tokens(client, model, messages, system=None):
    response = client.messages.count_tokens(
        model=model,
        system=system,
        messages=messages,
    )

    return response.input_tokens
```

Then:

```python
token_count = count_input_tokens(
    client=client,
    model="YOUR_MODEL_ID",
    system="You are a DevOps instructor.",
    messages=[
        {
            "role": "user",
            "content": "Explain Kubernetes."
        }
    ],
)

print("Estimated input tokens:", token_count)
```

---

# 45. Building a Context Guard

```python
def ensure_context_budget(
    client,
    model,
    messages,
    max_input_tokens,
    system=None,
):
    response = client.messages.count_tokens(
        model=model,
        system=system,
        messages=messages,
    )

    if response.input_tokens > max_input_tokens:
        raise ValueError(
            f"Input is too large: "
            f"{response.input_tokens} tokens"
        )

    return response.input_tokens
```

Usage:

```python
tokens = ensure_context_budget(
    client=client,
    model="YOUR_MODEL_ID",
    messages=messages,
    max_input_tokens=20_000,
)
```

---

# 46. Important: Internal Budget vs Model Limit

Suppose your model supports a very large context window.

You might still choose:

```text
Application budget = 20,000 tokens
```

because:

* Lower cost
* Faster responses
* Better retrieval precision
* Less irrelevant context
* More predictable performance

Therefore:

```text
Model context limit
```

and:

```text
Application token budget
```

are different concepts.

---

# 47. Context Window

The context window represents the amount of information the model can work with for a request/conversation according to the model's current capabilities.

Conceptually:

```text
+--------------------------------------+
|             Context Window           |
|                                      |
| System                               |
| Conversation                         |
| Retrieved Context                    |
| Tools                                |
| User Input                           |
| Current generation / other context   |
|                                      |
+--------------------------------------+
```

The exact limits depend on the selected model and current Anthropic documentation.

Do not hard-code a single context-window number into general documentation unless you have verified it for the exact model.

---

# 48. Token Counting in Agentic AI

Agents can accumulate context quickly.

Imagine:

```text
User request
   |
   v
Agent
   |
   +---- Tool 1
   |
   +---- Tool result
   |
   +---- Tool 2
   |
   +---- Tool result
   |
   +---- Tool 3
   |
   +---- Tool result
   |
   v
Final answer
```

Tool results can become part of the context.

Therefore:

```text
Agent
+
Tools
+
Tool results
+
Conversation
+
System instructions
```

can create a large input.

Token budgeting becomes important.

---

# 49. Token Counting in Tool-Using Systems

Consider:

```text
System prompt              2,000
Conversation                4,000
Tool definitions            3,000
Tool results                6,000
User request                1,000
---------------------------------
Estimated input            16,000
```

This is only an example.

The actual token count should be measured using the selected model.

---

# 50. Common Mistakes

## Mistake 1 — Assuming one word equals one token

Incorrect:

```text
100 words = 100 tokens
```

Tokenization is model-dependent.

---

## Mistake 2 — Assuming token counts are universal

Incorrect:

```text
This prompt is 10,000 tokens on every Claude model.
```

Different model generations can use different tokenizers.

---

## Mistake 3 — Treating `count_tokens()` as exact billing

It is an estimate.

Actual request usage can differ.

---

## Mistake 4 — Using an old model's token count

If you change models, recount.

---

## Mistake 5 — Counting only the user question

In production, input can include:

```text
System
+
History
+
Tools
+
RAG
+
User
+
Other supported content
```

---

## Mistake 6 — Sending unlimited RAG context

More context is not automatically better.

Retrieve and include relevant information within an intentional token budget.

---

## Mistake 7 — Confusing input tokens with output tokens

Remember:

```text
Input
=
what goes into Claude
```

```text
Output
=
what Claude generates
```

---

# 51. Troubleshooting

## Error: `invalid_request_error`

If token counting rejects your request, inspect whether you're using an unsupported input type.

Current documented limitations include certain:

```text
Server tools
MCP connector
Image URL/file sources
Document URL/file sources
```

Use supported forms such as base64 for image/PDF counting when required.

---

## Error: Token count unexpectedly changed

Check:

```text
1. Did you change the model?
2. Did you change the prompt?
3. Did you add conversation history?
4. Did you add tools?
5. Did you add images/PDFs?
6. Did you change tokenizer generation?
```

---

## Error: Count is slightly different from actual usage

This can happen because token counting is an estimate and Anthropic may add system optimization tokens that are not billed.

---

# 52. Practical Exercise

Create:

```text
token-count-demo.py
```

Use:

```python
import anthropic

client = anthropic.Anthropic()

model = "YOUR_MODEL_ID"

system_prompt = """
You are a DevOps instructor.
Explain concepts clearly with practical examples.
"""

messages = [
    {
        "role": "user",
        "content": "Explain Kubernetes in simple language."
    }
]

result = client.messages.count_tokens(
    model=model,
    system=system_prompt,
    messages=messages,
)

print("Estimated input tokens:", result.input_tokens)
```

Run:

```bash
python token-count-demo.py
```

---

# 53. Exercise 2 — Compare Prompts

Try:

```python
messages = [
    {
        "role": "user",
        "content": "Explain Docker."
    }
]
```

Then:

```python
messages = [
    {
        "role": "user",
        "content": """
        Explain Docker in detail.
        Include:
        1. What Docker is
        2. Why Docker was created
        3. Docker images
        4. Docker containers
        5. Docker networking
        6. Docker volumes
        7. Practical examples
        """
    }
]
```

Compare:

```text
Prompt A
Prompt B
```

and observe how the input-token estimate changes.

---

# 54. Exercise 3 — Conversation Growth

Create:

```python
messages = [
    {
        "role": "user",
        "content": "What is Docker?"
    },
    {
        "role": "assistant",
        "content": "Docker is a containerization platform."
    },
    {
        "role": "user",
        "content": "Why is it useful?"
    }
]
```

Count the tokens.

Then add more conversation turns.

Observe:

```text
Conversation grows
        |
        v
Input context grows
        |
        v
Token count changes
```

---

# 55. Exercise 4 — RAG Simulation

Create three fake document chunks:

```python
chunks = [
    "Docker packages applications into containers.",
    "Kubernetes orchestrates containerized workloads.",
    "Terraform manages infrastructure as code.",
]
```

Combine them into a prompt.

Count the tokens.

Then remove one chunk and count again.

This demonstrates the basic principle of:

```text
Retrieved context
        ↓
Token budget
```

---

# 56. Interview Questions

### What is a token?

A token is a unit of text processed by a language model.

### Are tokens the same as words?

No. Tokenization is model-dependent.

### What is input-token usage?

Tokens supplied to the model as part of the request.

### What is output-token usage?

Tokens generated by the model.

### What endpoint counts tokens?

```text
POST /v1/messages/count_tokens
```

### What is the Python SDK method?

```python
client.messages.count_tokens(...)
```

### Is token counting free?

Anthropic currently documents the token-counting endpoint as free, but it is subject to rate limits.

### Is token counting exact?

No. Anthropic describes it as an estimate.

### Why can token counts change after changing models?

Different model generations can use different tokenizers.

### Why is token counting useful in RAG?

It helps control the amount of retrieved context included in a prompt.

### Why is token counting useful in agents?

Tool definitions, tool results, history, and system instructions can all contribute to input context.

---

# 57. Knowledge Check

### Question 1

What does `count_tokens()` measure?

<details>
<summary>Answer</summary>

It estimates the number of input tokens for the supplied Messages API request structure.

</details>

---

### Question 2

Does `count_tokens()` measure output tokens?

<details>
<summary>Answer</summary>

No.

It measures input tokens. Output tokens are generated during the actual Messages API request.

</details>

---

### Question 3

Should you reuse a token count after switching models?

<details>
<summary>Answer</summary>

No.

Recount using the model you actually plan to use because tokenization can differ between model generations.

</details>

---

### Question 4

Can the token count differ slightly from actual usage?

<details>
<summary>Answer</summary>

Yes.

Anthropic documents token counting as an estimate.

</details>

---

### Question 5

Can tools contribute to input-token usage?

<details>
<summary>Answer</summary>

Yes.

Client tool definitions and supported tool-related inputs can contribute to the request's input tokens.

</details>

---

### Question 6

Why is token counting useful in RAG?

<details>
<summary>Answer</summary>

It helps control how much retrieved context is placed into the prompt and helps keep the request within an intentional application budget.

</details>

---

# 58. Final Mental Model

Remember:

```text
                 YOUR APPLICATION
                        |
                        v
              ┌───────────────────┐
              │ System Prompt     │
              │ History           │
              │ Tools             │
              │ RAG Context       │
              │ User Question     │
              └─────────┬─────────┘
                        |
                        v
                COUNT TOKENS
                        |
                        v
               Estimated Input
                  Tokens
                        |
              ┌─────────┴─────────┐
              │                   │
           Too large          Acceptable
              │                   │
              v                   v
       Reduce context       Messages API
       /summarize/trim          |
                                v
                              Claude
                                |
                                v
                         Actual Usage
                                |
                     ┌──────────┴──────────┐
                     │                     │
               Input Tokens          Output Tokens
```

The key principle is:

> **Token counting is a planning and context-management tool, not a replacement for the actual usage reported by the Messages API.**

---

# 59. What You Should Remember

```text
Token
  ↓
Basic unit processed by the model

Input tokens
  ↓
What your application sends

Output tokens
  ↓
What Claude generates

count_tokens()
  ↓
Estimate input size before sending

response.usage
  ↓
Usage information from the actual request

Model
  ↓
Determines the tokenizer used for counting

RAG
  ↓
Token budget helps control retrieved context

Agents
  ↓
Tools + results + history can grow context

Production
  ↓
Measure, budget, optimize
```

---

# 60. Official References

* [Anthropic Token Counting](https://platform.claude.com/docs/en/build-with-claude/token-counting)
* [Python API Reference](https://platform.claude.com/docs/en/api/python)
* [Messages API](https://platform.claude.com/docs/en/api/messages/create)
* [Context Windows](https://platform.claude.com/docs/en/build-with-claude/context-windows)
* [Prompt Caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching)

---

## Next

The next file in this learning sequence is:

```text
docs/11-prompt-engineering.md
```

This will move from **API mechanics** into one of the most important practical skills: designing reliable instructions for Claude.
