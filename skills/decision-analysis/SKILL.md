---
name: decision-analysis
description: Compare and recommend among three or more credible options when the choice involves competing constraints, meaningful tradeoffs, or material consequences and cannot be settled by a command, test, established project rule, or specialized skill. Do not use merely because the user says "think," asks for an explanation, or presents a decision with one clearly dominant answer.
---

# Decision Analysis

## Purpose

Use this skill to make a consequential choice understandable and reviewable without exposing private chain-of-thought or pretending that subjective judgment is mathematically certain.

Ordinary reasoning does not require this workflow. If a command, validator, project instruction, specialist skill, or clearly dominant constraint determines the answer, follow that source directly. If the user merely asks for careful thought, an explanation, or a comparison between options with an obvious winner, respond normally.

## Analyze the decision

State the decision and identify the few constraints that could change it. Consider three to five credible options rather than padding the list with weak candidates. Eliminate an option immediately when it violates a hard constraint, and explain that disqualification without assigning it an artificial score.

Compare the surviving options using decision-relevant tradeoffs such as user value, feasibility, reversibility, cost, risk, operational fit, and compatibility with established project choices. Use only the criteria that matter for the decision.

Recommend the option with the strongest overall fit. Name the strongest rejected alternative, its meaningful advantage, and the reason it still loses. State what new evidence or changed constraint would reverse the recommendation when that boundary is useful.

Do not repeatedly rescore the same options or force the candidate set to shrink by a fixed fraction. Structured comparison supports judgment; it does not make the judgment deterministic.

## Communicate naturally

Give the user a concise recommendation rather than a transcript of the analysis. Do not mention this skill, expose an acronym, dump private reasoning, or show a score table unless the user explicitly asks for the decision record.

Use this shape as guidance:

```text
I recommend <option> because it best satisfies <dominant constraints> while avoiding <main risk or tradeoff>. <Strong alternative> offers <meaningful advantage>, but it loses here because <decisive reason>. I would revisit the choice if <evidence or constraint that would reverse it>.
```

## Audited comparison mode

Use the bundled helper only when the user explicitly requests a decision matrix, ranking, reproducible comparison, exhaustive record, or saved audit trail. Normal decision analysis must not create `.decision-analysis/`, `.think/`, or any other project files.

For an audited comparison, create `.decision-analysis/<slug>/` only within the workspace the user placed in scope. Record the goal and constraints in plain-text files, then resolve `bin/decision-analysis.sh` relative to this `SKILL.md` and use it for candidate and score mutations. In Claude Code, `${CLAUDE_PLUGIN_ROOT}` resolves the installed plugin path:

```bash
decision_helper="${CLAUDE_PLUGIN_ROOT}/skills/decision-analysis/bin/decision-analysis.sh"
"$decision_helper" init .decision-analysis/<slug> goal.md constraints.md
"$decision_helper" add .decision-analysis/<slug> "Candidate sentence."
"$decision_helper" score .decision-analysis/<slug> 1 87 "Strong fit; low operational risk."
"$decision_helper" rank .decision-analysis/<slug>
"$decision_helper" status .decision-analysis/<slug>
"$decision_helper" winner .decision-analysis/<slug>
```

Scores are comparative aids supplied by the agent or user; they are not objective measurements unless the underlying evidence makes them so. The helper provides stable IDs, validation, replacement of revised scores, deterministic sorting, and a reproducible ranking. It does not decide which criteria matter or what score an option deserves.

Do not persist an audited comparison when the user asked only for a recommendation. Do not commit a decision record unless the user includes it in the requested deliverable.

## Coordinate with related skills

Use a specialist skill such as `project-architecture` to supply domain rules when the decision concerns that domain. Use this skill only if a meaningful choice remains after those rules are applied.

Use `pause-framework` when the artifact to be produced after the decision is materially ambiguous. Use `success-criteria` when the subsequent implementation lacks a clear definition of done. Neither skill is required merely to make a recommendation.
