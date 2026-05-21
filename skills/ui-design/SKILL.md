---
name: ui-design
description: Use when creating, reviewing, or updating a DESIGN.md file (or any UI spec / design doc) for a product, feature, or screen — provides a compact checklist of core UI principles to apply and pitfalls to avoid.
metadata:
  type: reference
---

# UI Design

## Overview

A compact reference for drafting `DESIGN.md` files. Synthesizes principles from Apple HIG, Ramotion, Octet, and Creative Bloq into a checklist. Use it as a scaffold for the doc and as a review pass before declaring the design "done."

**Core principle:** Clarity beats cleverness. The interface should disappear; the user's task should not.

**Card constraint:** Never use or suggest cards unless the user explicitly asks for them. Prefer native page structure, tables, lists, split panes, timelines, toolbars, sections, or direct spatial layout over card-based grouping.

## When to Use

- Starting a new `DESIGN.md` for a feature or screen
- Reviewing an existing UI spec before implementation
- Auditing a built UI against stated design intent

Skip for: pure visual/brand explorations, marketing pages, one-off prototypes with no shared spec.

## Platform Deference

If the target is iOS, macOS, Android, or Windows, **link to the official HIG / Material / Fluent guidelines** instead of duplicating them here. This skill covers cross-platform fundamentals only.

## The Seven Principles (CHIFASS)

| Principle | Question to answer in the doc |
|-----------|-------------------------------|
| **C**larity | Is every label, icon, and state unambiguous? Can a first-time user name what each element does? |
| **H**ierarchy | What is the single primary action per screen? Does size, weight, color, and placement reflect importance? |
| **I**nvariance (consistency) | Do typography, spacing, color, and component behavior match the rest of the product? Same word for same thing. |
| **F**eedback | Does every action produce visible response within 100ms? Are loading, success, error, and empty states defined? |
| **A**ccessibility | Contrast ≥ WCAG AA (4.5:1 text). Hit targets ≥ 44pt. Works with keyboard, screen reader, and at 200% zoom. |
| **S**implicity | What can be removed without losing the task? Defer choices; pre-fill defaults; hide rarely-used options; avoid cards unless explicitly requested. |
| **S**afety (forgiveness) | Are destructive actions reversible or confirmed? Do errors explain what to do next, not just what went wrong? |

## Recommended `DESIGN.md` Skeleton

```markdown
# <Feature> — UI Design

## 1. Purpose & primary user task
One sentence. The job the screen exists to do.

## 2. Users & context
Who, on what device, under what conditions.

## 3. Primary action
The one thing the screen optimizes for.

## 4. Screens & states
For each screen: default, loading, empty, error, success.

## 5. Component inventory
Reused components (link to design system) + new ones. Do not introduce cards unless the user explicitly requested them.

## 6. Interaction & feedback
What happens on tap/hover/submit. Latency budgets.

## 7. Accessibility notes
Contrast, hit targets, keyboard order, screen-reader labels.

## 8. Open questions
Decisions deferred, with owner and deadline.
```

## Review Checklist (run before marking the doc done)

- [ ] Primary action is named and visually dominant on every screen
- [ ] All four non-default states defined: loading, empty, error, success
- [ ] No element exists without a reason tied to the primary task
- [ ] No cards are used or suggested unless the user explicitly requested cards
- [ ] Copy uses the user's vocabulary, not the team's
- [ ] Defaults are pre-filled where a sensible default exists
- [ ] Destructive actions are reversible OR confirmed (never both bypassed)
- [ ] Contrast, hit-target, and keyboard path are stated, not assumed
- [ ] Platform-specific guidance is linked, not paraphrased
- [ ] Open questions list is non-empty OR explicitly empty (no silent gaps)

## Red Flags

- "Users will figure it out" — clarity isn't optional
- More than one primary action per screen
- Cards suggested by default, or used as a generic grouping device without an explicit user request
- Error message that blames the user
- A novel pattern where a familiar one would do
- Empty state that is literally empty (dead-end)
- Spec describes happy path only
