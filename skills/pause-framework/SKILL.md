---
name: pause-framework
description: Clarify an intended artifact before creating or substantially changing it when ambiguity about its purpose, audience, use, constraints, or consequential exceptions could materially alter the result. Use for ambiguous or high-consequence code, documents, prompts, plans, and designs. Do not use for factual answers, reviews, mechanical edits, routine commands, or work whose scope and constraints are already explicit.
---

# Clarify Before Building

## Purpose

Use this skill to prevent material ambiguity from becoming an implementation decision the user never made. It is a selective scoping check, not a universal preflight or a reason to narrate obvious facts.

## Establish the assignment

First decide whether plausible interpretations would produce meaningfully different artifacts, risks, or commitments. If the request already identifies the desired result, its consumer, the important constraints, and the relevant boundaries, continue without announcing this skill or adding a ceremonial preamble.

When clarification is useful, form a concise understanding of what will be produced, who or what will use it, how long it must remain useful, which operational or safety constraints matter, and where the default approach would fail. Include only details that affect the work. Do not force security, lifecycle, or edge-case language into a task where those considerations are immaterial.

Infer ordinary low-risk details from repository context and established conventions. Ask the user only when different answers would materially change the result, create a consequential commitment, or cross a safety or permission boundary.

## Communicate naturally

Before substantive work, state the assignment as one short paragraph. Do not use acronym headings, framework labels, field names, or the word `stateback`.

Use this shape as guidance rather than a form:

```text
I’ll produce <concrete result> for <audience or consumer> to support <intended use>. I’ll keep it within <material constraints or boundaries> and pause for review if <critical condition that would change the approach>.
```

For example:

```text
I’ll prepare the migration runbook for the on-call team to use during the production rollout. I’ll keep it limited to the approved migration, account for rollback and access constraints, and pause for review if the existing data cannot be migrated safely.
```

Keep the paragraph shorter when fewer details matter. If no visible clarification would help the user understand or correct the assignment, proceed silently.

## Coordinate with related skills

If `success-criteria` also applies, combine the scoped assignment and definition of done into one natural working-agreement paragraph. Do not emit separate framework declarations.

Use `prompt-probing` when missing information requires user answers before a safe next step can be chosen. Use `visible-work` when the user needs a plan or review checkpoint. Neither skill is an automatic dependency.

## Stop conditions

Stop and ask a focused question only when the unresolved choice would materially change the artifact, introduce significant risk, create an external commitment, or exceed the user’s authority. Otherwise state a reasonable assumption when it is useful and continue.

If this skill was loaded for a factual answer, routine command, mechanical edit, review-only request, or already-explicit assignment, exit it silently and perform the task normally.
