# Document Structure — 10-Step Process

Follow these steps in order when producing a specification, change request, or ticket.

1. Write the header block: scope, priority, assignee, status.
2. Write the problem in past tense for observed behavior, present tense for current state.
3. Write the impact in 1–3 sentences answering "how does this change improve the system?"
4. Write the proposed change in imperative tense, pairing each fix with a concrete spec or code change.
5. Write the implementation: code path, what to create or modify, and how to verify.
6. Produce diagrams for current state and proposed state.
7. Add a text-based decision tree after the diagram if branches are complex.
8. Split acceptance criteria into internal checks and external checks with specific values.
9. List dependencies using role titles, not person names.
10. Run the quality checklist before publishing.

## Diagram Rules

- One action per box; do not combine actions.
- One condition per diamond; split AND/OR into sequential diamonds.
- Label every arrow so the reader follows the diagram without surrounding text.
- Show all terminal states; end every path in a defined outcome.
- Quote diagram text that contains special characters.
- Reference other steps by link or mention, not by hardcoded name.
