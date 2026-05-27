---
name: deterministic-writing
description: Use when writing specifications, change requests, ticket comments, or document updates where the reader must implement the text exactly as written. Also use when specs are vague, readers keep asking clarifying questions, or tickets bounce back due to ambiguity.
---

# Deterministic Technical Writing

## Overview

Write so that a developer, non-native English speaker, or automated system can implement every sentence without asking a question. Ambiguity is a defect.

**Precondition:** Run `pause-framework` first. PAUSE scopes what must be said:
- Purpose → the smallest outcome the document must produce
- Audience → who reads it and what they do not know
- Usage → whether this is a one-time ticket, a recurring spec, or a stakeholder summary
- Settings/Security → invariants, permissions, and naming conventions that must appear
- Exceptions → branches, failure paths, and descoped items that must be stated explicitly

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
| **Natural statebacks** | Convert framework checks into plain sentences instead of acronym headers or labeled fields |

For the full 10-step document structure, see `references/steps.md`.  
For filler words to avoid and common mistakes, see `references/reference.md`.

## Natural Stateback Contract

When another skill requires an explicit stateback, write the result as one or two natural paragraphs. Do not expose framework mnemonics, repeated labels, or checklist headings unless the user asks to inspect the framework.

Use this shape:

```text
This is done when <end state>, so <user value>, with success proven by <observable evidence> and bounded to <scope>.

I will <first checkpoint>, then <implementation or analysis step>, then <validation step>, using <evidence source> as the audit trail and avoiding <out-of-scope work>.
```

Avoid this shape:

```text
S - Seek success: ...
U - Uncover utility: ...
C - Choose criteria: ...
```

The internal reasoning can still use structured prompts and mnemonic checks. The user-facing output should read like a concise work contract.

## Relationship to Other Skills

**PAUSE → SUCCESS → Deterministic Writing** — a pipeline, not alternatives.

- **pause-framework** — Run first. PAUSE scopes the document: what to say, for whom, under what constraints. Deterministic writing cannot begin without a scoped purpose and audience.
- **success-criteria** — Run after PAUSE. SUCCESS defines how you'll know the document is done and how to verify it. The quality checklist below covers writing quality; SUCCESS covers task completion.

PAUSE answers *what are we writing and for whom?* SUCCESS answers *how do we know it's done?* This skill answers *how do we write it so the reader never has to ask a question?*

## Quality Checklist

- [ ] `pause-framework` was executed first
- [ ] Required statebacks are written as natural sentences, not acronym expansions
- [ ] A developer can implement this without asking a question
- [ ] Every "if" has an "else"
- [ ] All field names, column names, and values are exact and in backticks
- [ ] The diagram matches the text
- [ ] The impact section answers "how does this help?"
- [ ] The proposed change includes concrete implementation steps
- [ ] Acceptance criteria are split into internal and external
- [ ] Person names are absent from the body, acceptance criteria, and dependencies
- [ ] Every word is eighth-grade readable
