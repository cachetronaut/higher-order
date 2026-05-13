# Python Reference

Templates, tooling, and conventions specific to Python projects.

---

## Template A: Small FastAPI Microservice (Layer-First)

```
project-name/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI app, lifespan, middleware
│   ├── routers/
│   │   └── items.py
│   ├── models/
│   │   └── item.py          # SQLAlchemy/SQLModel
│   ├── schemas/
│   │   └── item.py          # Pydantic I/O
│   ├── crud/
│   │   └── item.py
│   └── core/
│       ├── config.py         # pydantic-settings
│       └── database.py
├── tests/
│   ├── conftest.py
│   └── test_items.py
├── alembic/
├── pyproject.toml
├── Dockerfile
├── Makefile
├── .env.example
└── README.md
```

---

## Template B: Domain-First FastAPI Application

```
project-name/
├── src/
│   └── project_name/
│       ├── __init__.py
│       ├── main.py
│       ├── core/
│       │   ├── config.py        # pydantic-settings BaseSettings
│       │   ├── database.py      # async engine, session factory
│       │   ├── security.py
│       │   └── logging.py
│       ├── shared/
│       │   ├── exceptions.py
│       │   ├── pagination.py
│       │   └── utils.py
│       ├── auth/
│       │   ├── router.py
│       │   ├── schemas.py
│       │   ├── models.py
│       │   ├── service.py
│       │   ├── repository.py
│       │   ├── dependencies.py
│       │   └── exceptions.py
│       └── documents/
│           ├── router.py
│           ├── schemas.py
│           ├── models.py
│           ├── service.py
│           ├── repository.py
│           └── extractors/      # Sub-package for pipeline stages
│               ├── base.py
│               ├── regex.py
│               ├── ocr.py
│               └── vision.py
├── tests/                       # Mirror layout
│   ├── conftest.py
│   ├── auth/
│   └── documents/
├── alembic/
├── pyproject.toml
├── Dockerfile
├── docker-compose.yml
├── Makefile
├── .env.example
└── README.md
```

---

## Template C: Domain-First with Async Job Queue

Extended for services needing background processing.

```
project-name/
├── src/
│   └── project_name/
│       ├── main.py
│       ├── core/
│       │   ├── config.py
│       │   ├── database.py
│       │   └── redis.py
│       ├── jobs/
│       │   ├── worker.py        # ARQ/Celery entrypoint
│       │   ├── tasks.py
│       │   └── schemas.py       # JobStatus, JobResult
│       ├── documents/
│       │   ├── router.py
│       │   ├── schemas.py
│       │   ├── models.py
│       │   ├── service.py
│       │   └── extractors/
│       └── shared/
├── tests/
├── pyproject.toml
├── Dockerfile
├── docker-compose.yml           # app + worker + redis + postgres
└── Makefile
```

---

## Template D: Python Library (for distribution)

```
project-name/
├── src/
│   └── my_library/
│       ├── __init__.py          # Public API re-exports
│       ├── client.py
│       ├── models.py
│       ├── exceptions.py
│       ├── _internal/           # Private, no stability guarantees
│       │   ├── _transport.py
│       │   └── _serialization.py
│       └── py.typed             # PEP 561 marker
├── tests/
├── docs/
├── pyproject.toml
├── LICENSE
├── CHANGELOG.md
└── README.md
```

### `__init__.py` re-export pattern
```python
from my_library.client import Client
from my_library.models import Config, Result
from my_library.exceptions import MyLibraryError

__all__ = ["Client", "Config", "Result", "MyLibraryError"]
```

---

## Python-Specific Conventions

### Config
```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str
    redis_url: str
    environment: str = "development"
    model_config = {"env_file": ".env"}

settings = Settings()
```

### Dependency injection (FastAPI)
```python
from typing import Annotated
from fastapi import Depends

async def get_user_service(session=Depends(get_session)) -> UserService:
    return UserService(UserRepository(session))

UserServiceDep = Annotated[UserService, Depends(get_user_service)]
```

### pyproject.toml (the standard)
```toml
[project]
name = "project-name"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = ["fastapi>=0.115", "pydantic-settings>=2.0"]

[project.optional-dependencies]
dev = ["pytest>=8.0", "ruff>=0.8", "mypy>=1.13"]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.ruff]
target-version = "py311"
line-length = 100

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B"]

[tool.pytest.ini_options]
testpaths = ["tests"]
asyncio_mode = "auto"
```

### Makefile
```makefile
.PHONY: install test lint run
install:
	pip install -e ".[dev]"
test:
	pytest -v --tb=short
lint:
	ruff check src/ tests/ && mypy src/
run:
	uvicorn project_name.main:app --reload
```

---

## Python-Specific Gotchas

- Always use `src/` layout for non-trivial projects. Flat layout causes import shadowing.
- `__init__.py` re-exports give refactoring freedom. Import from the package, not deep paths.
- `_internal/` with underscore-prefixed files signals "hands off" to linters and users.
- `pyproject.toml` replaces `setup.py` + `setup.cfg`. Consolidate all tool config here.
- Use `uv` or `pip install -e .` for editable installs during development.
