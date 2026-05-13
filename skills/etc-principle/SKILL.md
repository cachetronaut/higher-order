---
name: etc-principle
description: Use when making any structural decision — naming, module boundary, dependency direction, data shape, API signature, or default behavior — to evaluate whether the design preserves the ability to change.
---

# ETC Principle (Easier To Change)

## Overview

Good design makes change cheap; bad design makes change expensive. Evaluate every structural decision on whether it leaves the system easier or harder to modify.

**Precondition:** Run `pause-framework` first. PAUSE reveals what must stay flexible:
- Purpose → what the design must continue to serve as requirements evolve
- Audience → who will maintain and extend it
- Usage → how often and how widely it will be touched
- Settings/Security → environmental assumptions the design encodes
- Exceptions → likely future changes the default design does not accommodate

## Core Pattern — Apply ETC

1. Before committing a design, list the most likely future changes.
2. For each likely change, count the files that would need to move.
3. If the count is high, restructure until the change is local.
4. Push volatile details to the edges; keep stable concepts at the core.
5. Introduce an interface only when a second implementation is real or imminent.
6. Name things by concept, not by current implementation detail.

## Violation Signals

- Changing one behavior requires edits in unrelated files
- A single rename cascades through many modules
- Business rules baked into framework-level code
- Stable code depending on volatile code
- Configuration hardcoded instead of injected
- Side effects in constructors

## Quality Checklist

- [ ] `pause-framework` was executed first
- [ ] A likely future change touches a small, bounded set of files
- [ ] No module depends on a detail it does not use
- [ ] Renaming a concept is a single refactor
- [ ] New implementations can be added without modifying existing ones

## Common Mistakes

| Anti-pattern | Fix |
|--------------|-----|
| Designing for imagined flexibility with no current signal | Wait for a real second use case |
| Adding interfaces, factories, or plugins before a second use case exists | Introduce abstractions only when two consumers exist |
| Hardcoding values that have already varied once | Extract to configuration or injection |
| Burying business rules in infrastructure or framework code | Keep domain logic in the domain layer |
