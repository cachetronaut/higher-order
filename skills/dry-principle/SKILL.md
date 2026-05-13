---
name: dry-principle
description: Use when writing or modifying code that may duplicate logic, constants, schemas, or validation — to determine whether extraction to a single source of truth is warranted.
---

# DRY Principle (Don't Repeat Yourself)

## Overview

Every concept, rule, or logic has exactly one authoritative representation. Distinguish semantic duplication from coincidental similarity; extract only when duplication is confirmed.

**Precondition:** Run `pause-framework` first to determine conceptual boundaries before any duplication decision.

## Core Pattern — Rule of Two

| Occurrences | Action |
|-------------|--------|
| 1 instance | Keep inline — do nothing |
| 2 instances | Evaluate: is this semantic duplication or coincidental similarity? |
| 3+ instances | Extract to a single source of truth immediately |

**Semantic duplication** (extract): same rule, same transformation, same domain concept redefined across files, copy-paste with only superficial variation.

**Not a violation** (leave separate): similar structure with different intent, shared syntax but different domain meaning, implementations that diverge by design.

## Application Steps

1. Run `pause-framework` to determine conceptual boundaries.
2. Identify whether duplication is semantic or incidental (see table above).
3. At 2+ confirmed semantic duplicates, extract to a single source.
4. Replace all prior duplicates with references to the new source.
5. Name the extracted unit by domain concept, not file location or caller name.

If duplication is unclear or the semantic boundary is ambiguous — stop, re-run `pause-framework`, re-evaluate before proceeding.

## Quality Checklist

- [ ] `pause-framework` was executed first
- [ ] Duplication is semantic, not superficial
- [ ] Rule of Two was respected — no extraction at a single occurrence
- [ ] All prior duplicates replaced with references to the new source
- [ ] Name reflects conceptual meaning, not location or caller

## Common Mistakes

| Anti-pattern | Fix |
|--------------|-----|
| Extracting after a single occurrence | Wait for a second confirmed semantic duplicate |
| Forcing reuse across unrelated domains | Check domain meaning, not syntax |
| Naming the abstraction after a file or caller | Name by domain concept or business meaning |
| Creating an abstraction with one consumer | Requires ≥2 confirmed consumers |
| Applying DRY to one-off, experimental, or throwaway code | Skip — DRY applies only to long-lived, reusable logic |
