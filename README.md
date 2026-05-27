# Higher Order

Higher Order is a Codex plugin that packages reusable skills for clearer agent work. It focuses on scoping, success criteria, deterministic writing, project structure, UI design, and explicit option narrowing.

This plugin provides guidance skills only. It does not install shell wrappers, hooks, package-manager policy files, or runtime command enforcement.

## Skills

- `pause-framework` scopes artifact-producing work before execution.
- `success-criteria` defines done, verification, evidence, and scope boundaries.
- `deterministic-writing` turns plans, specs, and change requests into unambiguous implementation text.
- `think` narrows options with a deterministic score-and-prune workflow.
- `project-architecture` guides repo, package, and service layout decisions.
- `ui-design` provides a compact checklist for UI specs and design reviews.

## Install

Add this repository as a local Codex marketplace:

```bash
codex plugin marketplace add /path/to/higher-order
```

Then start a new Codex thread so the updated skill list is loaded.

## Plugin Layout

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
