---
name: success-criteria
description: Define observable completion, validation, and scope for non-trivial implementation, investigation, refactoring, migration, or performance work when clear acceptance criteria or evidence have not been provided. Do not use for factual answers, status reports, routine commits or pushes, mechanical edits, single-command tasks, or work with explicit completion and verification requirements.
---

# SUCCESS — Define Done Before Acting

## Purpose

Use SUCCESS when meaningful work could drift, end prematurely, or be declared complete without evidence because its outcome or verification is unclear. Apply it selectively according to the description, then use every acronym component as an internal goal-setting check before substantive work.

If the user has already supplied a valuable end state, observable criteria, proportionate validation, evidence, and a clear scope boundary, exit this skill silently. Do not restate an adequate definition of done as framework ceremony.

## Apply the SUCCESS framework internally

Evaluate all seven components before responding. These components define the reasoning process, not the user-facing format.

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

Translate the SUCCESS conclusions into a single cohesive prose paragraph before substantive work. The paragraph may contain multiple sentences, but it must not use acronym headings, labels, bullets, a checklist, or the word `stateback`. Do not announce that SUCCESS ran.

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

If `pause-framework` also applies, complete both internal frameworks and combine their conclusions into one natural working-agreement paragraph. If the assignment is clear but completion is not, use SUCCESS alone.

Use `visible-work` when the user needs intermediate checkpoints or a plan. Use `deterministic-writing` when a specification must be implementation-ready. Neither skill makes SUCCESS mandatory when its trigger conditions are absent.
