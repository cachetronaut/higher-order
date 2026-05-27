---
name: think
description: Use when the user asks the agent to think, reason carefully, choose between options, make a decision, evaluate alternatives, or narrow a large solution space
---

# THINK

## Overview

THINK is a deterministic option-narrowing loop for agent reasoning. The agent must externalize the goal, constraints, candidate options, scoring, pruning, and loop state instead of silently deciding in context.

Core principle: do not "think harder" in one pass; write the decision state down, score against explicit constraints, cut the candidate set by half, and loop until one option remains.

THINK stands for:

- **T - Take a beat to reflect on the goal.** Write the goal out in one sentence before generating options.
- **H - Hash out the constraints.** Write each constraint out so it can be compared against the goal.
- **I - Ideate through N potential solutions.** Write N candidate solutions, each as exactly one sentence.
- **N - Narrow to the best ceil(N/2) options.** Score each active option against the constraints, then keep the top half, rounded up to the nearest whole number.
- **K - Keep refining until there is a clear winner.** Explicitly write that you are looping back to refine the list, then repeat scoring and narrowing until one option remains.

## When to Use

Use this skill when:

- The user says "think," "think hard," "think step by step," "reason carefully," or similar.
- The user asks the agent to choose among alternatives.
- The solution space could reasonably start with 3 to 1000 candidates.
- The agent is tempted to pick an answer based on intuition instead of explicit constraints.
- The user needs a systematic elimination process rather than a brainstorm.

Do not use this skill when:

- The user asks for a simple factual answer.
- There is only one viable option.
- A specialized skill has a stricter required workflow, such as test-driven development or systematic debugging.
- The decision can be fully determined by a mechanical command, test, or validator without judgment.

## Required External State

Create a working directory named `.think/<slug>/` in the current project or task workspace.

Required files:

```text
.think/<slug>/
  goal.md
  constraints.md
  candidates.tsv
  active.tsv
  scores.tsv
  eliminated.tsv
  iterations/
    iteration-001.md
```

Use `bin/think.sh` for all state mutations. Do not hand-edit `active.tsv`, `scores.tsv`, or `eliminated.tsv` after initialization.

## Deterministic Loop

### T - Take a beat

Write the user's goal into `goal.md` as one sentence.

If the user's goal is ambiguous, make the best practical interpretation and record it. Do not stop for clarification unless the ambiguity makes scoring impossible.

### H - Hash constraints

Write constraints into `constraints.md`, one per line.

Constraints should include:

- user-stated requirements
- hard safety or policy constraints
- project constraints
- quality constraints
- tie-breakers

If two constraints conflict, mark the stricter or higher-priority one as dominant.

### I - Ideate N options

Generate N candidate solutions. Each candidate must be one sentence.

Minimum N:

- Use N = 3 when the user did not specify a candidate count.
- Use the user-provided N when given.
- If the user asks for exhaustive exploration, choose the largest practical N and record the cap in `goal.md`.

Add every candidate with `think.sh add`.

### N - Narrow to ceil(N/2)

For each active candidate, assign a whole-number score from 0 to 100.

Scoring rule:

```text
score = value_against_goal - constraint_penalties + feasibility_bonus
```

Tie-breakers are deterministic:

1. higher score wins
2. lower candidate id wins

After scoring all active candidates, run `think.sh narrow`. It must keep exactly `ceil(active_count / 2)` candidates unless only one candidate remains.

### K - Keep refining

After each narrowing step, the iteration note must include this exact sentence:

```text
Looping back to refine the list.
```

Then re-score only the surviving candidates against the same goal and constraints. Do not add new candidates mid-loop unless a surviving candidate is discovered to be invalid or the user changes the goal.

Stop when one active candidate remains. Report the winner, the final rationale, and the main eliminated alternatives.

## Script Contract

Use the bundled shell script:

```bash
bin/think.sh init .think/<slug> goal.md constraints.md
bin/think.sh add .think/<slug> "Candidate sentence."
bin/think.sh score .think/<slug> 1 87 "Strong fit; low risk."
bin/think.sh narrow .think/<slug>
bin/think.sh status .think/<slug>
bin/think.sh winner .think/<slug>
```

The script owns deterministic iteration, candidate IDs, stable sorting, top-half pruning, and iteration logs.

## Output Format to User

When THINK completes, respond with:

```text
Goal: <one sentence>
Constraints used: <brief summary>
Winner: <candidate id and sentence>
Why it won: <short rationale>
Eliminated: <brief list of strongest rejected options and why>
```

Keep internal scoring tables out of the final answer unless the user asks to inspect them.

## Common Mistakes

### Picking a winner before writing candidates

Wrong: "The best answer is obviously X."

Right: write goal, constraints, at least three one-sentence candidates, then narrow.

### Changing constraints mid-loop

Wrong: adjust constraints so a preferred answer wins.

Right: keep constraints stable unless the user changes the goal or a hard constraint was missed.

### Keeping an arbitrary number of candidates

Wrong: keep "the good ones."

Right: keep `ceil(N/2)` every round.

### Hiding the loop

Wrong: silently refine in the model's context.

Right: use `think.sh`, write iteration notes, and include "Looping back to refine the list."

### Treating THINK as brainstorming only

Wrong: generate ideas and stop.

Right: generate, score, narrow, loop, and select a winner.
