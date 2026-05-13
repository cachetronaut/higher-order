---
name: project-architecture
description: >
  Guide for structuring software projects, repositories, and codebases in any language or stack.
  Use this skill whenever the user asks about project layout, folder structure, repo organization,
  scaffolding a new project, or choosing between architectural patterns (domain-first vs layer-first
  vs monorepo). Trigger on phrases like "project structure", "folder layout", "repo setup",
  "how to organize", "where should I put", "schemas vs models", "src layout", or when starting
  any new service, library, CLI, desktop app, or full-stack application from scratch. Also trigger
  when the user is debating file organization, asking where models/schemas/routes/services should
  live, reviewing an existing repo structure, or building a multi-app workspace. Applies to Python,
  TypeScript, Go, Rust, and polyglot monorepos equally. If the user mentions "set up a new project",
  "best way to organize my code", or pastes a directory tree for review, use this skill.
---

# Project Architecture

Distilled from FastAPI, Pydantic, PydanticAI, LangChain, httpx, Next.js, Tauri, Turborepo,
SolidJS, and community best practices across Python, TypeScript, Go, and Rust ecosystems.

## When to consult this skill

- User is scaffolding a new project or service (any language)
- User asks "where should X go?" about code organization
- User is choosing between layout patterns
- User asks about models vs schemas vs entities vs types
- User needs a project template or starter structure
- User pastes a directory tree and wants feedback
- User is setting up a monorepo with multiple apps/packages

For language-specific templates and tooling, read the appropriate reference:
- Python (FastAPI, libraries, CLI tools): `references/python.md`
- TypeScript/JS (web apps, Node services, monorepos): `references/typescript.md`
- Polyglot / Desktop apps (Tauri, Electron, mixed stacks): `references/polyglot.md`

---

## 1. The Universal Decision: Root Layout

Every project faces the same first question regardless of language.

### Flat Layout
```
my_package/
├── main.{ext}
├── models.{ext}
└── ...
tests/
```

Use when: Single-purpose library, CLI tool, quick prototype, solo dev.

Pros: Zero nesting, fast to start.
Cons: Doesn't scale past ~20 modules. In some languages (Python), can cause import shadowing.

### src Layout
```
src/
└── my_package/
    └── ...
tests/
```

Use when: Anything going to production. Any library you'll distribute. Any team project.

Pros: Clean separation of importable code from scaffolding. In Python, forces install before tests (catches packaging bugs). In TS, aligns with `tsconfig` path mapping.
Cons: Extra directory level.

### Workspace / Monorepo
```
apps/
├── web/
├── mobile/
└── api/
packages/
├── shared/
└── config/
```

Use when: Multiple deployable apps sharing code. Framework ecosystems. Team boundaries align with package boundaries.

Pros: Single lockfile, atomic cross-package changes, shared CI.
Cons: Tooling overhead (workspace config, cross-package version sync).

**Default: Use `src/` for single packages, workspace for multi-app projects.**

---

## 2. Three Internal Architectures (Language-Agnostic)

### A. Layer-First (by file type)

```
src/
├── routes/       (or controllers/, handlers/, api/)
├── models/       (or entities/)
├── schemas/      (or types/, dtos/)
├── services/     (or usecases/)
├── repos/        (or data/, dal/)
└── config/
```

Best for: Small services (< 5 domains), single-person ownership, tutorials, microservices that do one thing.

Fails when: 10+ domains. Adding a feature means touching every directory. PRs sprawl, merge conflicts spike. Extracting or deleting a feature requires surgery across the tree.

### B. Domain-First (by feature / bounded context)

```
src/
├── auth/
│   ├── routes.{ext}
│   ├── schemas.{ext}
│   ├── models.{ext}
│   ├── service.{ext}
│   └── ...
├── billing/
│   └── ... (same shape)
├── core/           # Shared infra (config, db, logging)
└── shared/         # Cross-cutting utils
```

Best for: Medium-to-large apps (5+ domains), growing teams, monoliths. Add a feature = add one folder. Delete = delete one folder. PRs stay scoped.

Fails when: Very small apps where per-domain boilerplate is overkill for 3 endpoints. Also when deep cross-domain queries make boundaries feel artificial.

### C. Hybrid Domain-First (domain-first at top, layer-first within)

```
src/
├── cascade/            # Domain
│   ├── stages/         # Layer within domain
│   │   ├── heuristic
│   │   ├── classify
│   │   └── draft
│   ├── types/          # Layer within domain
│   ├── shapes/         # Layer within domain
│   ├── pipeline
│   └── trace
├── connectors/         # Domain
│   ├── backends/       # Layer within domain
│   ├── executors/
│   └── normalizers/
├── core/
└── shared/
```

