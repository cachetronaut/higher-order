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

## Craft-Level Rules

The principles above answer *what* and *why*. These answer *how* — the concrete decisions that separate work that looks intentional from work that looks default. Apply them when specifying components and visuals.

### Signifiers — the UI should speak without words
Communicate how something works through appearance, not instructions. Grouping inside a container = related. Filled background on a tab = selected. Greyed out = inactive. Hover/press states, active-nav highlights, tooltips, and disabled states are all signifiers. If a user has to stop and think about how an element works, the signifier failed.

### Hierarchy — three tools only: size, position, color
The most important thing gets the most visual weight. Primary item large/bold at top; secondary metadata smaller below; a single accent (often a contrasting color like blue) draws the eye to one key value. If everything is the same size, weight, and color, it reads like a spreadsheet — no entry point for the eye.

### Grids & whitespace — 4-point spacing system
A 12-column grid earns its keep only in structured, repeating content (galleries, tables, blogs) where it makes responsive behavior predictable (12 desktop → 8 tablet → 4 mobile). Custom layouts need not align to any grid. What matters more is whitespace on a **4-point system** (every value a multiple of 4, so it always halves cleanly):
- **32px** between sections
- **16px** between related elements
- **8px** for type groupings

### Typography — one font
One good sans-serif (e.g. Inter, Plus Jakarta Sans) carries ~90% of work. Don't fall into the font rabbit hole. For large text, tighten letter-spacing to ≈ −2 to −3% and drop line-height to ≈ 110–120% so headers feel intentional. Landing pages can range up to ~6 sizes; dashboards stay tight — rarely above 24px, because information density beats drama.

### Color — with intent, not decoration
Start with one primary (brand) color; lighten it for backgrounds, darken it for text — that alone gets ~80% of a cohesive palette. Grow toward a full color ramp for chips/states/charts. Anchor on **semantic color**: blue = trust, red = error/danger, yellow = warning, green = success. If a design feels boring and you reach for color to fix it, that's a hierarchy problem, not a color problem.

### Dark mode — layering, not inverted light mode
Don't just flip colors. In dark mode shadows barely register, so depth comes from **value layering**: elevated surfaces are *lighter* than the background, not shadow-casting. Pull back border opacity — a border that's subtle in light mode is too strong on dark. Dark mode invites rich hues (deep purples, rich greens, warm reds), not just navy/grey.

### Shadows — suggest depth, don't announce it
If the shadow is the first thing you notice, it's too strong: lower opacity, increase blur. A resting card gets a very light shadow; a floating modal/popover gets a heavier one to signal higher elevation. Inner + outer shadows combined create tactile raised-button effects for interactive elements.

### Icons & buttons — size right, then build states
Match icon size to the line-height of its paired text (24px line-height → 24px icon) so they optically align. Button padding rule of thumb: width ≈ 2× height. Every button (and input) ships with at least four states: **default, hover, active/pressed, disabled**. A one-state button is not done.

### Interactive feedback — every action gets a response
Inputs need focus, error (red border + message), and sometimes warning states. Show loading spinners while fetching, success messages on completion. Go further with **micro-interactions**: e.g. a copy button whose "Copied" chip slides up and fades — that closes the loop and makes the product feel polished. Feedback confirms; micro-interaction delights.

### Overlays — gradients, not flat fills
For text over an image, never drop a flat dark fill. Use a linear gradient: fully transparent at top (image breathes) fading to a solid legible color where the text sits. For a modern touch, layer a progressive blur at the top of the gradient so the text feels like it belongs.

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
Reused components (link to design system) + new ones. Do not introduce cards unless the user explicitly requested them. For each interactive component, list its states (default, hover, active/pressed, disabled, focus, error).

## 6. Interaction & feedback
What happens on tap/hover/submit. Latency budgets. Micro-interactions that close the loop.

## 7. Visual system
Font (one, sans-serif), type scale, spacing (4-point: 32 / 16 / 8), primary + semantic colors, shadow elevation levels, dark-mode layering if applicable.

## 8. Accessibility notes
Contrast, hit targets, keyboard order, screen-reader labels.

## 9. Open questions
Decisions deferred, with owner and deadline.
```

## Review Checklist (run before marking the doc done)

- [ ] Primary action is named and visually dominant on every screen (size + position + color)
- [ ] Each element's role is communicated by a signifier, not by an instruction
- [ ] All four non-default states defined: loading, empty, error, success
- [ ] Every interactive component lists its states (default, hover, active, disabled, focus)
- [ ] No element exists without a reason tied to the primary task
- [ ] No cards are used or suggested unless the user explicitly requested cards
- [ ] Spacing follows a 4-point system; whitespace is intentional, not eyeballed
- [ ] One font; type scale stated; large text has tightened tracking/line-height
- [ ] Colors are semantic (blue/red/yellow/green) and serve a purpose, not decoration
- [ ] Shadows suggest depth (light for cards, heavier for modals); none shout
- [ ] Dark mode (if any) uses value layering, not just inverted light mode
- [ ] Image-overlay text uses a gradient, not a flat fill
- [ ] Copy uses the user's vocabulary, not the team's
- [ ] Defaults are pre-filled where a sensible default exists
- [ ] Destructive actions are reversible OR confirmed (never both bypassed)
- [ ] Contrast, hit-target, and keyboard path are stated, not assumed
- [ ] Platform-specific guidance is linked, not paraphrased
- [ ] Open questions list is non-empty OR explicitly empty (no silent gaps)

## Red Flags

- "Users will figure it out" — clarity isn't optional
- More than one primary action per screen
- Everything the same size, weight, and color — reads like a spreadsheet
- Cards suggested by default, or used as a generic grouping device without an explicit user request
- Reaching for color to fix a "boring" design (it's a hierarchy problem)
- A shadow that's the first thing you notice — it's too strong
- Dark mode built by inverting light mode instead of layering values
- Spacing eyeballed instead of following a consistent scale
- More than one font family without a real reason
- A button (or input) shipped with only a default state
- Flat dark fill behind text on an image instead of a gradient
- Error message that blames the user
- A novel pattern where a familiar one would do
- Empty state that is literally empty (dead-end)
- Spec describes happy path only
