# Agent Plugin Shapes

## Purpose

Use this lesson when turning a local tool into an agent plugin for Codex, Claude Code, Cursor, or another coding-agent harness.

The plugin shape is not universal. Each agent has its own package manifest, marketplace format, hook model, and rules for exposing tools to shell commands. Do not assume that a plugin that loads in one agent enforces behavior in another agent.

## Core Lesson

A plugin has two separate jobs:

1. Teach the model what to do.
2. Change the runtime environment so the command actually behaves differently.

`SKILL.md` handles the first job. It gives the model reusable instructions.

Hooks, `bin/` wrappers, installer scripts, or agent-specific runtime APIs handle the second job. They decide whether a shell command such as `pnpm install`, `npm ci`, `uv sync`, or `pip install` is intercepted.

If a plugin only has `SKILL.md`, it can guide the agent. It cannot guarantee enforcement.

## Codex Shape

Codex plugin packaging should include:

- `.codex-plugin/plugin.json`
- `skills/<skill-name>/SKILL.md`
- `.agents/plugins/marketplace.json` when a local directory should be added with `codex plugin marketplace add <path>`

The Codex manifest can point at the skills directory:

```json
{
  "skills": "./skills/"
}
```

That makes the skill visible to Codex. It does not automatically prove that `bin/` wrappers are added to the shell `PATH`.

Treat Codex support as verified only after a real command run proves that the plugin runtime changes command execution. Until then, describe Codex support as guidance plus setup, not hard enforcement.

For local marketplace installation, the path passed to `codex plugin marketplace add` must be the marketplace root, not only a plugin root. The marketplace root is supported when it contains `.agents/plugins/marketplace.json`; that file can point at the plugin root with a portable local source path such as `./`.

`codex plugin marketplace upgrade` is for configured Git marketplaces. A local filesystem marketplace is refreshed by editing the local files directly or by removing and adding the marketplace again if the installed configuration needs to be recreated.

## Claude Code Shape

Claude Code plugin packaging should include:

- `.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json` when testing a local marketplace
- `hooks/hooks.json` when lifecycle hooks are needed
- `hooks/<script>` files for hook behavior
- `bin/` wrappers if command interception depends on `PATH`
- optional `skills/` content when model guidance is useful

For local marketplace testing, pass the path that Claude expects for the marketplace root. If the repo contains `.claude-plugin/marketplace.json`, adding the nested `.claude-plugin` directory can make Claude search for `.claude-plugin/.claude-plugin/marketplace.json`.

The safe default is to document the exact local install command after testing it on a clean checkout.

## Cursor Shape

Cursor plugin support should be treated as experimental until tested in the actual Cursor plugin runtime.

Potential files:

- `.cursor-plugin/plugin.json`
- `hooks/hooks-cursor.json`
- shared `hooks/` scripts
- shared `bin/` wrappers

Do not claim Cursor enforcement until a real package-manager command proves that Cursor exposes plugin commands, hooks, or environment changes to the agent-run terminal.

## Marketplace Shape

Marketplace metadata is a pointer layer. It tells the agent where a plugin lives and how to install it.

Local marketplace metadata should avoid machine-specific paths. Use relative paths inside the repo when possible.

Good:

```json
{
  "plugins": [
    {
      "name": "safe-install",
      "source": "./"
    }
  ]
}
```

Bad:

```json
{
  "source": "<absolute-local-path>/safe-install"
}
```

Never put personal paths, usernames, machine names, private repo names, or local account names in files that may be pushed to a public repo.

## Enforcement Shape

For security tools, the key question is not "does the plugin install?"

The key question is "does the risky command route through the protected path when the user or agent runs it normally?"

Verify with a dry run:

```sh
SAFE_INSTALL_DRY_RUN=1 pnpm install
SAFE_INSTALL_DRY_RUN=1 npm ci
SAFE_INSTALL_DRY_RUN=1 uv sync --locked
SAFE_INSTALL_DRY_RUN=1 pip install -r requirements.txt
```

Expected output should prove the command entered the protected wrapper. For container-backed install isolation, the output should show the container command, the project-only mount, and the disposable home directory.

## Hook Shape

Use startup hooks for visibility, not heavy work.

Good startup hook behavior:

- report whether protection is active
- show which package managers are wrapped
- tell the model what command to run for diagnostics

Bad startup hook behavior:

- start Docker or OrbStack during every session
- run package installs automatically
- mutate project files without a user command
- claim protection is active without checking the runtime

Lazy-start container runtimes at the moment of the protected install. This keeps low-memory machines usable.

## Verification Checklist

Before publishing a plugin repo:

- Run `rg -n "Users/|<local-user>|<machine-name>|<private-project>" . -g '!/.git/**'`.
- Install the plugin from a clean checkout.
- Run the agent's plugin validation command if one exists.
- Reload the agent plugin runtime.
- Run a dry-run protected command from a different repo.
- Confirm the command output proves interception.
- Confirm the same command does not need the user to `cd` into the plugin repo.
- Confirm the plugin does not require personal absolute paths.
- Confirm CI runs from a portable temp directory.
- Confirm the public commit history does not contain personal paths before pushing.

## Public Repo Rule

Clean the current tree before the first push.

If personal paths were committed before anyone cloned the repo, rewrite the public branch to a clean root commit and force-push with lease. This removes the leak from normal branch history.

If the repo already has users, do not rewrite history without a migration note. Remove the data in a new commit and rotate any secret that may have been exposed.

If the leaked value is sensitive, assume normal force-push is not enough. Ask the hosting provider to purge unreachable objects, or recreate the repo.
