# Agentic AI — Revision Q&A Handbook

## 1. What is AI Engineering?

**Answer:**
AI Engineering is the practice of building applications and systems using foundation models/LLMs to solve practical problems.

The availability of models as a service reduced the barrier for organizations to build AI-enabled applications.

Common areas mentioned in your notes:

* RAG
* AI Agents
* Fine-tuning
* Multimodal AI

---

## 2. What is an LLM?

**Answer:**
An LLM (Large Language Model) is a language model trained on very large volumes of data and capable of generating text.

At a basic level, an autoregressive language model predicts the next token based on the previous context.

Example:

```text
Kids were screaming loud in the classroom
and then arrived the _____
```

The model predicts the next token based on probabilities.

---

## 3. What is a token?

**Answer:**
A token is a unit of text processed by the language model.

The model generates output token by token until it reaches a stopping condition such as an end-of-sequence (EOS) token or another generation limit.

---

## 4. What is an autoregressive language model?

**Answer:**
An autoregressive language model predicts the next token based on previously available tokens.

```text
Token 1
 ↓
Token 2
 ↓
Token 3
 ↓
...
```

Example:

```text
Kids were screaming loud
        ↓
next token prediction
        ↓
"...."
```

---

## 5. What is a masked language model?

**Answer:**
A masked language model predicts missing/masked words or tokens from surrounding context.

Example:

```text
Kids were ___ on the ground.
```

The model tries to predict the missing portion.

---

# AI Agents

## 6. What is an AI Agent?

**Answer:**
An AI Agent is a software system that uses AI/LLM capabilities to perform tasks or actions toward a goal.

An agent can use tools to interact with external systems.

Basic idea:

```text
Goal
 ↓
Agent
 ↓
Decision
 ↓
Action
 ↓
Result
```

---

## 7. Why do we need AI Agents?

**Answer:**
LLMs are very good at understanding and generating responses, but practical tasks often require actions.

Agents extend the capabilities of an LLM by allowing the system to perform actions and interact with tools or external systems.

---

## 8. What is the difference between an LLM and an AI Agent?

**Answer:**

### LLM

Primarily:

```text
Input
 ↓
Model
 ↓
Generated response
```

### Agent

```text
Goal
 ↓
LLM
 ↓
Decide action
 ↓
Tool/action
 ↓
Result
 ↓
Continue / finish
```

So:

> **LLM generates; an agent can use the model to decide and perform actions.**

---

# Agentic AI

## 9. What is Agentic AI?

**Answer:**
Agentic AI refers to AI systems that exhibit goal-oriented, autonomous decision-making and action.

It can involve:

* Agents
* Tools
* Multiple agents
* Complex workflows
* Decision-making
* Actions
* Adaptation

---

## 10. What is the relationship between AI Agents and Agentic AI?

**Answer:**

> **AI Agents are building blocks that can be used within broader Agentic AI systems.**

Agentic AI can involve:

```text
Single Agent
       ↓
or
Multiple Agents
       ↓
Tools + Workflows
       ↓
Complex Goal
```

---

## 11. Is Agentic AI always Multi-Agent?

**Answer:**

**No.**

Agentic AI can be implemented using:

```text
Single Agent
```

or:

```text
Multiple Agents
```

Multi-agent systems are one architectural approach within Agentic AI.

---

# AI Agent vs Agentic AI

## 12. What is the difference between AI Agents and Agentic AI?

| AI Agent               | Agentic AI                   |
| ---------------------- | ---------------------------- |
| Individual AI system   | Broader AI system/approach   |
| Performs tasks/actions | Pursues broader goals        |
| Can use tools          | Can coordinate agents/tools  |
| Can be single agent    | Can involve multiple agents  |
| Usually narrower scope | Can handle complex workflows |

### Easy memory:

> **Agent = individual worker**

> **Agentic AI = broader system that coordinates capabilities toward a goal**

---

# Agent Architecture

## 13. What are the two high-level architectural types mentioned in the notes?

**Answer:**

```text
1. Single Agent
2. Multi-Agent
```

---

# Single Agent

## 14. What is a Single-Agent system?

**Answer:**
A single-agent system uses one agent to handle the task, potentially using multiple tools.

Example:

```text
User
 ↓
Agent
 ↓
LLM
 ↓
Tools
 ├── Search
 ├── Calculator
 └── RAG
```

---

# Multi-Agent

## 15. What is a Multi-Agent system?

**Answer:**
A multi-agent system uses multiple specialized agents that can work together to achieve a larger goal.

Example from your notes:

```text
Research Agent
      ↓
Generation Agent
      ↓
Review Agent
```

---

## 16. When can Multi-Agent architecture be useful?

**Answer:**
When a problem contains different responsibilities that can be handled by specialized agents.

For example:

```text
Research
   ↓
Generate
   ↓
Review
```

Different agents can specialize in each responsibility.

---

# Tools

## 17. What is a tool in Agentic AI?

**Answer:**
A tool is an external capability that an agent can use to obtain information or perform an action.

Examples:

```text
Search
Calculator
Database
API
Ticketing system
```

---

## 18. Why do agents need tools?

**Answer:**
Tools allow an AI system to interact with the outside world instead of only generating text.

For example:

```text
LLM
 ↓
Need weather information
 ↓
Weather Tool
 ↓
Weather API
 ↓
Weather result
```

---

## 19. Can an LLM directly execute a Python function?

**Answer:**
**No.**

The model can generate a request to use a tool, but the application/runtime executes the actual function.

Conceptually:

```text
LLM
 ↓
Tool-call request
 ↓
Application / Runtime
 ↓
Python function
 ↓
Result
 ↓
LLM
```

### Remember:

