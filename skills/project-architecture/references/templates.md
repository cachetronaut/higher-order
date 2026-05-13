# Starter Templates

Detailed directory trees for each architecture. Copy the one that matches your project type.

---

## Template A: Small Microservice (Layer-First)

For services with < 5 endpoints doing one thing well.

```
project-name/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI app init, middleware, lifespan
│   ├── routers/
│   │   ├── __init__.py
│   │   └── items.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── item.py          # SQLAlchemy/SQLModel
│   ├── schemas/
│   │   ├── __init__.py
│   │   └── item.py          # Pydantic I/O models
│   ├── crud/
│   │   ├── __init__.py
│   │   └── item.py
│   └── core/
│       ├── __init__.py
│       ├── config.py         # pydantic-settings
│       └── database.py       # Engine, session
├── tests/
│   ├── __init__.py
│   ├── conftest.py           # Fixtures: test client, test DB
│   ├── test_items.py
├── alembic/
│   ├── env.py
│   └── versions/
├── pyproject.toml
├── Dockerfile
├── docker-compose.yml
├── Makefile
├── .env.example
├── .gitignore
└── README.md
```

### Key files

**app/main.py**
```python
from contextlib import asynccontextmanager
from fastapi import FastAPI
from app.core.config import settings
from app.core.database import engine
from app.routers import items

@asynccontextmanager
async def lifespan(app: FastAPI):
    # startup
    yield
    # shutdown
    await engine.dispose()

app = FastAPI(title=settings.app_name, lifespan=lifespan)
app.include_router(items.router, prefix="/api/v1")
```

**app/core/config.py**
```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    app_name: str = "My Service"
    database_url: str
    environment: str = "development"

    model_config = {"env_file": ".env"}

settings = Settings()
```

---

## Template B: Domain-First Application

For medium-to-large apps with multiple business areas.

```
project-name/
├── src/
│   └── project_name/
│       ├── __init__.py
│       ├── main.py
│       │
│       ├── core/
│       │   ├── __init__.py
│       │   ├── config.py
│       │   ├── database.py
│       │   ├── security.py
│       │   ├── logging.py
│       │   └── middleware.py
│       │
│       ├── shared/
│       │   ├── __init__.py
│       │   ├── exceptions.py    # Base exception classes
│       │   ├── pagination.py    # Shared pagination logic
│       │   └── utils.py
│       │
│       ├── auth/
│       │   ├── __init__.py
│       │   ├── router.py
│       │   ├── schemas.py
│       │   ├── models.py
│       │   ├── service.py
│       │   ├── repository.py
│       │   ├── dependencies.py
│       │   ├── config.py        # AuthConfig (JWT_SECRET, etc.)
│       │   └── exceptions.py
│       │
│       ├── users/
│       │   ├── __init__.py
│       │   ├── router.py
│       │   ├── schemas.py
│       │   ├── models.py
│       │   ├── service.py
│       │   ├── repository.py
│       │   └── exceptions.py
│       │
│       └── documents/           # Example: PDF processing domain
│           ├── __init__.py
│           ├── router.py
│           ├── schemas.py
│           ├── models.py
│           ├── service.py
│           ├── repository.py
│           ├── exceptions.py
│           └── extractors/      # Sub-package for pipeline stages
│               ├── __init__.py
│               ├── base.py      # Abstract extractor interface
│               ├── regex.py
│               ├── ocr.py
│               └── vision.py
│
├── tests/
│   ├── conftest.py
│   ├── factories.py             # Test data factories
│   ├── auth/
│   │   ├── test_router.py
│   │   └── test_service.py
│   ├── users/
│   │   └── ...
│   └── documents/
│       ├── test_service.py
│       └── test_extractors.py
│
├── alembic/
├── pyproject.toml
├── Dockerfile
├── docker-compose.yml
├── Makefile
├── .env.example
├── .gitignore
└── README.md
```

### Key files

**src/project_name/main.py**
```python
from contextlib import asynccontextmanager
from fastapi import FastAPI
from project_name.core.config import settings
from project_name.auth.router import router as auth_router
from project_name.users.router import router as users_router
from project_name.documents.router import router as docs_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    yield

app = FastAPI(title=settings.app_name, lifespan=lifespan)
app.include_router(auth_router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(users_router, prefix="/api/v1/users", tags=["users"])
app.include_router(docs_router, prefix="/api/v1/documents", tags=["documents"])
```

**Example domain: users/schemas.py**
```python
from pydantic import BaseModel, EmailStr
from datetime import datetime

class UserCreate(BaseModel):
    email: EmailStr
    password: str

class UserUpdate(BaseModel):
    email: EmailStr | None = None

class UserRead(BaseModel):
    id: int
    email: EmailStr
    created_at: datetime

    model_config = {"from_attributes": True}
```

**Example domain: users/service.py**
```python
from project_name.users.repository import UserRepository
from project_name.users.schemas import UserCreate
from project_name.users.exceptions import UserAlreadyExists

class UserService:
    def __init__(self, repo: UserRepository):
        self.repo = repo

    async def create_user(self, data: UserCreate):
        if await self.repo.exists(email=data.email):
            raise UserAlreadyExists(data.email)
        return await self.repo.create(data)
```

**Example domain: users/dependencies.py**
```python
from typing import Annotated
from fastapi import Depends
from project_name.core.database import get_session
from project_name.users.repository import UserRepository
from project_name.users.service import UserService

async def get_user_service(session=Depends(get_session)) -> UserService:
    return UserService(UserRepository(session))

UserServiceDep = Annotated[UserService, Depends(get_user_service)]
```

