# Python Reference

Structured logging, type-safe patterns, and runtime assertions for the SUCCESS framework.

---

## Structured Logging

### Setup with `structlog`

```python
import structlog

structlog.configure(
    processors=[
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.add_log_level,
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.JSONRenderer(),
    ],
    wrapper_class=structlog.stdlib.BoundLogger,
    context_class=dict,
    logger_factory=structlog.stdlib.LoggerFactory(),
    cache_logger_on_first_use=True,
)

logger: structlog.stdlib.BoundLogger = structlog.get_logger()
```

### Setup with `logging` (stdlib)

```python
import logging
import json
from typing import Any

class StructuredFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        log_entry: dict[str, Any] = {
            "timestamp": self.formatTime(record, self.datefmt),
            "level": record.levelname,
            "message": record.getMessage(),
            "logger": record.name,
        }
        if hasattr(record, "data"):
            log_entry["data"] = record.data  # type: ignore[attr-defined]
        if record.exc_info and record.exc_info[1] is not None:
            log_entry["exception"] = self.formatException(record.exc_info)
        return json.dumps(log_entry)

handler = logging.StreamHandler()
handler.setFormatter(StructuredFormatter())
logging.root.addHandler(handler)
logging.root.setLevel(logging.INFO)
```

### Logging Patterns

```python
from typing import Any
import structlog

logger: structlog.stdlib.BoundLogger = structlog.get_logger()

# Bind context that persists across log calls
log: structlog.stdlib.BoundLogger = logger.bind(
    request_id="abc-123",
    user_id=42,
)

# Key decisions
log.info("cache_strategy_selected", strategy="lru", ttl_seconds=300, reason="high read ratio")

# Inputs/outputs at boundaries
log.info("api_request_received", method="POST", path="/tasks", body_size=1024)
log.info("api_response_sent", status=201, duration_ms=45.2)

# State transitions
log.info("task_state_changed", task_id=7, from_state="pending", to_state="running")

# Errors with context
log.error("db_query_failed", query="SELECT ...", duration_ms=5023.1, error=str(exc))
```

---

## Type-Safe Patterns

### Typed Dicts for Structured Data

```python
from typing import TypedDict, NotRequired

class SearchCriteria(TypedDict):
    query: str
    fields: list[str]
    max_results: int
    fuzzy: NotRequired[bool]

class SearchResult(TypedDict):
    id: int
    title: str
    score: float
    matched_field: str

def search(criteria: SearchCriteria) -> list[SearchResult]:
    assert len(criteria["query"].strip()) > 0, "Search query must not be blank"
    assert criteria["max_results"] > 0, f"max_results must be positive, got {criteria['max_results']}"
    ...
```

### Enums over String Literals for State

```python
from enum import StrEnum

class TaskStatus(StrEnum):
    PENDING = "pending"
    RUNNING = "running"
    COMPLETED = "completed"
    FAILED = "failed"

def transition(current: TaskStatus, target: TaskStatus) -> TaskStatus:
    valid_transitions: dict[TaskStatus, frozenset[TaskStatus]] = {
        TaskStatus.PENDING: frozenset({TaskStatus.RUNNING}),
        TaskStatus.RUNNING: frozenset({TaskStatus.COMPLETED, TaskStatus.FAILED}),
        TaskStatus.FAILED: frozenset({TaskStatus.PENDING}),
        TaskStatus.COMPLETED: frozenset(),
    }
    assert target in valid_transitions[current], (
        f"Invalid transition: {current} -> {target}. "
        f"Allowed: {valid_transitions[current]}"
    )
    return target
```

### Pydantic Models for Boundary Validation

```python
from pydantic import BaseModel, Field, field_validator

class PerformanceCriteria(BaseModel):
    endpoint: str
    p95_target_ms: float = Field(gt=0)
    p50_target_ms: float = Field(gt=0)
    sample_size: int = Field(ge=100, default=1000)

    @field_validator("p50_target_ms")
    @classmethod
    def p50_less_than_p95(cls, v: float, info: Any) -> float:
        p95 = info.data.get("p95_target_ms")
        if p95 is not None and v > p95:
            raise ValueError(f"p50 ({v}ms) cannot exceed p95 ({p95}ms)")
        return v

# Fails fast at the boundary — no invalid data propagates
criteria = PerformanceCriteria(endpoint="/api/tasks", p95_target_ms=200, p50_target_ms=50)
```

