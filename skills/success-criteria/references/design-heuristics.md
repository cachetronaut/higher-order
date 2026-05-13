# Design Heuristics: DRY + ETC

Quick-reference for the **Stay Simple** and **Create Checkpoints** steps. Two complementary lenses on the same question: "should I add this abstraction, and will it make the system easier or harder to change?"

---

## DRY — Don't Repeat Yourself

Every concept, rule, or logic has exactly one authoritative representation. Extract only when duplication is confirmed semantic, not coincidental.

### Semantic vs. Coincidental Duplication

| Type | Description | Action |
|------|-------------|--------|
| **Semantic** | Same rule, same transformation, same domain concept redefined across files; copy-paste with superficial variation | Extract |
| **Coincidental** | Similar structure with different intent; shared syntax but different domain meaning; implementations that diverge by design | Leave separate |

If the distinction is unclear, leave it separate. Premature extraction couples unrelated code.

### Rule of Two

| Occurrences | Action |
|-------------|--------|
| 1 instance | Keep inline — do nothing |
| 2 instances | Evaluate: semantic or coincidental? |
| 3+ instances | Extract to a single source of truth immediately |

### Extraction Rules

- Name the extracted unit by domain concept, not file location or caller name.
- Replace all prior duplicates with references to the new source.
- Skip DRY for one-off, experimental, or throwaway code.

### Common Mistakes

| Anti-pattern | Fix |
|--------------|-----|
| Extracting after a single occurrence | Wait for a second confirmed semantic duplicate |
| Forcing reuse across unrelated domains | Check domain meaning, not syntax |
| Naming the abstraction after a file or caller | Name by domain concept or business meaning |
| Creating an abstraction with one consumer | Requires ≥ 2 confirmed consumers |

---

## ETC — Easier To Change

Good design makes change cheap; bad design makes change expensive. Evaluate every structural decision on whether it leaves the system easier or harder to modify.

### The Changeability Test

1. List the most likely future changes.
2. For each, count the files that would need to move.
3. If the count is high, restructure until the change is local.

### Design Rules

- Push volatile details to the edges; keep stable concepts at the core.
- Introduce an interface only when a second implementation is real or imminent.
- Name things by concept, not by current implementation detail.

### Violation Signals

- Changing one behavior requires edits in unrelated files
- A single rename cascades through many modules
- Business rules baked into framework-level code
- Stable code depending on volatile code
- Configuration hardcoded instead of injected
- Side effects in constructors

### Common Mistakes

| Anti-pattern | Fix |
|--------------|-----|
| Designing for imagined flexibility with no current signal | Wait for a real second use case |
| Adding interfaces, factories, or plugins before a second consumer | Introduce abstractions only when two consumers exist |
| Hardcoding values that have already varied once | Extract to configuration or injection |
| Burying business rules in infrastructure or framework code | Keep domain logic in the domain layer |
