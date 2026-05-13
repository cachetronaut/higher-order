# Polyglot & Desktop App Reference

Patterns for repos spanning multiple languages/runtimes (Tauri, Electron, mixed backend/frontend).

---

## Template: Tauri Desktop App (Rust + Python Sidecar + TS Webview)

The canonical example of a polyglot workspace: native shell, web frontend, and a backend sidecar, each in a different language.

```
project-name/
├── apps/
│   ├── web-ui/                    # TS — Vite + Solid/React webview
│   │   ├── src/
│   │   │   ├── api/               # Typed REST client
│   │   │   ├── components/        # UI components
│   │   │   ├── routes/            # Page routes
│   │   │   ├── signals/           # Reactive state (Solid) or hooks/ (React)
│   │   │   ├── lib/               # Utilities
│   │   │   └── main.tsx
│   │   ├── tests/
│   │   │   ├── unit/
│   │   │   └── e2e/
│   │   ├── package.json
│   │   ├── vite.config.ts
│   │   └── tsconfig.json
│   └── web-marketing/             # Separate deploy target
│       └── package.json
│
├── sidecar/                       # Python — FastAPI backend
│   ├── main.py
│   ├── komodo/                    # Domain-first, hybrid internal structure
│   │   ├── api/                   # FastAPI routers (one per resource)
│   │   │   ├── inbox.py
│   │   │   ├── drafts.py
│   │   │   └── schemas.py         # API-level schemas
│   │   ├── cascade/               # Complex domain with sub-structure
│   │   │   ├── stages/
│   │   │   ├── types/
│   │   │   ├── shapes/
│   │   │   └── pipeline.py
│   │   ├── connectors/            # Another complex domain
│   │   │   ├── backends/
│   │   │   ├── executors/
│   │   │   └── normalizers/
│   │   ├── db/
│   │   │   ├── models.py
│   │   │   └── migrations/
│   │   ├── core/                  # Shared infra (config, security)
│   │   │   ├── settings.py
│   │   │   └── security/
│   │   └── cli/                   # CLI as first-class client
│   │       ├── __main__.py
│   │       └── commands/
│   ├── tests/                     # Mirror layout
│   └── uv.lock
│
├── src-tauri/                     # Rust — Native shell
│   ├── src/
│   │   ├── main.rs
│   │   └── lib.rs
│   ├── tauri.conf.json
│   └── Cargo.toml
│
├── reference/                     # Cross-cutting docs
│   ├── ARCHITECTURE.md
│   ├── DESIGN.md
│   └── lessons/                   # Post-mortems, conventions
│
├── scripts/                       # Cross-cutting dev scripts
│   ├── dev.sh
│   └── seed.sh
│
├── pyproject.toml                 # Python workspace root
├── pnpm-workspace.yaml            # JS workspace root
├── package.json                   # JS root config + shared scripts
├── biome.json                     # JS/TS linting (repo-wide)
└── README.md
```

---

## Polyglot Rules

### 1. Group by deployment unit, not by language

Wrong:
```
python/
typescript/
rust/
```

Right:
```
sidecar/       # Python — what runs as the backend
apps/web-ui/   # TypeScript — what runs in the webview
src-tauri/     # Rust — what runs as the native shell
```

Each top-level directory answers: "What is this thing that gets deployed/packaged?"

### 2. Each runtime owns its own dependency management

```
sidecar/uv.lock          # Python deps
apps/web-ui/package.json  # JS deps
src-tauri/Cargo.lock       # Rust deps
```

Don't try to unify across runtimes. Each ecosystem has its own lockfile format and resolver. The workspace roots (`pyproject.toml`, `pnpm-workspace.yaml`) coordinate within their language, not across.

### 3. Shared types via code generation

The frontend and backend agree on a contract. Don't maintain types by hand in both languages.

```
# Generate OpenAPI spec from FastAPI
python -m project_name.main --generate-openapi > openapi.json

# Generate TS client from spec
npx openapi-typescript openapi.json -o apps/web-ui/src/api/types.ts
```

Or use tools like `openapi-ts`, `orval`, or `fets` to generate typed API clients.

### 4. Cross-cutting docs live at the repo root

```
reference/
├── ARCHITECTURE.md      # System-wide architecture
├── DESIGN.md            # Product design spec
├── lessons/             # Convention decisions with dates
│   ├── 2026-04-28-use-biome-for-js-ts.md
│   └── 2026-05-05-ruff-sqlalchemy-gotchas.md
```

Domain-specific design docs (like `HARNESS_DESIGN.md`) can live inline with their domain. System-wide docs belong at the root. The `lessons/` pattern (dated files capturing decisions) is excellent for maintaining institutional memory.

### 5. Scripts bridge runtimes

```
scripts/
├── dev.sh               # Start all services for local dev
├── seed.sh              # Seed dev data across backend + frontend fixtures
└── test-all.sh          # Run tests across all runtimes
```

A `Makefile` or root `package.json` scripts can orchestrate: `make dev` starts the sidecar, the web-ui dev server, and Tauri in one command.

---

## The Three-Client Pattern

Desktop apps often have 3+ clients consuming the same API:

| Client | Runtime | Role |
|--------|---------|------|
| Webview UI | Browser (TS) | Primary visual surface |
| CLI | Same as backend (Python/Go) | Power user, scriptable, proof the API is clean |
| MCP / Plugin adapter | Stdio or HTTP | External agent compatibility layer |

Rules:
- The API is the architecture. Clients are interchangeable.
- If a CLI command is awkward, the API is wrong.
- The MCP/plugin layer is a translator, not the source of truth. It owns no state.
- All clients authenticate the same way (bearer token, session, etc.).

---

## Tauri-Specific Conventions

- `src-tauri/` is the standard directory name (Tauri CLI expects it).
- Sidecar binaries go in `src-tauri/binaries/` with platform-specific naming.
- Keep `src/main.rs` thin — window management, sidecar spawn, IPC bridge. No business logic in Rust unless performance-critical.
- `tauri.conf.json` configures window properties, CSP, plugin allowlists.
- The Rust shell supervises the sidecar lifecycle (spawn, health check, restart on crash).

---

## Electron-Specific Conventions

```
project-name/
├── src/
│   ├── main/              # Electron main process (Node.js)
│   │   ├── index.ts
│   │   └── ipc.ts
│   ├── preload/           # Bridge between main and renderer
│   │   └── index.ts
│   └── renderer/          # Web app (React/Vue/Solid)
│       ├── components/
│       ├── hooks/
│       └── main.tsx
├── electron-builder.yml
├── package.json
└── tsconfig.json
```

Same principle: group by process boundary (main/preload/renderer), not by file type.
