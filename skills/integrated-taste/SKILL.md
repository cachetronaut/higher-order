---
name: integrated-taste
description: Use when reviewing plans, product decisions, UI choices, architecture proposals, writing, or agent outputs for judgment, fit, restraint, and quality — especially when the question is whether the work feels right for the user's intent rather than whether it is merely correct.
---

# Integrated Taste

## Overview

Taste is the ability to notice when an answer is technically correct but wrong for the moment.

Use this skill to review whether a proposed path fits the user's intent, context, quality bar, and constraints. The goal is not to make the work more elaborate. The goal is to make it more appropriate.

## Core principle

Good agent work should feel like the model understood what matters.

It should not feel like the model followed a checklist, optimized for visible effort, or produced the largest plausible artifact.

## When to use

Use this skill when:

- The user asks for taste, judgment, quality, polish, product sense, or critique.
- A technically valid answer still may not fit the user's real goal.
- The work could become overbuilt, generic, performative, or too literal.
- You are choosing what to remove, defer, or leave alone.
- You are reviewing a plan before implementation.
- You are turning vague preference into actionable constraints.

Skip this skill when:

- The user needs a simple factual answer.
- A mechanical validator, test, or spec fully determines correctness.
- The user explicitly asks for exhaustive exploration before judgment.

## The taste check

Review the work through five lenses:

| Lens | Question |
|------|----------|
| Intent | What is the user really trying to make happen? |
| Context | Where will this live, who is it for, and what constraints matter? |
| Quality | What would make this feel clear, useful, and finished? |
| Restraint | What should be removed, deferred, simplified, or left alone? |
| Fit | Does this solution belong in this product, repo, conversation, and moment? |

## Output style

Give the user the judgment, not the scaffolding. Do not expose the five lenses as headings unless the user asks for a formal review.

Use this shape for concise reviews:

```text
The direction is right, but it currently feels <main issue>. I would make it more <desired quality> by <specific change>, while avoiding <tempting but wrong move>.

The smallest next step is <one concrete action>.
```

Use this shape for implementation guidance:

```text
Build <specific thing> because it best matches <intent/context>. Keep <constraint> tight, remove <unnecessary piece>, and treat <observable quality> as the bar for done.
```

## Heuristics

- Prefer the smallest change that makes the work feel intentional.
- Prefer language the user would actually use over framework vocabulary.
- Prefer a sharp constraint over a broad principle.
- Prefer one clear tradeoff over five soft caveats.
- Prefer removing generic polish before adding bespoke polish.
- Prefer a useful artifact over an impressive artifact.
- Prefer naming the taste bar before implementing against it.

## Red flags

Stop and revise when:

- The plan is mostly process and not enough judgment.
- The answer could apply to any repo, product, or user.
- The solution is bigger than the user's current moment.
- The work is optimized for completeness instead of usefulness.
- The agent says "best practice" without naming why it fits here.
- The artifact is correct but has no point of view.
- The critique lists issues but does not choose the next move.

## Relationship to other skills

- Use `pause-framework` first when the task is not yet scoped.
- Use `success-criteria` when the result needs an observable definition of done.
- Use `think` when multiple viable options need deterministic narrowing.
- Use `deterministic-writing` when the judgment must become an implementation-ready plan or spec.
- Use this skill as the final review pass when correctness is not enough.
