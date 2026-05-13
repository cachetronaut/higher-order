# Rust Reference

Structured logging, type-safe patterns, and runtime assertions for the SUCCESS framework.

Rust's type system enforces most invariants at compile time. This reference covers the gaps: structured runtime logging, `debug_assert!` for development-only checks, and patterns that encode domain rules into the type system.

---

## Structured Logging

### Setup with `tracing`

```rust
use tracing::{info, warn, error, instrument, Level};
use tracing_subscriber::{fmt, EnvFilter};

fn init_logging() {
    let filter = EnvFilter::try_from_default_env()
        .unwrap_or_else(|_| EnvFilter::new("info"));

    fmt()
        .json()
        .with_env_filter(filter)
        .with_target(true)
        .with_thread_ids(true)
        .with_span_events(fmt::format::FmtSpan::CLOSE)
        .init();
}
```

### Logging Patterns

```rust
use tracing::{info, warn, error, info_span, Instrument};

// Key decisions — structured fields, not string interpolation
info!(
    strategy = "lru",
    ttl_seconds = 300,
    reason = "high read ratio",
    "cache_strategy_selected"
);

// Inputs/outputs at boundaries
info!(method = "POST", path = "/tasks", body_size = 1024, "api_request_received");
info!(status = 201, duration_ms = 45.2, "api_response_sent");

// State transitions
info!(task_id = 7, from_state = "pending", to_state = "running", "task_state_changed");

// Errors with context
error!(
    query = "SELECT ...",
    duration_ms = 5023.1,
    error = %err,
    "db_query_failed"
);

// Spans for scoped context (propagated to all log calls within)
let span = info_span!("process_batch", batch_size = batch.len());
async {
    for task in &batch {
        process(task).await;
    }
}
.instrument(span)
.await;
```

### Function-Level Instrumentation

```rust
#[instrument(skip(db), fields(user_id = %user_id))]
async fn get_tasks(db: &Pool, user_id: UserId) -> Result<Vec<Task>, AppError> {
    let tasks = db.query_tasks(user_id).await?;
    info!(count = tasks.len(), "tasks_retrieved");
    Ok(tasks)
}
```

---

## Type-Safe Patterns

Rust's type system is the primary enforcement mechanism. These patterns push more invariants into compile time.

### Newtype Pattern for Domain Identifiers

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct UserId(i64);

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct TaskId(i64);

#[derive(Debug, Clone, Copy, PartialEq, PartialOrd)]
pub struct Milliseconds(f64);

impl UserId {
    pub fn new(value: i64) -> Self {
        assert!(value > 0, "UserId must be positive, got {value}");
        Self(value)
    }

    pub fn as_i64(self) -> i64 {
        self.0
    }
}

impl TaskId {
    pub fn new(value: i64) -> Self {
        assert!(value > 0, "TaskId must be positive, got {value}");
        Self(value)
    }
}

// Compile-time error: get_task(UserId::new(5)) — wrong type
fn get_task(id: TaskId) -> Task { ... }
```

### Enums for State Machines

```rust
#[derive(Debug)]
enum TaskState {
    Pending {
        created_at: DateTime<Utc>,
    },
    Running {
        started_at: DateTime<Utc>,
        worker_id: String,
    },
    Completed {
        started_at: DateTime<Utc>,
        completed_at: DateTime<Utc>,
        result: serde_json::Value,
    },
    Failed {
        started_at: DateTime<Utc>,
        failed_at: DateTime<Utc>,
        error: String,
    },
}

impl TaskState {
    fn transition(self, action: TaskAction) -> Result<TaskState, TransitionError> {
        match (self, action) {
            (TaskState::Pending { .. }, TaskAction::Start { worker_id }) => {
                Ok(TaskState::Running {
                    started_at: Utc::now(),
                    worker_id,
                })
            }
            (TaskState::Running { started_at, .. }, TaskAction::Complete { result }) => {
                Ok(TaskState::Completed {
                    started_at,
                    completed_at: Utc::now(),
                    result,
                })
            }
            (TaskState::Running { started_at, .. }, TaskAction::Fail { error }) => {
                Ok(TaskState::Failed {
                    started_at,
                    failed_at: Utc::now(),
                    error,
                })
            }
            (state, action) => Err(TransitionError::Invalid {
                from: state.label(),
                action: action.label(),
            }),
        }
    }

    fn label(&self) -> &'static str {
        match self {
            TaskState::Pending { .. } => "pending",
            TaskState::Running { .. } => "running",
            TaskState::Completed { .. } => "completed",
            TaskState::Failed { .. } => "failed",
        }
    }
}
```

### Typestate Pattern (Compile-Time State Enforcement)

```rust
struct Unvalidated;
struct Validated;

