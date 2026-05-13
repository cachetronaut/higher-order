---
name: lean-principle
description: Use when starting new work, reviewing a change, extending an existing feature, or evaluating whether a proposed abstraction, option, or workflow step belongs.
---

# Lean Principle

## Overview

Every line of code is a liability until it earns its keep. Remove anything — code, abstractions, documents, processes — that does not contribute to the current goal.

**Precondition:** Run `pause-framework` first. PAUSE exposes what is and is not needed:
- Purpose → the smallest outcome the current task requires
- Audience → who actually needs what is being built
- Usage → whether the code will run today or only in theory
- Settings/Security → which options exist because they are needed, not speculated
- Exceptions → what appears necessary but is not yet justified by a real caller

## Core Pattern — Apply Lean

1. State the smallest change that satisfies the requirement.
2. Build that, and only that.
3. Defer abstraction until a second real use case appears.
4. After the change works, delete code the change made obsolete.
5. Treat configuration, flags, and options as debt; add them only with a named owner and a removal condition.
6. Measure before optimizing; optimize only what the measurement proves is hot.

## Waste Signals

- Dead code and unreferenced exports
- Abstractions with a single implementation and no roadmap for a second
- Configuration options that have never been changed
- Tests that duplicate each other or test the framework
- Comments that restate the code
- Features behind flags that were never flipped on
- Helper functions used exactly once
- Parameters that are always passed the same value
- Retry logic around calls that never fail

## Quality Checklist

- [ ] `pause-framework` was executed first
- [ ] No dead code, unused imports, or unreferenced exports introduced
- [ ] No abstractions added without at least two concrete callers
- [ ] No configuration options added without a named owner
- [ ] Optimizations are tied to a measured bottleneck, not a guess

## Common Mistakes

| Anti-pattern | Fix |
|--------------|-----|
| Pre-building for requirements not yet asked for | Build only what the current task requires |
| Keeping code "just in case" | Delete it; version control preserves history |
| Adding a feature flag without a removal plan | Require a named owner and retirement condition |
| Optimizing without a measurement | Profile first; only optimize what is proven hot |
| Generalizing a function the first time it is used | Wait for a second real caller before extracting |
