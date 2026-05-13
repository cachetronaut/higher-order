# Poka-Yoke: Weak Point Signals

Quick-reference checklist for the **Create Checkpoints** step. Each signal indicates a design point where the wrong action can happen silently. Apply the failure-path hierarchy: Eliminate > Prevent > Replace/Simplify > Detect > Review/Recover.

## Weak Point Signals

- Raw primitives where a domain type would encode constraints
- Optional parameters that silently change behavior
- Functions with more than one reason to fail
- Exceptions caught broadly and swallowed
- Asynchronous flows without acknowledged completion
- Shared mutable state
- APIs that require methods to be called in a specific order
- Retries around non-idempotent operations
- Errors represented as nullable return values

## Design Rules

1. Encode invariants in types: make illegal states unrepresentable.
2. Replace optional flags with distinct, named operations.
3. Validate inputs at the boundary; trust them inside.
4. Make required sequences enforceable by the type system or builder pattern.
5. Prefer named exceptions over silent nulls or sentinel values.
6. Make idempotency explicit for any operation that may be retried.
7. Log and alert on every path that discards an error.

## Quality Checklist

- [ ] No silent failure paths on any critical operation
- [ ] Boundary inputs validated exactly once, at the boundary
- [ ] Every retry loop wraps an idempotent operation
- [ ] No overloaded flags that change a function's contract
- [ ] Invariants enforced by types where the language allows

## Common Mistakes

| Anti-pattern | Fix |
|--------------|-----|
| Relying on documentation to prevent misuse | Enforce the constraint in code instead |
| Catching broad exceptions and continuing | Catch narrowly; let unknown errors propagate |
| Using null or sentinel values to signal errors | Use named exceptions or Result types |
| Allowing temporal coupling without structural enforcement | Use builder patterns or type-state to enforce order |