struct SearchCriteria<State = Unvalidated> {
    query: String,
    fields: Vec<String>,
    max_results: usize,
    _state: std::marker::PhantomData<State>,
}

impl SearchCriteria<Unvalidated> {
    fn validate(self) -> Result<SearchCriteria<Validated>, ValidationError> {
        assert!(!self.query.trim().is_empty(), "Query must not be blank");
        assert!(self.max_results > 0, "max_results must be positive");
        assert!(!self.fields.is_empty(), "Must search at least one field");

        Ok(SearchCriteria {
            query: self.query,
            fields: self.fields,
            max_results: self.max_results,
            _state: std::marker::PhantomData,
        })
    }
}

// Only accepts validated criteria — unvalidated won't compile
fn execute_search(criteria: SearchCriteria<Validated>) -> Vec<SearchResult> {
    ...
}
```

### `serde` for Boundary Validation

```rust
use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct PerformanceCriteria {
    pub endpoint: String,
    pub p95_target_ms: f64,
    pub p50_target_ms: f64,
    #[serde(default = "default_sample_size")]
    pub sample_size: usize,
}

fn default_sample_size() -> usize { 1000 }

impl PerformanceCriteria {
    pub fn validate(&self) -> Result<(), ValidationError> {
        assert!(self.p95_target_ms > 0.0, "p95 must be positive");
        assert!(self.p50_target_ms > 0.0, "p50 must be positive");
        if self.p50_target_ms > self.p95_target_ms {
            return Err(ValidationError::new(format!(
                "p50 ({:.1}ms) cannot exceed p95 ({:.1}ms)",
                self.p50_target_ms, self.p95_target_ms
            )));
        }
        if self.sample_size < 100 {
            return Err(ValidationError::new(format!(
                "sample_size must be >= 100, got {}",
                self.sample_size
            )));
        }
        Ok(())
    }
}
```

---

## Runtime Assertions

Rust has two assertion macros with different semantics:

| Macro | Compiled in release? | Use for |
|-------|---------------------|---------|
| `assert!` | Yes | Invariants that must hold in production |
| `debug_assert!` | No (stripped in `--release`) | Expensive checks during development |

### When to Use Each

```rust
// assert! — always checked, cheap to evaluate
fn paginate<T>(items: &[T], page: usize, page_size: usize) -> &[T] {
    assert!(page >= 1, "page must be >= 1, got {page}");
    assert!(page_size >= 1, "page_size must be >= 1, got {page_size}");
    let start = (page - 1) * page_size;
    let end = (start + page_size).min(items.len());
    &items[start..end]
}

// debug_assert! — development only, expensive to evaluate
fn normalize_scores(scores: &[f64]) -> Vec<f64> {
    assert!(!scores.is_empty(), "Cannot normalize empty score list");
    let total: f64 = scores.iter().sum();
    assert!(total > 0.0, "Total score must be positive, got {total}");
    let result: Vec<f64> = scores.iter().map(|s| s / total).collect();
    debug_assert!(
        (result.iter().sum::<f64>() - 1.0).abs() < 1e-9,
        "Normalized scores must sum to 1, got {}",
        result.iter().sum::<f64>()
    );
    result
}

// State invariants
fn process_batch(batch: &[Task]) -> BatchResult {
    let mut completed = Vec::new();
    let mut failed = Vec::new();
    for task in batch {
        match run(task) {
            Ok(()) => completed.push(task.clone()),
            Err(_) => failed.push(task.clone()),
        }
    }
    assert_eq!(
        completed.len() + failed.len(),
        batch.len(),
        "Lost tasks: {} in, {} out",
        batch.len(),
        completed.len() + failed.len()
    );
    BatchResult { completed, failed }
}
```

### Combining Logging and Assertions

```rust
use tracing::{info, warn, error};

fn reconcile(expected: usize, actual: usize, source: &str) -> Result<(), ReconcileError> {
    info!(expected, actual, source, "reconciliation_started");
    let delta = expected.abs_diff(actual);
    if delta != 0 {
        warn!(delta, source, "reconciliation_mismatch");
    } else {
        info!(source, "reconciliation_ok");
    }
    Ok(())
}
```

---

## Tool Configuration

### Clippy Lints

```toml
# Cargo.toml or .clippy.toml
[lints.clippy]
pedantic = { level = "warn", priority = -1 }
unwrap_used = "warn"
expect_used = "warn"
missing_assert_message = "warn"
```

### Test with Log Capture

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use tracing_test::traced_test;

    #[traced_test]
    #[test]
    fn reconciliation_logs_mismatch() {
        reconcile(10, 8, "inventory").unwrap();
        assert!(logs_contain("reconciliation_mismatch"));
        assert!(logs_contain("delta=2"));
    }
}
```

Add `tracing-test` to `[dev-dependencies]` for the `#[traced_test]` attribute and `logs_contain` helper.