---

## Template C: Domain-First with Async Job Queue

Extended version of Template B for services that need background processing (PDF pipelines, ETL, etc.).

```
project-name/
├── src/
│   └── project_name/
│       ├── __init__.py
│       ├── main.py
│       │
│       ├── core/
│       │   ├── config.py
│       │   ├── database.py
│       │   ├── redis.py         # Redis connection pool
│       │   ├── security.py
│       │   └── logging.py
│       │
│       ├── jobs/                 # Background job infrastructure
│       │   ├── __init__.py
│       │   ├── worker.py        # ARQ/Celery worker entrypoint
│       │   ├── tasks.py         # Task registrations
│       │   └── schemas.py       # JobStatus, JobResult schemas
│       │
│       ├── documents/
│       │   ├── router.py
│       │   ├── schemas.py       # Upload, ExtractionResult
│       │   ├── models.py        # Document, Page, Cache tables
│       │   ├── service.py       # Pipeline orchestration
│       │   ├── repository.py
│       │   ├── exceptions.py
│       │   └── extractors/
│       │       ├── base.py
│       │       ├── regex.py
│       │       ├── ocr.py
│       │       └── vision.py
│       │
│       └── shared/
│           ├── exceptions.py
│           └── utils.py
│
├── tests/
├── alembic/
├── pyproject.toml
├── Dockerfile
├── docker-compose.yml           # app + worker + redis + postgres
├── Makefile
├── .env.example
└── README.md
```

### docker-compose.yml pattern
```yaml
services:
  api:
    build: .
    command: uvicorn project_name.main:app --host 0.0.0.0
    env_file: .env
    depends_on: [db, redis]

  worker:
    build: .
    command: arq project_name.jobs.worker.WorkerSettings
    env_file: .env
    depends_on: [db, redis]

  db:
    image: postgres:16
  redis:
    image: redis:7
```

---

## Template D: Python Library (for distribution)

For packages meant to be pip-installed by others.

```
project-name/
├── src/
│   └── my_library/
│       ├── __init__.py          # Public API re-exports
│       ├── client.py            # Main user-facing class
│       ├── models.py            # Public data models
│       ├── exceptions.py        # Public exceptions
│       ├── types.py             # Type aliases, protocols
│       ├── _internal/           # Private implementation
│       │   ├── __init__.py
│       │   ├── _transport.py
│       │   ├── _serialization.py
│       │   └── _utils.py
│       └── py.typed             # PEP 561 marker
│
├── tests/
│   ├── conftest.py
│   ├── test_client.py
│   └── test_models.py
│
├── docs/
│   ├── index.md
│   └── api.md
│
├── pyproject.toml
├── LICENSE
├── README.md
├── CHANGELOG.md
└── .github/workflows/
    ├── test.yml
    └── publish.yml
```

### __init__.py re-export pattern
```python
"""My Library - does something useful."""
from my_library.client import Client
from my_library.models import Config, Result
from my_library.exceptions import MyLibraryError

__all__ = ["Client", "Config", "Result", "MyLibraryError"]
```

---

## Template E: Monorepo / Multi-Package

For framework ecosystems with multiple installable packages.

```
project-name/
├── packages/
│   ├── core/
│   │   ├── src/
│   │   │   └── project_core/
│   │   │       ├── __init__.py
│   │   │       ├── base.py      # Abstract interfaces
│   │   │       └── types.py
│   │   ├── tests/
│   │   └── pyproject.toml
│   │
│   ├── main/
│   │   ├── src/
│   │   │   └── project_name/
│   │   │       ├── __init__.py
│   │   │       └── ...
│   │   ├── tests/
│   │   └── pyproject.toml       # depends on project-core
│   │
│   └── community/
│       ├── src/
│       │   └── project_community/
│       ├── tests/
│       └── pyproject.toml       # depends on project-core
│
├── examples/
├── docs/
├── pyproject.toml               # Workspace root
└── uv.lock                      # Single lockfile
```

### Workspace pyproject.toml
```toml
[project]
name = "project-workspace"
version = "0.0.0"

[tool.uv.workspace]
members = ["packages/*"]

[tool.uv.sources]
project-core = { workspace = true }
```

---

## pyproject.toml Starter

Applicable to Templates A-D:

```toml
[project]
name = "project-name"
version = "0.1.0"
description = "What this project does"
requires-python = ">=3.11"
dependencies = [
    "fastapi>=0.115",
    "uvicorn[standard]>=0.30",
    "pydantic-settings>=2.0",
    "sqlalchemy>=2.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.0",
    "pytest-asyncio>=0.24",
    "ruff>=0.8",
    "mypy>=1.13",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.hatch.build.targets.wheel]
packages = ["src/project_name"]

[tool.ruff]
target-version = "py311"
line-length = 100

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B"]

[tool.pytest.ini_options]
testpaths = ["tests"]
asyncio_mode = "auto"

[tool.mypy]
python_version = "3.11"
strict = true
```

---

## Makefile Starter

```makefile
.PHONY: install test lint format run

install:
	pip install -e ".[dev]"

test:
	pytest -v --tb=short

lint:
	ruff check src/ tests/
	mypy src/

format:
	ruff format src/ tests/
	ruff check --fix src/ tests/

run:
	uvicorn project_name.main:app --reload
```
