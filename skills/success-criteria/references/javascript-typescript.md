# JavaScript / TypeScript Reference

Structured logging, type-safe patterns, and runtime assertions for the SUCCESS framework.

All examples use TypeScript strict mode. JavaScript projects should use JSDoc annotations for equivalent type safety.

---

## Structured Logging

### Setup with `pino`

```typescript
import pino from "pino";

const logger = pino({
  level: process.env.LOG_LEVEL ?? "info",
  timestamp: pino.stdTimeFunctions.isoTime,
  formatters: {
    level(label: string): { level: string } {
      return { level: label };
    },
  },
});

export { logger };
```

### Setup with `winston`

```typescript
import winston from "winston";

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL ?? "info",
  format: winston.format.combine(
    winston.format.timestamp({ format: "iso" }),
    winston.format.json()
  ),
  transports: [new winston.transports.Console()],
});

export { logger };
```

### Logging Patterns

```typescript
import type { Logger } from "pino";

// Bind context with child loggers
const requestLog: Logger = logger.child({ requestId: "abc-123", userId: 42 });

// Key decisions
requestLog.info({ strategy: "lru", ttlSeconds: 300, reason: "high read ratio" }, "cache_strategy_selected");

// Inputs/outputs at boundaries
requestLog.info({ method: "POST", path: "/tasks", bodySize: 1024 }, "api_request_received");
requestLog.info({ status: 201, durationMs: 45.2 }, "api_response_sent");

// State transitions
requestLog.info({ taskId: 7, fromState: "pending", toState: "running" }, "task_state_changed");

// Errors with context
requestLog.error({ query: "SELECT ...", durationMs: 5023.1, err }, "db_query_failed");
```

### Express Middleware

```typescript
import type { Request, Response, NextFunction } from "express";

function requestLogger(req: Request, res: Response, next: NextFunction): void {
  const start = performance.now();
  const requestLog = logger.child({ requestId: req.headers["x-request-id"] ?? crypto.randomUUID() });

  res.on("finish", () => {
    requestLog.info(
      {
        method: req.method,
        path: req.route?.path ?? req.path,
        status: res.statusCode,
        durationMs: Math.round(performance.now() - start),
      },
      "http_request_completed"
    );
  });

  next();
}
```

---

## Type-Safe Patterns

### Branded Types for Domain Identifiers

```typescript
type Brand<T, B extends string> = T & { readonly __brand: B };

type UserId = Brand<number, "UserId">;
type TaskId = Brand<number, "TaskId">;
type Milliseconds = Brand<number, "Milliseconds">;

function UserId(value: number): UserId {
  assert(Number.isInteger(value) && value > 0, `UserId must be a positive integer, got ${value}`);
  return value as UserId;
}

function TaskId(value: number): TaskId {
  assert(Number.isInteger(value) && value > 0, `TaskId must be a positive integer, got ${value}`);
  return value as TaskId;
}

// Compile-time error: getTask(UserId(5)) — type mismatch
function getTask(id: TaskId): Promise<Task> { ... }
```

### Discriminated Unions for State Machines

```typescript
type TaskState =
  | { readonly status: "pending"; readonly createdAt: Date }
  | { readonly status: "running"; readonly startedAt: Date; readonly workerId: string }
  | { readonly status: "completed"; readonly startedAt: Date; readonly completedAt: Date; readonly result: unknown }
  | { readonly status: "failed"; readonly startedAt: Date; readonly failedAt: Date; readonly error: string };

function transition(current: TaskState, action: TaskAction): TaskState {
  switch (current.status) {
    case "pending":
      assert(action.type === "start", `Cannot ${action.type} a pending task`);
      return { status: "running", startedAt: new Date(), workerId: action.workerId };

    case "running":
      if (action.type === "complete") {
        return { status: "completed", startedAt: current.startedAt, completedAt: new Date(), result: action.result };
      }
      if (action.type === "fail") {
        return { status: "failed", startedAt: current.startedAt, failedAt: new Date(), error: action.error };
      }
      assert(false, `Cannot ${action.type} a running task — only complete or fail`);

    case "completed":
    case "failed":
      assert(false, `Cannot transition from terminal state: ${current.status}`);
  }
}
```

### `zod` for Boundary Validation

```typescript
import { z } from "zod";

const PerformanceCriteriaSchema = z
  .object({
    endpoint: z.string().min(1),
    p95TargetMs: z.number().positive(),
    p50TargetMs: z.number().positive(),
    sampleSize: z.number().int().min(100).default(1000),
  })
  .refine((data) => data.p50TargetMs <= data.p95TargetMs, {
    message: "p50 target cannot exceed p95 target",
    path: ["p50TargetMs"],
  });

type PerformanceCriteria = z.infer<typeof PerformanceCriteriaSchema>;

// Fails fast at the boundary — no invalid data propagates
const criteria: PerformanceCriteria = PerformanceCriteriaSchema.parse(rawInput);
```

### Exhaustive Checks

```typescript
function assertNever(value: never, message?: string): never {
  throw new Error(message ?? `Unexpected value: ${JSON.stringify(value)}`);
}

function statusLabel(status: TaskState["status"]): string {
  switch (status) {
    case "pending": return "Waiting";
    case "running": return "In Progress";
    case "completed": return "Done";
    case "failed": return "Error";
    default: assertNever(status);
  }
}
```

