---
name: pause-framework
description: Use when about to generate code, documents, prompts, plans, or any reusable artifact — to validate intent, audience, constraints, and exceptions before executing.
---

# PAUSE Framework

## Overview

A mandatory pre-execution reasoning gate that evaluates every task through five structured dimensions before any output is generated. Ensures clarity of intent, constraints, risk awareness, and correct scoping prior to execution.

## When to Use

Activate before:
- Generating or modifying code
- Writing documents, reports, or structured content
- Creating prompts, workflows, or system designs
- Producing decisions, plans, or recommendations
- Any task that produces reusable or externally consumed artifacts

Do NOT activate for:
- Simple factual queries with no downstream artifact
- Casual conversation without execution intent
- Single-turn clarifications or acknowledgments

## Core Pattern — The Five Dimensions

Produce all five fields in order before executing:

| Dimension | What to state |
|-----------|---------------|
| **P — Purpose** | Intended outcome as a concrete result (not a method or process) |
| **A — Audience** | Actual end user(s) or system consuming the output, with context/expertise level |
| **U — Usage** | How the output will be used: one-time, repeated, long-lived, or disposable |
| **S — Settings/Security** | Operational constraints, permissions, security, privacy, or safety considerations |
| **E — Exceptions** | Conditions where the default approach fails (≤2 edge cases) |

## Output Format (Strict)

```text
P — Purpose: <one sentence>
A — Audience: <one sentence>
U — Usage: <one sentence>
S — Settings/Security: <one sentence>
E — Exceptions: <one sentence or two short sentences max>
```

## Execution Gate

Execution is ONLY allowed when all conditions are met:
- All five PAUSE fields are completed
- No field contains unknowns or unresolved assumptions
- Exceptions ≤ 2
- Purpose clearly defines outcome
- Settings/Security includes relevant risk considerations

If any condition fails → output MUST be BLOCKED.

## Exception Handling

If more than two exceptions are identified:
1. STOP execution immediately
2. Re-evaluate and re-scope Purpose
3. Redefine task until exception count is ≤ 2

## Common Mistakes

| Anti-pattern | Fix |
|--------------|-----|
| Bundling multiple ideas in one field | Each field must be a single sentence |
| Omitting a field | All five are mandatory — no exceptions |
| Listing 3+ exceptions without re-scoping | Stop and narrow the Purpose first |
| Treating PAUSE as optional for "simple" tasks | Activate for any artifact-producing task |
