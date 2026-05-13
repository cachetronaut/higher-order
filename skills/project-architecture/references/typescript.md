# TypeScript Reference

Templates, tooling, and conventions specific to TypeScript/JavaScript projects.

---

## Template A: Web App (Vite + React/Solid/Vue)

```
project-name/
├── src/
│   ├── api/                 # API client, typed against OpenAPI spec
│   │   ├── client.ts
│   │   ├── types.ts         # Generated or hand-written response types
│   │   └── constants.ts
│   ├── components/          # UI components
│   │   ├── Button.tsx
│   │   └── Modal.tsx
│   ├── routes/              # Page-level route components
│   │   ├── inbox.tsx
│   │   └── settings.tsx
│   ├── signals/ (or hooks/ or stores/)
│   │   ├── auth.ts
│   │   └── inbox.ts
│   ├── lib/                 # Utilities, helpers, pure functions
│   │   ├── constants.ts
│   │   └── format.ts
│   ├── styles.css
│   └── main.tsx
├── tests/
│   ├── e2e/                 # Playwright
│   │   └── triage.spec.ts
│   ├── unit/                # Vitest
│   │   ├── api.client.test.ts
│   │   └── components.button.test.tsx
│   └── setup.ts
├── public/
├── index.html
├── package.json
├── vite.config.ts
├── vitest.config.ts
├── tailwind.config.ts
├── tsconfig.json
└── biome.json (or .eslintrc)
```

### When this wins
Single-page apps, dashboard UIs, webview clients inside desktop shells (Tauri/Electron).

### Naming conventions
- **Solid.js**: `signals/` for reactive state stores
- **React**: `hooks/` for custom hooks, `stores/` or `context/` for global state
- **Vue**: `composables/` for composition API, `stores/` for Pinia

---

## Template B: Node.js API Service (Express/Fastify/Hono)

```
project-name/
├── src/
│   ├── auth/
│   │   ├── routes.ts
│   │   ├── schemas.ts       # Zod schemas
│   │   ├── service.ts
│   │   └── middleware.ts
│   ├── billing/
│   │   ├── routes.ts
│   │   ├── schemas.ts
│   │   ├── service.ts
│   │   └── repository.ts
│   ├── core/
│   │   ├── config.ts        # Validated with Zod/env
│   │   ├── database.ts      # Drizzle/Prisma client
│   │   ├── logger.ts
│   │   └── middleware.ts
│   ├── shared/
│   │   ├── errors.ts
│   │   └── utils.ts
│   └── index.ts             # App entrypoint
├── tests/
│   ├── auth/
│   └── billing/
├── drizzle/ (or prisma/)
├── package.json
├── tsconfig.json
└── biome.json
```

Domain-first works the same in TS as in Python. The file names change slightly (Zod instead of Pydantic, Drizzle/Prisma instead of SQLAlchemy).

---

## Template C: pnpm/Turborepo Monorepo

```
project-name/
├── apps/
│   ├── web/                 # Next.js / Vite frontend
│   │   ├── src/
│   │   └── package.json
│   ├── api/                 # Node backend
│   │   ├── src/
│   │   └── package.json
│   └── marketing/           # Static site / landing page
│       └── package.json
├── packages/
│   ├── ui/                  # Shared component library
│   │   ├── src/
│   │   └── package.json
│   ├── config/              # Shared ESLint/TS/Tailwind config
│   │   └── package.json
│   └── types/               # Shared type definitions
│       └── package.json
├── package.json             # Workspace root
├── pnpm-workspace.yaml
├── turbo.json               # Turborepo pipeline config
└── biome.json
```

### Key conventions
- `apps/` for deployable units. `packages/` for shared internal libraries.
- Each package has its own `package.json` with `name: "@org/package-name"`.
- `turbo.json` defines task dependencies: `build` depends on `^build` (build deps first).
- Shared types between frontend and backend live in `packages/types/`.

---

## Template D: TypeScript Library (npm distribution)

```
project-name/
├── src/
│   ├── index.ts             # Public barrel export
│   ├── client.ts
│   ├── types.ts
│   └── internal/            # Private implementation
│       ├── transport.ts
│       └── serialization.ts
├── tests/
├── package.json
├── tsconfig.json
├── tsconfig.build.json      # Exclude tests from build output
├── biome.json
├── LICENSE
├── CHANGELOG.md
└── README.md
```

### Barrel export pattern (`src/index.ts`)
```typescript
export { Client } from './client';
export type { Config, Result } from './types';
export { LibraryError } from './errors';
```

---

## TypeScript-Specific Conventions

### Config validation (Zod)
```typescript
import { z } from 'zod';

const envSchema = z.object({
  DATABASE_URL: z.string().url(),
  PORT: z.coerce.number().default(3000),
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
});

export const config = envSchema.parse(process.env);
```

### Schema conventions
```typescript
// Zod schemas with .brand<>() or inferred types
const UserCreate = z.object({ email: z.string().email(), password: z.string().min(8) });
const UserRead = z.object({ id: z.string().uuid(), email: z.string(), createdAt: z.date() });

type UserCreate = z.infer<typeof UserCreate>;
type UserRead = z.infer<typeof UserRead>;
```

### Formatting / linting
- **Biome** (recommended): single tool for formatting + linting, fast, zero-config
- **ESLint + Prettier**: legacy standard, more ecosystem plugins

### Package manager
- **pnpm**: recommended for monorepos (strict deps, fast, workspace support)
- **npm**: fine for single packages
- **bun**: fast runtime + package manager, maturing ecosystem

---

## TypeScript-Specific Gotchas

- Use `tsconfig.json` path aliases (`@/components/*`) sparingly — they require build tool support.
- Barrel exports (`index.ts`) are great for libraries but can hurt tree-shaking in app code if they re-export everything.
- In monorepos, each package needs its own `tsconfig.json` extending a shared base.
- `biome.json` at the repo root covers all packages. Prefer it over per-package lint configs.
- For frontend components, colocate tests (`Button.test.tsx` next to `Button.tsx`). For backend services, use mirror layout.