---

## Runtime Assertions

Node.js provides `assert` in the `node:assert` module. For browser code, use a minimal assertion helper.

### Assertion Helper (Universal)

```typescript
function assert(condition: boolean, message: string): asserts condition {
  if (!condition) {
    throw new Error(`Assertion failed: ${message}`);
  }
}
```

The `asserts condition` return type narrows types after the call — TypeScript treats the value as truthy in subsequent code.

### When to Assert

```typescript
import assert from "node:assert/strict";

// Preconditions
function paginate<T>(items: readonly T[], page: number, pageSize: number): T[] {
  assert(page >= 1, `page must be >= 1, got ${page}`);
  assert(pageSize >= 1, `pageSize must be >= 1, got ${pageSize}`);
  const start = (page - 1) * pageSize;
  return items.slice(start, start + pageSize);
}

// Postconditions
function normalizeScores(scores: readonly number[]): number[] {
  assert(scores.length > 0, "Cannot normalize empty score list");
  const total = scores.reduce((sum, s) => sum + s, 0);
  assert(total > 0, `Total score must be positive, got ${total}`);
  const result = scores.map((s) => s / total);
  assert(
    Math.abs(result.reduce((a, b) => a + b, 0) - 1.0) < 1e-9,
    `Normalized scores must sum to 1, got ${result.reduce((a, b) => a + b, 0)}`
  );
  return result;
}

// State invariants
function processBatch(batch: readonly Task[]): BatchResult {
  const completed: Task[] = [];
  const failed: Task[] = [];
  for (const task of batch) {
    try {
      run(task);
      completed.push(task);
    } catch {
      failed.push(task);
    }
  }
  assert(
    completed.length + failed.length === batch.length,
    `Lost tasks: ${batch.length} in, ${completed.length + failed.length} out`
  );
  return { completed, failed };
}
```

### Assertions vs Validation

```typescript
// ASSERT: Internal invariant — bug if False
assert(typeof userId === "number", `userId must be number, got ${typeof userId}`);

// VALIDATE: External input — expected to be wrong sometimes
const result = PerformanceCriteriaSchema.safeParse(userInput);
if (!result.success) {
  throw new ValidationError(result.error.issues);
}
```

### Type Narrowing with Assertions

```typescript
function assertDefined<T>(value: T | undefined | null, name: string): asserts value is T {
  assert(value != null, `${name} must be defined`);
}

function assertString(value: unknown, name: string): asserts value is string {
  assert(typeof value === "string", `${name} must be a string, got ${typeof value}`);
}

// After calling these, TypeScript knows the type
const config = getConfig();
assertDefined(config.databaseUrl, "config.databaseUrl");
// config.databaseUrl is now `string`, not `string | undefined`
```

---

## Tool Configuration

### TypeScript Strict Mode

```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noPropertyAccessFromIndexSignature": true,
    "exactOptionalPropertyTypes": true,
    "forceConsistentCasingInFileNames": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

### ESLint Type-Aware Rules

```json
{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/strict-type-checked"
  ],
  "rules": {
    "@typescript-eslint/no-floating-promises": "error",
    "@typescript-eslint/no-misused-promises": "error",
    "@typescript-eslint/strict-boolean-expressions": "error",
    "@typescript-eslint/switch-exhaustiveness-check": "error"
  }
}
```

### Vitest with Structured Log Capture

```typescript
import { describe, it, expect, beforeEach } from "vitest";
import pino from "pino";

interface LogEntry {
  level: number;
  msg: string;
  [key: string]: unknown;
}

function createTestLogger(): { logger: pino.Logger; logs: LogEntry[] } {
  const logs: LogEntry[] = [];
  const transport = pino.transport({
    target: "pino/file",
    options: { destination: 1 }, // stdout
  });
  const logger = pino(
    {
      level: "trace",
      hooks: {
        logMethod(inputArgs, method) {
          const [obj, msg] = inputArgs as [Record<string, unknown>, string];
          logs.push({ ...obj, msg, level: 0 } as LogEntry);
          return method.apply(this, inputArgs);
        },
      },
    },
  );
  return { logger, logs };
}

describe("reconciliation", () => {
  it("logs mismatch when counts differ", () => {
    const { logger, logs } = createTestLogger();
    reconcile(logger, { expected: 10, actual: 8, source: "inventory" });
    const warnings = logs.filter((l) => l.msg === "reconciliation_mismatch");
    expect(warnings).toHaveLength(1);
    expect(warnings[0]).toMatchObject({ delta: 2, source: "inventory" });
  });
});
```

### JSDoc Type Safety (for JavaScript projects)

```javascript
// @ts-check

/**
 * @param {readonly number[]} scores
 * @returns {number[]}
 */
function normalizeScores(scores) {
  /** @type {number} */
  const total = scores.reduce((sum, s) => sum + s, 0);
  console.assert(total > 0, `Total must be positive, got ${total}`);
  return scores.map((s) => s / total);
}
```

Enable `"checkJs": true` in `tsconfig.json` to type-check `.js` files with JSDoc annotations.
