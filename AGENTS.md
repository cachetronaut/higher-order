# Repository Guidelines

## Coding Style & Naming Conventions

- Less code is better. Prefer deletion, simplification, and reuse over new code.
- Design for isolation. Each module, class, and function should have one clear purpose.
- Be clear. Write short docstrings only when behavior is not obvious.
- Prefer clarity over cleverness. Use descriptive names and avoid unnecessary abbreviations.
- Fail early. Use type hints and runtime validation where appropriate. Prefer explicit return types.
- Reuse shared definitions. Prefer constants, enums, and common utilities over duplicated literals.

## Build, Test, and Development Commands

- This repository packages Markdown guidance and a shell helper; it is not a Python project.
- Do not create a Python environment or run `ty` or Ruff for documentation-only changes.
- Validate the Claude plugin with `claude plugin validate . --strict`.
- Validate the Codex plugin with the installed plugin-creator validator.
- Validate changed skills with the installed skill-creator validator.
- Follow the global Python tooling policy when work actually involves a Python project.

## Commit & Pull Request Guidelines

- Commit early and often.
- Keep each commit focused on a single logical change.
- Use short, imperative commit messages, such as init or add auth validation.
- Every pull request should explain why the change exists in plain English.
- Include a concise summary of what changed and its impact.
- Link related issues whenever applicable.

## Verification Guidelines

- Test observable behavior, not implementation details.
- Prefer tests that verify outputs from known inputs.
- Add targeted unit tests for new behavior when practical.
- When tests are not practical, use assertions to validate behavior.
- Name tests after observable outcomes, such as test_rejects_missing_token.
- Run all relevant checks for the code you modify.
- For cross-cutting changes, run all affected test suites.
- Report any checks or tests that could not be executed.
