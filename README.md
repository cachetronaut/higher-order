# Higher Order

Higher Order is a plugin that packages reusable skills for agent work.

It helps agents make their work legible: restating the user's intent, exposing assumptions, asking useful questions when the prompt has gaps, and showing enough of the decision path that the user can steer the work before it goes sideways.

The long-term goal is to not need this plugin. The goal is for users to read enough good agent messages that they realize the models already know how to figure things out on their own. They usually need less instruction than we think — but they do need to know what matters, why it matters, what constraints are real, and what kind of result would feel right.

This plugin provides guidance skills only. It does not install shell wrappers, hooks, package-manager policy files, or runtime command enforcement.

## What this is for

Use Higher Order when the hard part is not syntax, but shared understanding:

- turning vague prompts into scoped work
- asking the missing questions before building
- making assumptions visible instead of silently choosing defaults
- defining what "production ready" means for this user and this project
- showing the user the plan, rationale, tradeoffs, and checkpoints
- narrowing broad asks into the smallest useful next artifact
- connecting UI design taste with project architecture taste

Most users do not fail because they forgot the perfect framework. They fail because they ask for something like:

```text
Build me a production-ready app. Make no mistakes.
```

That prompt hides the real assignment. What kind of app? For whom? What is production? What data matters? What should be boring? What should feel polished? What should be skipped? What should the model ask before touching code?

Higher Order gives the agent reusable moves for surfacing those gaps.

## Visible work, not hidden thoughts

The point is not to dump raw chain-of-thought. The point is to show useful working state.

Good agent messages should make these things visible:

- **Interpretation** — what the agent thinks the user is asking for
- **Gaps** — what is missing, ambiguous, risky, or overloaded
- **Assumptions** — what the agent will assume if the user does not answer
- **Questions** — the few answers that would materially change the work
- **Plan** — the next concrete steps, in order
- **Rationale** — why this path fits better than the obvious alternatives
- **Checkpoint** — when the user should review before more work happens

This lets the user see what the model is saying and deciding without requiring the model to expose private reasoning tokens.

## Integrated taste

In Higher Order, integrated taste mainly lives at the intersection of `ui-design` and `project-architecture`.

A product can have a beautiful screen and a bad structure. It can also have a clean repo and an interface that feels generic, confused, or overbuilt. The better agent behavior is to connect both:

- Does the UI express the product's actual priority?
- Does the architecture make the desired interaction easy to evolve?
- Are the folders, routes, components, and data boundaries aligned with how the product should feel?
- Is the implementation small enough to stay understandable, but structured enough to survive the next step?

Taste is not decoration. It is the fit between what the user wants to build, how the product should feel, and how the codebase should support it.

## Skills

- `prompt-probing` turns vague or overloaded requests into targeted questions, assumptions, and safe next steps.
- `visible-work` makes the agent's interpretation, assumptions, rationale, and checkpoints visible to the user.
- `pause-framework` scopes artifact-producing work before execution.
- `success-criteria` defines done, verification, evidence, and scope boundaries.
- `deterministic-writing` turns plans, specs, and change requests into unambiguous implementation text.
- `think` narrows options with a deterministic score-and-prune workflow.
- `project-architecture` guides repo, package, and service layout decisions.
- `ui-design` provides a compact checklist for UI specs and design reviews.

## How to use it

Ask the agent to clarify the assignment and show its working state before it builds.

Good prompts:

```text
Use Higher Order to probe this app idea before implementing. Ask only the questions that would change the build.
```

```text
Restate what you think I want, name the assumptions you're making, then propose the smallest useful first version.
```

```text
Before coding, define what production-ready means for this project and what you are intentionally not building.
```

```text
Review the UI and project architecture together. Tell me where the product feel and code structure are misaligned.
```

Over time, you should need the skill names less. The lasting habit is simpler:

```text
Here is what I want, why it matters, who it is for, what constraints are real, and what would make it feel right.
```

## Install

Add this repository as a local Codex marketplace:

```bash
codex plugin marketplace add /path/to/higher-order
```

Then start a new Codex thread so the updated skill list is loaded.

## Plugin layout

```text
.codex-plugin/plugin.json
.agents/plugins/marketplace.json
skills/
reference/
```

Codex reads the plugin manifest from `.codex-plugin/plugin.json` and the skill entries from `skills/<skill-name>/SKILL.md`.

## Validate

Run the plugin validator from the Codex plugin-creator skill:

```bash
uv run --with PyYAML python /path/to/plugin-creator/scripts/validate_plugin.py /path/to/higher-order
```

Run the skill validator for each skill:

```bash
uv run --with PyYAML python /path/to/skill-creator/scripts/quick_validate.py /path/to/higher-order/skills/<skill-name>
```

## License

This repository is source-visible, all-rights-reserved software. Public visibility is not permission to copy, modify, or redistribute the contents. See `LICENSE`.