Best for: Domains that are internally complex enough to warrant sub-structure. This is the most common real-world pattern in production codebases. Each domain is its own mini-project.

This is what well-structured projects like Komodo's sidecar actually use.

### D. Monorepo Multi-Package

```
packages/
├── core/            # Stable abstractions
├── community/       # Integrations
└── main/            # Primary package
```

Best for: Framework ecosystems (LangChain, PydanticAI). Users install subsets. Independent release cycles.

---

## 3. The Naming Problem: Models vs Schemas vs Types vs Entities

The word "model" is the most overloaded term in software. Establish a glossary early.

| Concept | Common Names | What It Is | Rule |
|---------|-------------|------------|------|
| DB record | model, entity, record | ORM table / persistence shape | Lives in `models.{ext}` or `db/models.{ext}` |
| API contract | schema, DTO, type, response | Request/response shape for I/O | Lives in `schemas.{ext}` or `types.{ext}` |
| Domain object | entity, domain model | Pure business logic, no framework deps | Lives in `service.{ext}` or `entities.{ext}` |
| LLM/ML model config | model, llm_model | AI model wrappers or config | Lives in `llm.{ext}` or `models/llm.{ext}` |

**Rules:**
- Never put two meanings of "model" in the same file.
- If your project has DB models AND LLM model configs, use qualified names: `db/models`, `models/llm` or `llm_models`.
- Schemas validate data shape. Business rules belong in services, not validators.
- Use suffix conventions: `UserCreate`, `UserUpdate`, `UserRead` (or `CreateUserInput`, `UpdateUserInput`, `UserResponse`).

---

## 4. Standard File Roster (Domain-First)

Not every domain needs every file. Start with the first three, add the rest as complexity demands.

| File | Does | Rule |
|------|------|------|
| `routes` / `router` / `handlers` | HTTP endpoints | No business logic. Thin glue: request → service → response. |
| `schemas` / `types` / `dtos` | I/O contracts | One file per domain. Create/Update/Read suffixes. |
| `service` | Business logic | Orchestrates repos, applies rules, calls external APIs. Testable without HTTP. |
| `models` | DB/ORM definitions | Only persistence structure, no behavior. |
| `repository` / `store` / `dal` | Raw data access | Pure queries. No business decisions. Enables mock-based testing. |
| `dependencies` / `middleware` | Cross-cutting per-request logic | Auth checks, object lookups, reusable across routes. |
| `exceptions` / `errors` | Domain-specific error types | `UserNotFound`, `InvalidCredentials`, etc. |
| `constants` / `enums` | Fixed values | Domain-scoped, not global. |
| `config` | Domain settings | Environment-driven. Validated at startup. |

---

## 5. The `_internal` / `internal` Convention

Pattern from Pydantic v2 (Python `_internal/`), Go (`internal/`), and TS (barrel exports).

```
my_library/
├── index.{ext}          # Public API re-exports
├── client.{ext}         # Public
├── _internal/           # Private (Python: underscore, Go: `internal/` enforced by compiler)
│   ├── transport
│   └── serialization
```

Users import from the package root. Internals can be refactored freely.

Use for: Libraries and frameworks needing implementation freedom behind a stable surface.
Skip for: Application code where domain-first already provides encapsulation.

---

## 6. The `core/` Directory

Every architecture needs shared infrastructure. `core/` is plumbing, not product.

```
core/
├── config           # Environment settings, validated at startup
├── database         # Connection pool, session factory
├── security         # Auth utilities, token handling
├── logging          # Structured logging setup
└── middleware       # CORS, request ID, timing
```

Rules:
- `core/` should never contain business logic.
- If a utility is domain-specific, it goes in that domain, not `core/`.
- Secrets go in OS-level stores (Keychain, Vault, env), never in config files.

---

## 7. Test Structure

### Mirror Layout (default)
```
tests/
├── auth/
│   ├── test_router
│   └── test_service
├── billing/
└── conftest / setup
```
Tests mirror `src/`. Easy to find the test for any module.

### Split by Type (large projects)
```
tests/
├── unit/
├── integration/
└── e2e/
```

### Colocated (common in TS/React)
```
src/
├── auth/
│   ├── service.ts
│   └── service.test.ts
```

Start with mirror layout. Add splits when your suite needs separate CI stages. Colocated works for frontend components but clutters backend directories.

---

## 8. Polyglot / Multi-Runtime Repos

