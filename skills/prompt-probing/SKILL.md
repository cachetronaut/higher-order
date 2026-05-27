---
name: prompt-probing
description: Use when a user request is vague, overloaded, high-stakes, or underspecified — especially prompts like "build me a production-ready app" or "make no mistakes". Ask targeted questions, state assumptions, and define a safe first step before implementation.
---

# Prompt Probing

## Overview

Prompt probing turns vague ambition into a usable assignment.

Many users ask for outcomes that sound clear but hide the actual product, quality bar, constraints, and tradeoffs. Do not punish the user for that. Help them discover what the model needs to know.

## Core principle

Ask the few questions that would materially change the work. State reasonable assumptions for everything else.

The goal is not to interrogate the user. The goal is to prevent the agent from silently inventing the product.

## When to use

Use this skill when the user says things like:

- "Build me a production-ready app."
- "Make no mistakes."
- "Make this good."
- "Use best practices."
- "Build the whole thing."
- "Make it scalable."
- "You decide."

Also use it when the request is missing:

- user or audience
- purpose
- scope boundary
- data model
- platform or deployment target
- quality bar
- deadline or budget
- security/privacy constraints
- visual direction
- definition of done

## Probing workflow

1. Restate the request in concrete terms.
2. Name the gaps that could change implementation.
3. Ask no more than 3-5 high-leverage questions.
4. State the defaults you will assume if the user does not answer.
5. Propose the smallest safe next step.

## Question quality bar

Good questions change the build.

Bad question:

```text
What features do you want?
```

Better question:

```text
Who is the first real user, and what is the one thing they must be able to do in the first session?
```

Bad question:

```text
Should it be production ready?
```

Better question:

```text
For this project, does production-ready mean deployable demo, paid-user MVP, internal tool, or compliance-sensitive app?
```

Bad question:

```text
What stack should I use?
```

Better question:

```text
Do you care more about fastest iteration, long-term maintainability, or fitting an existing stack?
```

## Output shape

Use this structure:

```text
I can do this, but the prompt is hiding a few decisions that will affect the build.

What I think you want:
- <concrete interpretation>

Questions that would change the implementation:
1. <question>
2. <question>
3. <question>

If you do not answer, I will assume:
- <default>
- <default>

Smallest safe next step:
- <step>
```

## Defaults

When the user wants speed, default to:

- smallest coherent version
- local-first implementation if possible
- boring dependencies
- explicit TODOs for deferred production concerns
- one happy path plus obvious error states
- no invented enterprise requirements

When the user wants production readiness, define the term before building. Production-ready is not one thing. It may mean:

- deployable demo
- internal workflow tool
- MVP for real users
- paid product foundation
- compliance-sensitive system
- high-scale public service

Each definition implies different work.

## Red flags

Stop and probe when:

- The user asks for perfection instead of constraints.
- The scope could expand indefinitely.
- You are about to choose product requirements, auth, payments, data retention, or deployment without confirmation.
- You cannot describe the first user and first useful workflow.
- The phrase "best practice" appears without a specific reason.
- The user would be surprised by the assumptions you are about to make.
