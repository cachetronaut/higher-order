---
name: pause-framework
description: "IMPORTANT: PAUSE is mandatory before every reasoning process and every actionable task. YOU MUST invoke it before interpreting intent, planning, choosing an approach, making a decision, setting a goal, defining success, or producing an artifact. YOU MUST also invoke it before success-criteria and decision-analysis. Apply all five PAUSE checks internally, then communicate their conclusions as one natural prose paragraph. Skip only acknowledgments and direct factual answers with no task to perform."
---

# PAUSE — Clarify Before Building

## Purpose

**IMPORTANT: YOU MUST invoke and complete PAUSE before every reasoning process and every actionable task.** Use every acronym component as an internal scoping check before interpreting the task, defining success, comparing options, planning, or acting.

Do not treat a clear or mechanical task as permission to skip PAUSE. Existing clarity makes the framework faster; it does not make the reasoning unnecessary. Skip PAUSE only for acknowledgments and direct factual answers with no task to perform.

## Apply the PAUSE framework internally

**IMPORTANT: YOU MUST evaluate all five components before responding.** These components are the reasoning structure, not the user-facing format.

### P — Purpose

Define the concrete result the work should produce. Describe an outcome rather than an activity: “a focused migration runbook” is a result; “write documentation” is merely a process.

### A — Audience

Identify the person, team, system, or downstream agent that will consume the result. Account for the context or expertise that materially changes what the artifact must contain.

### U — Usage

Determine how the result will be used and how long it must remain useful. Distinguish one-time, repeated, disposable, and long-lived use when that difference affects quality, safeguards, or extensibility.

### S — Settings and Security

Identify the operational environment, permissions, privacy or safety boundaries, and other constraints that affect the work. Do not invent security concerns when none are relevant, but do not omit a material risk merely to keep the response short.

### E — Exceptions

Identify the one or two conditions most likely to invalidate the default approach or require review. If many unrelated exceptions emerge, narrow or split the purpose instead of hiding excessive scope inside one artifact.

Infer ordinary, low-risk details from repository context and established conventions. Ask only when different answers would materially change the result, create a consequential commitment, cross a permission boundary, or make safe execution impossible.

## Respond as one natural paragraph

**IMPORTANT: YOU MUST translate the PAUSE conclusions into a single cohesive prose paragraph before substantive work.** The paragraph may contain multiple sentences, but it must not use acronym headings, labels, bullets, a checklist, or the word `stateback`. Do not announce that PAUSE ran.

If the user explicitly requires an exact output with no preamble, complete PAUSE internally and preserve that output contract instead of adding the paragraph. This is an output-format exception, not permission to skip PAUSE when another mandatory skill invokes it.

Use this shape as guidance, not as a form to fill mechanically:

```text
I’ll produce <purpose> for <audience> to support <usage>. I’ll work within <settings, security, or operational constraints> and account for <one or two consequential exceptions>.
```

For example:

```text
I’ll prepare the migration runbook for the on-call team to use during the production rollout. I’ll keep it limited to the approved migration and existing access boundaries, and I’ll stop for review if the source data cannot be transformed safely or rollback cannot be demonstrated.
```

Every PAUSE component must be considered internally. Include its conclusion in the paragraph when it affects the assignment; do not pad the paragraph with artificial constraints or exceptions solely to make the framework visible.

## Coordinate with related skills

If `success-criteria` runs, **YOU MUST complete PAUSE first**, then complete SUCCESS and combine both frameworks' conclusions into one natural working-agreement paragraph. Do not emit separate PAUSE and SUCCESS sections.

Use `prompt-probing` when material gaps require answers before a safe next step can be chosen. Use `visible-work` when the user needs a plan or review checkpoint. Neither skill is an automatic dependency.
