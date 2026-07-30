---
name: success-criteria
description: Define observable completion, validation, and scope for non-trivial implementation, investigation, refactoring, migration, or performance work when clear acceptance criteria or evidence have not been provided. Do not use for factual answers, status reports, routine commits or pushes, mechanical edits, single-command tasks, or work with explicit completion and verification requirements.
---

# Define Done Before Acting

## Purpose

Use this skill when meaningful work could drift, end prematurely, or be declared complete without evidence because the desired outcome or its verification is unclear. It is not required for every action, and it must not restate acceptance criteria the user has already supplied.

## Form a completion contract

Identify the valuable end state, the observable evidence that would demonstrate it, the point where risk should be checked before proceeding, and the boundary that keeps the work from expanding. Use only the elements that matter for this task. Do not invent numerical targets, logging requirements, tests, or artifacts merely to fill a template.

If a missing criterion could materially change the implementation or make completion impossible to judge, ask a focused question. Otherwise choose a reasonable, proportionate verification method from the repository’s existing practices and state the assumption only when the user would benefit from seeing it.

For investigations, completion means producing enough evidence to answer or narrow the decision the investigation supports. It does not require finding a preferred answer, changing code, or exploring every possible cause.

## Communicate naturally

Before substantive work, write one short paragraph that explains what completion means and how it will be demonstrated. Do not expose acronym expansions, framework labels, checklists, or the word `stateback`.

Use this shape as guidance rather than a required form:

```text
This is complete when <valuable end state>, demonstrated by <observable evidence>. I’ll check <important risk point> before proceeding further, keep the work limited to <scope boundary>, and avoid <out-of-scope work>.
```

For example:

```text
This is complete when the migration succeeds on representative data and rollback has been demonstrated. I’ll verify the transformation before production execution, preserve the validation results, and avoid unrelated schema cleanup.
```

When the outcome, evidence, and scope are already explicit, do not add another contract. Proceed with the task and report the actual verification at the end.

## Keep implementation policy separate

This skill defines completion; it does not prescribe programming languages, logging libraries, type systems, test frameworks, architecture patterns, or dependency tools. Follow the project’s instructions and any applicable specialist skill for those decisions.

Favor the smallest verification that gives confidence proportional to the risk. A documentation edit may need a focused content review, while a migration may need fixtures, rollback checks, and hosted validation. Evidence should match the work rather than becoming additional work of its own.

When the task specifically calls for failure-proofing, scope reduction, or a design tradeoff, consult `references/poka-yoke-signals.md`, `references/lean-signals.md`, or `references/design-heuristics.md` as applicable. Do not load those references for routine completion planning.

## Coordinate with related skills

If `pause-framework` also applies, combine the clarified assignment and completion contract into one natural paragraph. If the assignment is clear but completion is not, use this skill alone.

Use `visible-work` when the user needs intermediate checkpoints or a plan. Use `deterministic-writing` when a specification must be implementation-ready. Neither skill makes this completion contract mandatory.

## Exit conditions

If this skill was loaded for a factual answer, status check, routine commit or push, mechanical edit, single command, or task with explicit acceptance criteria, exit it silently and perform the task normally.
