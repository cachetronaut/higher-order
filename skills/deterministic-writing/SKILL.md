---
name: deterministic-writing
description: Use when writing specifications, change requests, ticket comments, or document updates where the reader must implement the text exactly as written. Also use when specs are vague, readers keep asking clarifying questions, or tickets bounce back due to ambiguity.
---

# Deterministic Technical Writing

## Overview

Write so that a developer, non-native English speaker, or automated system can implement every sentence without asking a question. Ambiguity is a defect.

Before writing, use `pause-framework` only when material ambiguity about the document's purpose, audience, use, constraints, or exceptions could change its content. Use `success-criteria` only when completion or verification is unclear. Neither skill is a mandatory precondition.

## Core Principles

| Principle | Rule |
|-----------|------|
| **One idea per sentence** | Split conditions and actions into separate lines |
| **Name everything exactly** | Wrap field, column, and value names in backticks |
| **Every "if" has an "else"** | State what happens when the condition is NOT met |
| **Eighth-grade reading level** | No idioms, metaphors, figurative language, or cultural references |
| **Imperative for actions** | Write "do X," not "could you do X" |
| **Conclusion first** | Lead comments and messages with the answer, not the context |
| **Diagram wins on conflict** | If the diagram and text disagree, fix the text |
| **Natural agreements** | Convert framework checks into plain sentences instead of acronym headers or labeled fields |

For the full 10-step document structure, see `references/steps.md`.  
For filler words to avoid and common mistakes, see `references/reference.md`.

## Natural Working Agreements

When another skill calls for a visible working agreement, write it as one natural paragraph. Do not expose framework mnemonics, repeated labels, or checklist headings unless the user asks to inspect the framework.

Use this shape:

```text
I’ll produce <result> for <audience or consumer> within <material constraints>. This is complete when <end state>, demonstrated by <observable evidence>, and I’ll keep the work bounded to <scope>.
```

Avoid this shape:

```text
Purpose: ...
Audience: ...
Success criteria: ...
```

The user-facing output should read like a concise working agreement, not evidence that a framework ran.

## Relationship to Other Skills

These skills are independent and may be combined when their own descriptions match.

- **pause-framework** clarifies what is being written, for whom, and under which material constraints when those facts are ambiguous.
- **success-criteria** defines completion and verification when they are missing.
- **deterministic-writing** expresses the resulting specification so its reader can act without guessing.

When both related skills apply, produce one natural working-agreement paragraph. When neither applies, write the requested specification directly.

## Quality Checklist

- [ ] Any required working agreement is written naturally rather than as framework fields
- [ ] A developer can implement this without asking a question
- [ ] Every "if" has an "else"
- [ ] All field names, column names, and values are exact and in backticks
- [ ] The diagram matches the text
- [ ] The impact section answers "how does this help?"
- [ ] The proposed change includes concrete implementation steps
- [ ] Acceptance criteria are split into internal and external
- [ ] Person names are absent from the body, acceptance criteria, and dependencies
- [ ] Every word is eighth-grade readable