### NewType for Domain Identifiers

```python
from typing import NewType

UserId = NewType("UserId", int)
TaskId = NewType("TaskId", int)
Milliseconds = NewType("Milliseconds", float)

def get_task_duration(task_id: TaskId) -> Milliseconds:
    ...

# Mypy catches: get_task_duration(UserId(5)) — wrong argument type
duration = get_task_duration(TaskId(42))
```

---

## Runtime Assertions

Asserts validate invariants during development and testing. They complement tests — tests verify behavior from outside, asserts verify assumptions from inside.

### When to Assert

```python
# Preconditions — catch bad inputs before they cause confusing downstream errors
def paginate(items: list[Any], page: int, page_size: int) -> list[Any]:
    assert page >= 1, f"page must be >= 1, got {page}"
    assert page_size >= 1, f"page_size must be >= 1, got {page_size}"
    start = (page - 1) * page_size
    return items[start : start + page_size]

# Postconditions — verify your own code produced a sane result
def normalize_scores(scores: list[float]) -> list[float]:
    assert len(scores) > 0, "Cannot normalize empty score list"
    total = sum(scores)
    assert total > 0, f"Total score must be positive, got {total}"
    result = [s / total for s in scores]
    assert abs(sum(result) - 1.0) < 1e-9, f"Normalized scores must sum to 1, got {sum(result)}"
    return result

# State invariants — verify the system is in a valid state
def process_batch(batch: list[Task]) -> BatchResult:
    completed: list[Task] = []
    failed: list[Task] = []
    for task in batch:
        try:
            run(task)
            completed.append(task)
        except Exception:
            failed.append(task)
    assert len(completed) + len(failed) == len(batch), (
        f"Lost tasks: {len(batch)} in, {len(completed) + len(failed)} out"
    )
    return BatchResult(completed=completed, failed=failed)
```

### Assertions vs Validation

```python
# ASSERT: Internal invariant — should never be False in correct code
assert isinstance(user_id, int), f"user_id must be int, got {type(user_id)}"

# VALIDATE: External input — expected to be wrong sometimes
if not isinstance(request.body, dict):
    raise ValueError("Request body must be a JSON object")
```

**Rule of thumb:** Use `assert` for "this is a bug if it's False." Use exceptions for "this is bad input if it's False."

### Combining Logging and Assertions

```python
import structlog

logger: structlog.stdlib.BoundLogger = structlog.get_logger()

def reconcile(expected: int, actual: int, source: str) -> None:
    logger.info("reconciliation_started", expected=expected, actual=actual, source=source)
    assert expected >= 0 and actual >= 0, (
        f"Counts cannot be negative: expected={expected}, actual={actual}"
    )
    delta = expected - actual
    if delta != 0:
        logger.warning("reconciliation_mismatch", delta=delta, source=source)
    else:
        logger.info("reconciliation_ok", source=source)
```

---

## Tool Configuration

### mypy (strict mode)

```toml
# pyproject.toml
[tool.mypy]
strict = true
warn_return_any = true
warn_unreachable = true
disallow_untyped_defs = true
disallow_any_generics = true
```

### pytest with structured log capture

```python
# conftest.py
import structlog
import pytest
from typing import Any

@pytest.fixture()
def captured_logs() -> list[dict[str, Any]]:
    logs: list[dict[str, Any]] = []

    def capture_processor(
        logger: Any, method_name: str, event_dict: dict[str, Any]
    ) -> dict[str, Any]:
        logs.append(event_dict.copy())
        return event_dict

    structlog.configure(
        processors=[capture_processor, structlog.processors.JSONRenderer()],
        wrapper_class=structlog.stdlib.BoundLogger,
    )
    return logs

def test_reconciliation_logs_mismatch(captured_logs: list[dict[str, Any]]) -> None:
    reconcile(expected=10, actual=8, source="inventory")
    warnings = [log for log in captured_logs if log.get("level") == "warning"]
    assert len(warnings) == 1
    assert warnings[0]["delta"] == 2
```