When a project spans languages (Rust + Python + TypeScript), the top-level structure groups by deployment unit, not by language:

```
project/
├── apps/
│   ├── web-ui/          # TS — Vite + Solid/React
│   └── web-marketing/   # TS — Next.js, separate deploy
├── sidecar/             # Python — FastAPI backend
│   └── komodo/          # Domain-first internally
├── src-tauri/           # Rust — Native shell
├── reference/           # Docs, design specs, lessons
├── scripts/             # Cross-cutting dev scripts
├── pyproject.toml       # Python workspace root
├── pnpm-workspace.yaml  # JS workspace root
└── package.json         # JS root config
```

Rules:
- Group by **what gets deployed**, not by language.
- Each deployable unit owns its own package manager config and lockfile (or shares a workspace lockfile).
- Shared types between frontend and backend should be code-generated (OpenAPI → client types), not copy-pasted.
- `reference/` at the root for cross-cutting docs, architecture decisions, and lessons learned. This is a good pattern.
- `scripts/` at the root for dev tooling that spans multiple units.

---

## 9. Decision Matrix

| Signal | Layer-First | Domain-First | Hybrid Domain | Monorepo Multi-Pkg |
|--------|:-----------:|:------------:|:-------------:|:------------------:|
| < 5 endpoints, 1-2 devs | ✅ | | | |
| Single microservice | ✅ | | | |
| 5-15 domains, growing team | | ✅ | | |
| Domains with internal complexity | | | ✅ | |
| Monolith, multiple business areas | | ✅ | ✅ | |
| Framework/SDK with sub-packages | | | | ✅ |
| Desktop app with native + web + backend | | | ✅ | |
| Quick prototype or CLI tool | ✅ | | | |

---

## 10. Anti-Patterns

1. **God `utils`** — Over 200 lines means hidden misplaced domain logic. Break it up or move to the domain it serves.
2. **Circular imports between domains** — Extract shared concept into `core/` or `shared/`.
3. **Schemas doing business logic** — Validators handle data shape. A validator calling the database is a smell.
4. **Flat module explosion** — 30+ files at the same level. Group into sub-packages.
5. **No re-exports** — Import from package root, not deep internal paths. Gives refactoring freedom.
6. **Mixing persistence and I/O types** — Different lifecycles, different audiences. Separate files.
7. **"model" overload without disambiguation** — If `models.py` exists in 3 directories meaning 3 different things, add qualifiers or rename.
8. **Organizing by language in a polyglot repo** — Group by deployment unit. `python/` and `typescript/` top-level directories is almost always wrong; `sidecar/` and `web-ui/` is right.
9. **Shared types via copy-paste** — Generate client types from the API spec. Manual sync drifts within a week.
10. **Reference docs scattered across the tree** — Centralize in `reference/` or `docs/` at the repo root. Inline design docs within a domain (like `HARNESS_DESIGN.md`) are fine for domain-scoped decisions.

---

## 11. Reviewing an Existing Repo

When a user pastes a directory tree for feedback, evaluate against this checklist:

1. **Root layout** — Is there clear separation between source, tests, config, and docs?
2. **Internal architecture** — Is it consistently layer-first, domain-first, or hybrid? Mixed without reason is a smell.
3. **Naming collisions** — Does "models" mean the same thing everywhere? Count files named `models.*` and check if they serve different purposes.
4. **Domain boundaries** — Can you add a feature by adding one directory? Can you delete one by removing a directory?
5. **core/ purity** — Does `core/` contain only infrastructure, or has business logic leaked in?
6. **Test coverage structure** — Do tests mirror the source, or are they thrown in a flat `tests/` with no organization?
7. **Cross-cutting concerns** — Are there clear seams between domains, or spaghetti imports?
8. **Config management** — Is config validated at startup, or scattered as magic strings?
9. **Deployment clarity** — In a multi-app repo, is it obvious what gets deployed where?
10. **Documentation** — Is there an ARCHITECTURE.md, README, and (ideally) a lessons/ directory?

---

## 12. Applying This Skill

When scaffolding:
1. Choose root layout (single → `src/`, multi-app → workspace).
2. Choose internal architecture using the decision matrix.
3. Read the appropriate language-specific reference for templates.
4. Create the directory tree and package config first.
5. Set up config with environment validation (pydantic-settings, zod, envconfig).
6. Add domains one at a time. Start minimal, add files as complexity warrants.

When reviewing:
1. Run through the Section 11 checklist.
2. Identify the dominant pattern and check for consistency.
3. Flag naming collisions and overloaded terms.
4. Suggest concrete moves (not just "refactor this").