> **LLM decides; runtime executes.**

---

# Tool Calling

## 20. What is tool calling?

**Answer:**
Tool calling is the mechanism through which an LLM indicates that a particular tool should be used, including the required arguments.

Example:

```text
User:
What's the weather in Hyderabad?

        ↓

LLM

        ↓

Call weather_tool
city = Hyderabad

        ↓

Runtime executes tool

        ↓

Weather result

        ↓

LLM

        ↓

Final answer
```

---

## 21. Who decides which tool should be used?

**Answer:**

The **LLM/model** can determine which available tool is appropriate based on the user's request and the tools provided to it.

Example:

```text
Available:

weather_tool
calculator_tool
search_tool

User:
What's the weather?

LLM:
Use weather_tool
```

---

## 22. Who executes the tool?

**Answer:**

The **application/agent runtime** executes the actual tool.

```text
LLM
 ↓
Tool-call request
 ↓
Runtime
 ↓
Tool
```

---

# Agent Loop

## 23. What is the basic agent loop?

**Answer:**

```text
Goal
 ↓
LLM
 ↓
Decide action
 ↓
Tool
 ↓
Result
 ↓
LLM
 ↓
Decide next action
 ↓
...
 ↓
Complete goal
```

The important idea is that an agent can perform **multiple steps**, rather than simply producing one response.

---

# Practical Examples From Your Notes

## 24. Give an e-commerce Agentic AI example.

**Answer:**

Your notes mention a logistics agent whose goal could be:

> Ship products faster for priority/Prime customers.

Conceptually:

```text
Order
 ↓
Logistics Agent
 ↓
Analyze shipping options
 ↓
Take appropriate action
 ↓
Faster delivery
```

---

## 25. Give a trading Agent example.

**Answer:**

Your notes mention a swing trading agent.

Its goal could involve:

```text
Market information
 ↓
Analyze
 ↓
Buy/Sell decision
 ↓
Attempt to minimize losses
```

---

## 26. Give a hiring Agent example.

**Answer:**

A hiring agent could help filter candidates for senior-management positions.

```text
Job requirement
 ↓
Hiring Agent
 ↓
Analyze profiles
 ↓
Filter candidates
 ↓
Best matching profiles
```

---

## 27. Give a social-media Agentic AI example.

**Answer:**

Your notes give:

```text
Research
 ↓
Generate
 ↓
Review
```

This can become:

```text
Research Agent
      ↓
Generation Agent
      ↓
Review Agent
```

Potentially followed by human approval.

---

## 28. Give an educational institution Agentic AI example.

**Answer:**

Your notes mention:

```text
Exams
Results
PTM
```

with the broader goal:

> **Better marks**

An Agentic AI system could coordinate activities related to these areas toward the larger educational goal.

---

# Frameworks

## 29. What frameworks are mentioned in your notes for building agents?

**Answer:**

Your notes mention:

* **LangGraph**
* **CrewAI**
* **AutoGen**

Don't worry about their detailed differences yet. We'll study them when we reach that part of your notes.

---

# AI Engineering

## 30. What are the major AI Engineering problems mentioned in your notes?

**Answer:**

Your notes identify:

### Fine-tuning

Used for things such as:

* Brand themes
* Specific problems

### RAG

Used for:

* Chatbots
* Knowledge bases
* Enterprise/private information

### AI Agents

Used to:

* Perform tasks
* Perform actions

---

# Foundation Models

## 31. What is a foundation model?

**Answer:**
A foundation model is a general-purpose model trained on large amounts of data and capable of supporting many different tasks.

Modern models can also support multiple modalities.

---

## 32. What modalities are mentioned in your notes?

**Answer:**

* Text
* Images
* Audio
* Video

---

# Model as a Service

## 33. Why did "Model as a Service" become important?

**Answer:**
Training a large language model requires enormous amounts of data and infrastructure.

Not every organization can build and train its own LLM.

Model-as-a-Service allows organizations to access already-built models and use them in their applications.

---

# Prompting

## 34. What makes a good prompt according to your notes?

Your later notes identify:

```text
Role
+
Context / level of understanding
+
Question
+
Constraints
```

---

## 35. What prompting style was introduced in your notes?

**Answer:**

```text
Set persona
 ↓
Set context
 ↓
Ask
```

Example:

```text
You are an expert in...
I am a beginner...
Explain...
```

---

# ⭐ 10 Questions You Should Be Able to Answer Without Looking

When you have a few minutes free, test yourself with these:

### 1.

What is an LLM?

### 2.

What is an AI Agent?

### 3.

Why do we need agents if we already have LLMs?

### 4.

What is Agentic AI?

### 5.

What is the difference between an AI Agent and Agentic AI?

### 6.

What is the difference between Single-Agent and Multi-Agent architecture?

### 7.

What is a tool?

### 8.

Who decides which tool to call?

### 9.

Who actually executes the tool?

### 10.

Explain this complete flow:

```text
User
 ↓
Application
 ↓
Agent
 ↓
LLM
 ↓
Tool
 ↓
Result
 ↓
LLM
 ↓
Final Answer
```

If you can explain those **10 questions naturally without memorizing**, you have a strong foundation for the next level.

---

## 🧠 Your revision formula

Whenever you're free, don't just reread the notes.

Use:

**Read → Close notes → Explain → Check → Correct → Repeat**

Especially practice explaining this sentence:

> **"The user interacts with an application. The application uses an agent and an LLM. The LLM can decide which tool is appropriate, while the application/runtime executes the tool. The result is returned to the model, which can continue reasoning toward the goal."**

If you can explain that clearly in your own words, you're already moving from **memorizing Agentic AI → understanding Agentic AI**.

