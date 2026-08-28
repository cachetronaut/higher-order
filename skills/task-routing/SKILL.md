---
name: task-routing
description: "Use for every actionable task after success-criteria. Score task complexity, select direct or delegated execution, write bounded subagent briefs, and set verification depth before implementation."
---

# Task routing

## Purpose

Match execution cost and verification depth to the task's actual complexity.

**IMPORTANT: Invoke and complete `success-criteria` before using this skill.** SUCCESS invokes `pause-framework` first.

Keep context clean and focused. Prefer the lowest-cost capable agent. Delegate only when independent work justifies coordination overhead.

## Score the task

Assign one Fibonacci score before execution:

| Score | Meaning |
| --- | --- |
| `1` | Simple |
| `2` | Moderate |
| `3` | Difficult |
| `5` | Complex |
| `8` | Highly complex or high-risk |

Use the smallest score supported by scope, ambiguity, risk, and verification needs. Do not inflate scores to justify more agents.

## Select the execution path

- `1 point`: Work directly. Use inspect, implement, then verify.
- `2 points`: Use an Efficient agent for one bounded investigation, implementation, or verification task.
- `3 points`: Use an Advanced agent. Split independent research, implementation, and testing when useful.
- `5 points`: Use an Elite agent for planning and integration. Delegate bounded work to Advanced or Efficient agents.
- `8 points`: Use Frontier when available. Otherwise use the strongest Elite agent. Require explicit planning, staged verification, and final adversarial review.

Do not delegate when the environment lacks subagents or when delegation would cost more than direct work. Continue directly and preserve the score's verification depth.

For simple work, use inspect, implement, then verify. For complex or multi-file work, inspect, make a concise plan, parallelize independent analysis, execute, then verify.

## Select agents by capability

Interpret available models by capability. Treat model names as current examples, not permanent identities.

| Tier | Use for | Equivalent model families |
| --- | --- | --- |
| Elite | Architecture, difficult debugging, large refactors, ambiguous multi-system work, critical review | Cursor Grok 4.6, Claude Opus 5, GPT-5.6 Sol |
| Advanced | Specialized implementation, multi-file features, deep domain analysis, test strategy | Composer 2.5, GPT-5.6 Terra, Claude Sonnet 5 |
| Efficient | Focused investigation, routine implementation, test additions, bounded code review | GPT-5.6 Luna, Claude Haiku 4.5 |
| Frontier | Novel, high-risk, or long-horizon work needing the strongest available reasoning | Claude Fable 5, when available |

Use these equivalencies as guidance:

- `Grok 4.6 ≈ Opus ≈ Sol`
- `Composer ≈ Terra ≈ Sonnet`
- `Luna ≈ Haiku`

Use Fable only for `8-point` work or unusual ambiguity, novelty, risk, or architectural impact. When a named model is unavailable, use the closest available tier.

For mixed work, keep planning and integration with a strong primary agent. Give bounded independent tasks to Efficient or Advanced agents.

## Write bounded subagent tasks

Delegate only work with clear inputs, outputs, ownership, and success criteria. Never give multiple agents write ownership of the same file.

Use this template. Replace every placeholder and remove any inapplicable heading.

```markdown
> [!attention] IMPORTANT: Use the applicable higher-order skill(s) for this task.

# Goal
- [ ] Add or change: [specific feature, investigation, or review objective].

# Context
- [ ] Task score: [1 / 2 / 3 / 5 / 8].
- [ ] Recommended capability tier: [Efficient / Advanced / Elite / Frontier].
- [ ] Scope: [bounded files, subsystem, or question].

# Constraints
- [ ] Do not change: [protected behavior, files, or interfaces].
- [ ] Reuse: [existing pattern, component, utility, or convention].
- [ ] No new dependencies unless required.
- [ ] Coordinate only through: [specified interface, file boundary, or output].

# Success Criteria
- [ ] [Required behavior works].
- [ ] [Relevant tests pass].
- [ ] [Build, lint, and type checks pass as applicable].
- [ ] [No regression in X].
- [ ] Report assumptions, changed files, and verification performed.

# Relevant Files
- [ ] path/to/file
- [ ] path/to/test
- [ ] path/to/reference
```

Ask subagents to return findings, proposed diffs, risks, and verification results. Keep task decomposition, interface decisions, conflict resolution, and final verification with the primary agent.

Escalate one tier when ambiguity, repeated failures, or cross-system impact blocks a subtask.

## Verify proportionately

The task score sets the number of independent verification passes:

- `1 point`: one verification pass.
- `2 points`: two verification passes.
- `3 points`: three verification passes.
- `5 points`: five verification passes.
- `8 points`: eight verification passes.

A pass may be a targeted test, type check, lint check, build, runtime check, requirement comparison, diff review, or independent agent review. Choose distinct checks that can reveal different failures. Do not rerun the same command merely to increase the count.

Test observable behavior using known inputs. Add targeted unit tests for new behavior when practical. Name tests after observable outcomes.

Run every relevant check for modified code. Run all affected suites for cross-cutting changes. Report every check that could not run.

Completion claims are not verification evidence.

## Coordinate execution

Do not overlap subagent write ownership. Use subagents only for independent work with clear boundaries.

Reserve final integration and verification for the primary agent. Reconcile conflicting findings before changing shared files.

When verification fails, identify the failure, form one evidence-based hypothesis, make the smallest fix, and re-verify.
