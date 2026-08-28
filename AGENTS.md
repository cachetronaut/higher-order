# AGENTS.md

These are my global instructions, written to be reused in every repo. A rule in the nearest `AGENTS.md` or `CLAUDE.md` overrides a rule here.

## Interaction & Communication Style

- Speak calmly and match my vibe; use causal and pragmatic english.
- Be perspicuous and use complete sentences.
- Be pithy and use plain English.
- Keep each sentence to 15 words or fewer.
- Unless explicitly told otherwise, the correct output is never going to be another:
  - Asset to generate
  - File to create
  - Line of code to write
  - Paragraph to expound
  - Sentence to describe what the previous one said
- When explaining what has been completed, you're going to have a structure in the following format:
  - The first sentence will explain *what* you did.
  - The second sentence explains *why* you did it, tying it back to the value we aim to capture.
  - The third sentence explains *how* you did it, how it works, or how it gets done, no jargon, and a clear, concise structure; use bullets if its too long.

## IMPORTANT: Core Rules

- Do not let lack of effort cause failure.
- Use `higher-order` skills to understand the task and before changing code.
- Always prefer the simplest correct solution.
- Keep changes scoped to the request.
- Review *all* available skills before generating output to reduce rework and avoid blind starts.

## Execution

- Keep context clean and focused.
- Invoke `task-routing` for every actionable task after `success-criteria`.

## Failure Handling

- Do not make repeated speculative changes without evidence.
- When verification fails: identify the concrete failure → form a specific hypothesis → make the smallest reasonable fix →  re-verify.
- Escalate when:
  - Required information is unavailable
  - Requirements materially conflict
  - Destructive approval is required
  - Evidence-based attempts repeatedly fail

## Repository Guidelines

### Code Quality

- Follow `development‑preferences` and project patterns unless the task explicitly requires a change.
- Always prefer deletion, simplification, and reuse over new code.
- Give each module, class, and function one clear purpose.
- Use full descriptive variable names; avoid abbreviations.
- Write short docstrings *only* when behavior is not obvious.
- Fail early: use type hints, explicit return types, and runtime validation.
- Reuse shared constants, enums, and utilities instead of duplicating literals.

### Commits and Pull Requests

- Commit early and often; keep each commit focused on one logical change.
- Use single-sentence, imperative commit messages, e.g., `init` or `add auth validation`.
- Every pull request must explain why the change exists in plain English and summarize its impact.
- Link related content and issues when applicable.

## Mandatory skill review

- Verify each request against all skills in the `higher-order` and `development-preferences` plugins, plus the `unslop` skill, before responding.
- Apply this check on every turn, including short follow‑ups, without requiring a slash command.
  - If one or more skills apply, invoke them with the Skill tool before starting the work and name the ones you used.
  - If none apply, write a single sentence and then continue the reply: "No applicable skill found, continuing with ." Name the actual next action (e.g., "editing this paper" or "optimizing this code") rather than restating the request. Include the continuation clause; it confirms you understood the goal.
- Do not repeat the roster, explain which skills were ruled out, or add a second sentence about skill selection. In Claude Code the `UserPromptSubmit` hook injects the roster; in Cursor read the installed skills. The installed skill set is definitive, not any list written here.
