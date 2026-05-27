# Higher Order

Higher Order is a plugin that packages reusable skills for agent work.

It focuses on higher order thinking and integrated taste: scoping the real problem, sensing quality, choosing what not to do, and turning vague intent into useful artifacts.

The long-term goal is to not need this plugin. The goal is for users to read enough good agent messages that they realize the models already know how to figure things out on their own. They usually need less instruction than we think — but they do need to know what matters, why it matters, and what kind of result would feel right.

This plugin provides guidance skills only. It does not install shell wrappers, hooks, package-manager policy files, or runtime command enforcement.

## What this is for

Use Higher Order when the hard part is judgment, not syntax:

- making the task smaller without making it worse
- defining what good means before building
- choosing between plausible paths
- turning taste into constraints an agent can act on
- writing specs and plans that survive handoff
- reviewing structure, UI, and product decisions for fit

The skills are scaffolding. They are meant to shape the agent's messages until the desired behavior becomes obvious enough to ask for directly.

## Integrated taste

Taste means the agent can notice when an answer is technically correct but wrong for the moment.

Higher Order treats taste as the integration of:

- **intent** — what the user is really trying to make happen
- **context** — who this is for, where it lives, and what constraints matter
- **quality** — what would make the result feel clear, useful, and finished
- **restraint** — what should be removed, deferred, or left alone
- **fit** — whether the solution belongs in this product, repo, conversation, and moment

The best agent work should feel less like compliance with a checklist and more like a collaborator understanding the assignment.

## Skills

- `pause-framework` scopes artifact-producing work before execution.
- `success-criteria` defines done, verification, evidence, and scope boundaries.
- `integrated-taste` reviews whether the proposed answer fits the user's intent, context, quality bar, and moment.
- `deterministic-writing` turns plans, specs, and change requests into unambiguous implementation text.
- `think` narrows options with a deterministic score-and-prune workflow.
- `project-architecture` guides repo, package, and service layout decisions.
- `ui-design` provides a compact checklist for UI specs and design reviews.

## How to use it

Ask for the outcome and the taste bar, not just the procedure.

Good prompts:

```text
Use Higher Order to turn this idea into the smallest useful implementation plan.
```

```text
Review this proposal for taste: what feels overbuilt, under-specified, or wrong for the user?
```

```text
Define success before implementing this change, then keep the plan small.
```

```text
Think through these options and choose the one that best fits the product direction.
```

Over time, you should need the skill names less. The lasting habit is simpler:

```text
Here is what I want, why it matters, who it is for, and what would make it feel right.
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
