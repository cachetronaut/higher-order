---
name: visible-work
description: Use when the agent should make its interpretation, assumptions, rationale, plan, and review checkpoints visible to the user without dumping private chain-of-thought. Helps users see what the model is saying and deciding before implementation.
---

# Visible Work

## Overview

Visible work makes the agent's useful working state observable.

The user should be able to see what the agent thinks the assignment is, what assumptions it is making, why it chose a path, and when the user should review. This builds trust and gives the user a chance to steer before the model commits to the wrong build.

## Core principle

Show decision-relevant reasoning, not raw chain-of-thought.

Do not expose private hidden reasoning. Do expose the conclusions, assumptions, tradeoffs, and checks that help the user understand and correct the work.

## When to use

Use this skill when:

- The user asks how the model is thinking.
- The task is broad or ambiguous.
- The implementation has multiple plausible paths.
- The user needs to review before more work happens.
- The model is about to make product, design, architecture, or scope decisions.
- The user is learning how to prompt agents better.

## What to show

Make these visible:

| Piece | Purpose |
|------|---------|
| Interpretation | Confirms what the agent thinks the user wants. |
| Assumptions | Reveals defaults the agent will use unless corrected. |
| Gaps | Names missing information that could change the work. |
| Options | Shows the plausible paths without over-exploring. |
| Rationale | Explains why the chosen path fits the user's goal. |
| Plan | Gives ordered next steps. |
| Checkpoint | Tells the user when to review or redirect. |

## Output shape

Use this compact shape before implementation:

```text
My read:
- <what I think you want>

Key assumptions:
- <assumption>
- <assumption>

Plan:
1. <step>
2. <step>
3. <step>

Why this path:
- <short rationale and tradeoff>

Checkpoint:
- <what I will show you before continuing>
```

For very small tasks, compress it:

```text
My read: <interpretation>. I will assume <assumption>. Plan: <steps>. I will stop after <checkpoint>.
```

## Rationale style

Good rationale is short and decision-relevant.

Prefer:

```text
I am starting with the data model because auth, UI, and routes all depend on what a project/task/user actually is here.
```

Avoid:

```text
I will carefully think step by step through every aspect of the application to ensure correctness.
```

## Checkpoint examples

- "I will stop after the implementation plan before writing code."
- "I will build the first happy path, then show you the diff before adding edge cases."
- "I will create the UI skeleton first so you can correct the product feel before data wiring."
- "I will propose the architecture boundaries before generating files."

## Red flags

Revise the response when:

- The plan hides major assumptions.
- The user cannot tell what will happen next.
- The rationale is generic or performative.
- The agent asks too many low-value questions.
- The agent proceeds as if "production-ready" has a universal meaning.
- The response exposes verbose private reasoning instead of useful working state.
