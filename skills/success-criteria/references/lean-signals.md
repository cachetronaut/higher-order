# Lean: Waste Signals

Quick-reference checklist for the **Stay Simple** step. Each signal indicates work, code, or complexity that is not earning its keep. If it doesn't serve the success criteria, remove it.

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

## Core Principles

1. State the smallest change that satisfies the requirement.
2. Build that, and only that.
3. Defer abstraction until a second real use case appears.
4. After the change works, delete code the change made obsolete.
5. Treat configuration, flags, and options as debt; add them only with a named owner and a removal condition.
6. Measure before optimizing; optimize only what the measurement proves is hot.

## Quality Checklist

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
