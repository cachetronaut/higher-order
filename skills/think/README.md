# THINK Skill

`think` is a Higher Order skill for deterministic option narrowing. It records the decision goal, constraints, candidates, scores, eliminations, and final winner in `.think/<slug>/`.

Use it when a user asks the agent to think carefully, compare alternatives, choose a path, or narrow a large solution space.

## Files

- `SKILL.md` - trigger and workflow instructions for agents
- `bin/think.sh` - deterministic state machine for candidate scoring and pruning

## Helper Commands

```bash
bin/think.sh init .think/<slug> goal.md constraints.md
bin/think.sh add .think/<slug> "Candidate sentence."
bin/think.sh score .think/<slug> 1 87 "Strong fit; low risk."
bin/think.sh narrow .think/<slug>
bin/think.sh status .think/<slug>
bin/think.sh winner .think/<slug>
```

The helper owns IDs, stable sorting, top-half pruning, and iteration logs. User-facing summaries should stay concise and natural; internal score tables are for auditability.
