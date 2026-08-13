---
name: success-criteria
description: "IMPORTANT: SUCCESS is mandatory for every actionable request or goal-setting process. YOU MUST invoke pause-framework first, then apply all seven SUCCESS checks before planning or execution to define the outcome, utility, criteria, checkpoints, evidence, simplest sufficient approach, and scope. Use for implementation, investigation, writing, planning, refactoring, decisions, and goals, even when the user supplies acceptance criteria. Skip only acknowledgments and direct factual answers with no task to perform."
---

# SUCCESS — Define Done Before Acting

## Purpose

**IMPORTANT: YOU MUST invoke SUCCESS for every actionable request or goal-setting process. YOU MUST invoke and complete `pause-framework` before evaluating SUCCESS.** Use every SUCCESS component as an internal goal-setting check before planning or execution.

Do not treat supplied acceptance criteria as permission to skip SUCCESS. Use the framework to confirm and complete what the user provided without inventing redundant requirements. Skip SUCCESS only for acknowledgments and direct factual answers with no task to perform.

## Apply the SUCCESS framework internally

**IMPORTANT: YOU MUST evaluate all seven components before responding.** These components define the reasoning process, not the user-facing format.

### S — Seek Success

Define one concrete end state that would make the task genuinely complete. Describe the valuable result rather than the activity performed.

### U — Uncover Utility

Identify the user value, decision, or operational outcome the completed work must support. A technically finished artifact that does not provide the intended utility is not successful.

### C — Choose Criteria

Choose observable proof standards that another person or system could use to judge completion. Prefer concrete evidence and avoid invented thresholds that are not grounded in the request, repository, or measured baseline.

### C — Create Checkpoints

Place validation at the point where an incorrect assumption or risky action would be most expensive. Use the smallest checkpoint proportionate to the risk; do not manufacture intermediate ceremony for trivial work.

### E — Expose Evidence

Decide what tests, records, artifacts, measurements, or observations will demonstrate the result. Preserve only evidence that helps the user verify the outcome or understand consequential decisions.

### S — Stay Simple

Choose the smallest approach that can satisfy the criteria. Remove work, abstraction, configuration, and verification that do not contribute to the defined success.

### S — Sustain Scope

Set the boundary that prevents unrelated cleanup or attractive additions from entering the task. Revisit the success criteria when a new request or discovery would change that boundary.

For investigations, define success as producing enough evidence to answer or materially narrow the decision the investigation supports. Do not require a code change, preferred conclusion, or exhaustive search unless the task calls for one.

Ask a focused question only when a missing criterion would materially change the implementation or make completion impossible to judge. Otherwise use the repository’s established practices and state a reasonable assumption only when it helps the user review the work.

## Respond as one natural paragraph

**IMPORTANT: YOU MUST translate the combined PAUSE and SUCCESS conclusions into a single cohesive prose paragraph before substantive work.** The paragraph may contain multiple sentences, but it must not use acronym headings, labels, bullets, a checklist, or the word `stateback`. Do not announce that either framework ran.

If the user explicitly requires an exact output with no preamble, complete both frameworks internally and preserve that output contract instead of adding the paragraph. This is an output-format exception, not permission to skip PAUSE or SUCCESS.

Use this shape as guidance, not as a form to fill mechanically:

```text
This is complete when <success end state> provides <utility>, demonstrated by <criteria and evidence>. I’ll validate <risk point> at <checkpoint>, use the simplest approach that meets those standards, and keep the work bounded to <scope>.
```

For example:

```text
This is complete when the migration preserves the supported customer records and can be rolled back, allowing operations to release it without risking unrecoverable data loss. I’ll prove that with representative fixtures and recorded forward-and-rollback results before production execution, use the existing migration mechanism, and avoid unrelated schema cleanup.
```

Every SUCCESS component must be considered internally. Include its conclusion in the paragraph when it affects the completion contract; do not invent metrics, checkpoints, evidence, or scope statements merely to make the framework visible.

## Keep implementation policy separate

SUCCESS defines completion; it does not prescribe programming languages, logging libraries, type systems, test frameworks, architecture patterns, or dependency tools. Follow repository instructions and applicable specialist skills for those decisions.

When the task specifically calls for failure-proofing, scope reduction, or a design tradeoff, consult `references/poka-yoke-signals.md`, `references/lean-signals.md`, or `references/design-heuristics.md` as applicable. Do not load those references for routine completion planning.

## Coordinate with related skills

**IMPORTANT: PAUSE always applies when SUCCESS runs. YOU MUST complete PAUSE first**, then complete SUCCESS and combine both frameworks' conclusions into one natural working-agreement paragraph. Never run SUCCESS alone.

Use `visible-work` when the user needs intermediate checkpoints or a plan. Use `deterministic-writing` when a specification must be implementation-ready. Neither skill makes SUCCESS mandatory when its trigger conditions are absent.
