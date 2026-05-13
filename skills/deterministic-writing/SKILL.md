---
name: deterministic-writing
description: Use when writing specifications, change requests, ticket comments, or document updates where the reader must implement the text exactly as written.
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

For the full 10-step document structure, see `references/steps.md`.  
For filler words to avoid and common mistakes, see `references/reference.md`.

## Quality Checklist

- [ ] `pause-framework` was executed first
- [ ] A developer can implement this without asking a question
- [ ] Every "if" has an "else"
- [ ] All field names, column names, and values are exact and in backticks
- [ ] The diagram matches the text
- [ ] The impact section answers "how does this help?"
- [ ] The proposed change includes concrete implementation steps
- [ ] Acceptance criteria are split into internal and external
- [ ] Person names are absent from the body, acceptance criteria, and dependencies
- [ ] Every word is eighth-grade readable
