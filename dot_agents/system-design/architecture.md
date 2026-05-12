# LessonOps AI Real System Design

Date: 2026-05-10
Status: Draft v0.2

## 1. Purpose

This document defines the target system design for the real LessonOps AI platform.

The system should first serve Triway Education, then Maxfield Academy, then other tutoring schools and private schools.

The product is not only a question generator. It is a multi-tenant AI content operations platform for education:

```text
Trusted sources
-> Obsidian-style Knowledge Vault
-> AI-assisted draft generation
-> validation
-> teacher review
-> approved question bank
-> worksheets, assignments, analytics, feedback
```

## 2. Core Architecture Principle

```text
The database owns state.
The source library owns truth.
The Knowledge Vault owns learning structure.
AI owns drafts.
Validators own checkable correctness.
Teachers own approval.
```

The system must support AI generation, but it should not depend on raw AI output as final truth.

The Knowledge Vault is the heart of the product. It is the school's AI-readable teaching knowledge asset, not a search index hidden behind the application.

## 3. Recommended Hosting Direction

### 3.1 GCP-First Recommendation

Use Google Cloud from the beginning.

```text
GitHub
-> GitHub Actions and/or Cloud Build
-> Artifact Registry
-> Static frontend hosting
   - web/admin: static Next.js export for Teacher/Admin Portal
   - web/front: static Next.js export for Student Portal
   - Firebase Hosting preferred first, or Cloud Storage + Cloud CDN
-> Cloud Run services in a Canadian region
   - api: FastAPI / Python API
   - worker: ingestion, generation, validation, export jobs
-> Cloud SQL for PostgreSQL
-> Cloud Storage
-> Cloud Tasks and Pub/Sub
-> Secret Manager
-> Cloud Logging, Monitoring, and Error Reporting
-> OpenAI API for generation and Knowledge Vault analysis
```

Primary region choice:

- Use `northamerica-northeast2` Toronto when all required services are available there.
- Use `northamerica-northeast1` Montreal as fallback or secondary region.
- Keep Cloud Run, Cloud SQL, Cloud Storage, and queues in the same region where practical to reduce latency and cross-region cost.

Why this is the recommended production path:

- one cloud vendor from the beginning
- strong Canada-region options for school data
- static Next.js exports can be hosted cheaply and quickly on Firebase Hosting or Cloud Storage + Cloud CDN
- Cloud Run can host the API and worker services
- Postgres gives a durable system of record
- Cloud Storage keeps source files and generated artifacts outside the database
- Cloud Tasks and Pub/Sub support long-running AI/content workflows
- Secret Manager keeps OpenAI and other keys out of application code
- Cloud Logging and Monitoring give one operational view
- the architecture is easier to sell later to schools that want cloud, IAM, audit, and data-location clarity

This is a little more setup than Vercel, but it avoids an early platform migration and matches the business decision to build LessonOps as a serious platform.

### 3.2 Next.js On GCP

Next.js should remain the main web framework.

LessonOps should use Next.js in two different modes:

```text
Local development:
Next.js dev server
-> hot reload, route development, frontend build checks
-> calls the separate Python API server

Production:
Next.js static export
-> generated HTML/CSS/JS files
-> hosted by Firebase Hosting or Cloud Storage + Cloud CDN
-> calls the separate Python FastAPI service on Cloud Run
```

Default decision:

Use static Next.js export for the first real production frontend deployment.

Reasons:

- best performance for student-facing pages because static files are served from CDN edges
- no frontend server cold start
- lower cost and fewer moving parts
- simpler rollout and rollback for UI changes
- backend logic stays in Python FastAPI instead of Next.js route handlers
- frontend and backend can scale independently

The browser downloads the UI bundle, authenticates the user, and calls the Python API. The API owns authorization, tenant checks, source processing, AI generation, grading, and all privileged data access.

Optional convenience path:

Evaluate Firebase App Hosting or Cloud Run for a Next.js server only if a future feature truly needs server-side rendering, request-time middleware, server actions, or dynamic frontend server logic. Until then, do not run a Node.js frontend server in production.

Production domain shape:

```text
app.triwayeducation.com
-> static frontend hosting

api.triwayeducation.com
-> Cloud Run FastAPI service
```

### 3.3 Hosting Decision For Now

Decision:

Start with GCP for all production tiers.

Keep the architecture clean:

- no business logic locked inside framework-specific route handlers
- no direct client access to privileged database operations
- API layer owns authorization checks
- storage paths and source files use tenant-scoped keys
- migrations are versioned in Git and applied separately
- secrets live in Secret Manager
- every service emits structured logs

### 3.4 Vercel Compared With GCP

Vercel remains an excellent frontend platform, especially for small teams building Next.js quickly.

Vercel advantages:

- fastest GitHub-to-preview deployment workflow
- very strong Next.js developer experience
- simple custom domain, SSL, CDN, and rollback experience
- low DevOps burden
- preview URLs for every branch or pull request
- easy parallel frontend work

GCP advantages:

- one vendor for frontend, backend, database, storage, queues, logs, secrets, IAM, and audit
- Cloud Run for Next.js, APIs, workers, and jobs
- Cloud SQL for managed PostgreSQL
- Cloud Storage for source files and generated assets
- Cloud Tasks, Pub/Sub, and Workflows for background processing
- stronger IAM, audit, VPC, KMS, and enterprise/security controls
- Montreal and Toronto regions
- no developer-seat hosting fee
- often better long-term fit for selling the platform to other schools

Cost comparison, using public pricing direction as of May 2026:

```text
Vercel + Supabase early production:
- Lower engineering setup cost.
- Vercel Pro has per-developer seat pricing plus usage.
- Supabase Pro adds a managed Postgres/Auth/Storage cost.
- Practical early estimate is often simple and predictable for one or two developers, before OpenAI usage.

GCP early production:
- Cloud Run and Firebase hosting paths can be low cost at small traffic.
- Cloud Run request-based services include free-tier style usage allowances.
- Cloud SQL / PostgreSQL is the main fixed cost because it is an always-on production database.
- Cloud Build, Artifact Registry, logs, storage, egress, and secrets are usage-based.
- Practical early estimate can still be modest, but usually requires more configuration discipline than Vercel/Supabase.
```

Cost interpretation:

- LessonOps' first major variable cost will probably be AI generation and source processing, not static web hosting.
- GCP may cost more engineering time at the beginning, but avoids a later migration.
- GCP is the better strategic fit if LessonOps will be sold to external tutoring schools and private schools.

Recommended decision:

Use GCP from the beginning. Deploy static Next.js portal bundles to Firebase Hosting or Cloud Storage + Cloud CDN first. Deploy the Python API and worker services to Cloud Run. Consider Firebase App Hosting or Cloud Run for a Next.js server later only if static export blocks a real product requirement.

## 4. Tiered Architecture

LessonOps should be designed as a clear multi-tier system.

The first production system should use these tiers:

```text
Client/UI Tier
-> API/Application Tier
-> Background Worker Tier
-> AI/Validation Service Tier
-> Data Tier
-> Object Storage Tier
-> Observability/Operations Tier
```

The boundaries matter. UI code must not directly own business rules, database schema changes, privileged database writes, source-processing jobs, or AI provider calls.

### 4.1 Client/UI Tier

Responsibilities:

- Teacher/Admin Portal
- Student Portal
- responsive layouts
- form validation for user experience
- API client calls
- display source lineage, statuses, and validation results
- no direct database access
- no OpenAI API keys
- no privileged tenant operations

The UI may perform basic client-side checks, but server-side API validation remains authoritative.

### 4.2 API/Application Tier

Responsibilities:

- authentication and authorization checks
- tenant isolation
- request and response validation
- source metadata management
- generation request orchestration
- review workflow
- question bank workflow
- worksheet and assignment workflow
- student attempt recording
- audit event creation

The API tier is the only tier that should expose business operations to the UI.

The API tier must not run runtime DDL. Database schema changes must be applied through reviewed migrations outside application runtime.

Production request model:

- Use FastAPI behind Cloud Run, not the local standard-library development API server.
- Use Pydantic request and response schemas on every public route.
- Use domain routers, not one large API file.
- Use app lifespan startup checks for required secrets, database settings, migration version, queue configuration, and AI provider configuration.
- Use app lifespan shutdown to close pooled database connections and other long-lived clients cleanly.
- Use structured middleware for request ID, route, status, error code, and duration.
- Use global exception handlers for validation errors, authorization errors, database-pool exhaustion, upstream AI failures, and queue dispatch failures.
- Use context-managed pooled database connections. The API must not open a new physical database connection for each request.
- Do not run CPU-heavy parsing, source extraction, PDF rendering, large AI calls, or long generation inside the API request path.
- Use `run_in_threadpool` or equivalent only for short blocking calls that must happen in the request path. Durable work belongs in Cloud Tasks/worker services.
- FastAPI `BackgroundTasks` may be used for short non-critical post-response work, such as usage logging. Production-critical generation, ingestion, grading, package building, and exports must use durable queues.

### 4.3 Background Worker Tier

Responsibilities:

- source file ingestion
- text extraction
- chunking
- anchor extraction
- Knowledge Vault analysis and indexing jobs
- long-running AI generation
- worksheet/PDF generation
- analytics rollups
- retryable asynchronous jobs

Background workers must use tenant context and audit important changes.

Background workers also must not run runtime DDL.

### 4.4 AI/Validation Service Tier

Responsibilities:

- prompt templates
- model/provider adapter
- structured output schemas
- Knowledge Vault context bundle assembly
- deterministic validators
- AI generation logging
- validation results
- model and prompt version tracking

This can start as a package inside the API app, but it should be treated as a separate logical tier so we can later move heavy AI jobs to dedicated workers.

AI output creates drafts only. It never creates approved student-visible content directly.

### 4.5 Data Tier

Responsibilities:

- PostgreSQL system of record
- tenant data
- users, students, classes
- sources and source metadata
- generated drafts
- approved questions
- review events
- assignments
- attempts
- audit events

Rules:

- schema changes through migrations only
- no runtime DDL
- tenant-owned rows include `tenant_id`
- important state changes are auditable
- app code fails fast if required migrations are missing

### 4.6 Object Storage Tier

Responsibilities:

- uploaded source files
- extracted source artifacts
- Knowledge Vault Markdown files
- Knowledge Vault manifests and exports
- generated worksheet PDFs
- source preview artifacts
- approved AI Learning Preview assets
- optional image/media assets

Storage keys must be tenant-scoped.

Do not store large files directly in PostgreSQL unless there is a specific reviewed reason.

### 4.7 Observability/Operations Tier

Responsibilities:

- logs
- errors
- traces
- job status
- usage metrics
- AI cost tracking
- security/audit events
- backup status

Production cannot be considered ready without basic observability.

### 4.8 Tier Boundary Rules

- UI calls API only.
- API owns business rules and authorization.
- API and workers access the database through the approved data access layer.
- AI provider calls happen server-side only.
- Workers handle long-running work.
- Database schema changes happen through migrations only.
- Object storage holds files; database stores metadata and references.
- Student Portal reads approved assignment/question APIs only.

### 4.9 Recommended Technology By Tier

Use TypeScript for the UI layer and Python for the backend layer.

Recommended baseline:

```text
Frontend package manager: pnpm
Frontend task orchestration: Turborepo
Frontend runtime: Node.js LTS
Frontend language: TypeScript strict mode
Backend language: Python 3.12+
Backend dependency manager: uv
```

#### Client/UI Tier

Default technology:

- Next.js App Router
- React
- TypeScript
- Tailwind CSS
- shadcn/ui with Radix UI primitives
- lucide-react icons
- TanStack Query for server-state caching when needed
- React Hook Form plus Zod for complex forms
- Playwright for browser workflow testing

Deployment:

- local development: Next.js dev server
- production first path: Next.js static export hosted on Firebase Hosting or Cloud Storage + Cloud CDN
- optional later path: Next.js server on Firebase App Hosting or Cloud Run only if request-time frontend server features become necessary

Reason:

Next.js gives us a strong React application framework for routing, component structure, static generation, and future portability. Static export gives LessonOps the fastest and simplest first production path: HTML/CSS/JS served from CDN, with all privileged work handled by the Python API. This is especially important for the student portal, where page speed and low infrastructure cost matter.

#### API/Application Tier

Default technology:

- Python 3.12+
- FastAPI for HTTP routing
- Pydantic v2 for request/response validation and schemas
- OpenAPI contract generated from route schemas
- openapi-typescript and openapi-fetch for typed frontend clients
- Firebase Auth or Google Cloud Identity Platform JWT verification
- structlog or standard JSON logging

Deployment:

- Cloud Run service from the beginning

Reason:

Python should own the backend from day one because source parsing, AI orchestration, document processing, validation, and future data/ML workflows are likely to need Python anyway. FastAPI gives a mature Python API layer with OpenAPI generation, Pydantic validation, async support, and strong Cloud Run compatibility. The frontend still gets typed clients from the API's OpenAPI contract, so Kevin and the admin portal can work safely against the same backend contract.

Important rule:

The API tier must not run runtime DDL. Migrations are applied separately.

#### Background Worker Tier

Default technology:

- Python 3.12+
- Pydantic v2 for job payload validation
- Cloud Tasks for request-driven background jobs
- Pub/Sub for event fan-out and asynchronous pipelines
- Cloud Run services/jobs for workers
- FastAPI endpoints for Cloud Tasks push targets where appropriate
- Playwright or a dedicated PDF library for worksheet PDF rendering, inside workers only

Deployment:

- local/manual worker during early development
- Cloud Run worker service for queued jobs
- Cloud Run job for batch/backfill work

Reason:

Using Python for both API and workers avoids two backend stacks. Cloud Tasks and Pub/Sub keep the worker tier aligned with GCP from the beginning. Cloud Run gives us a consistent deployment target for ingestion, Knowledge Vault indexing, validation, PDF rendering, and other long-running content operations.

Important rule:

Any worker-support database tables must be installed through reviewed migrations/deployment steps. Do not call worker schema migration helpers from application runtime code.

#### AI/Validation Service Tier

Default technology:

- OpenAI Responses API for generation
- OpenAI Python SDK
- JSON Schema/Pydantic schemas for structured generated output
- deterministic validators written in Python
- Decimal or Fraction from the Python standard library where exact arithmetic is required
- SymPy or a reviewed symbolic/math library only where deterministic validation needs it

Deployment:

- package inside clearly named modules under `apps/api/common`, imported by the API and worker services
- called server-side by API or workers

Reason:

Generation and validation should be reusable from API requests and background jobs. AI provider calls must stay server-side. Structured output keeps drafts predictable and reviewable.

Important rule:

AI creates drafts only. Teacher approval is required before content becomes student-visible.

#### Data Tier

Default technology:

- PostgreSQL
- Cloud SQL for PostgreSQL in the selected Canadian region
- SQLAlchemy 2.x for database access
- Alembic migrations committed to Git
- PostgreSQL full-text search and rebuildable KB index tables

Reason:

PostgreSQL is the system of record for relational app state, permissions, workflow, attempts, marks, and audit history. It is not the source of truth for Knowledge Base content. The Knowledge Base source of truth is the Markdown Knowledge Vault. Cloud SQL keeps relational state inside the same cloud, region strategy, IAM/audit model, and operational tooling as the rest of the platform. SQLAlchemy and Alembic keep Python backend code, database access, and reviewed migrations in one consistent backend stack.

Important rule:

No runtime DDL. No `db push`-style production schema changes. Migrations only.

#### Object Storage Tier

Default technology:

- Cloud Storage for uploaded sources and generated artifacts
- tenant-scoped bucket/key structure
- signed URLs for private file access

Reason:

Keep large files out of PostgreSQL. The database stores metadata, permissions, and references; object storage stores the file bytes.

#### Observability/Operations Tier

Default technology:

- Cloud Logging and Cloud Monitoring
- Error Reporting
- Sentry for frontend/backend error monitoring
- structured JSON logs from API/workers
- application tables for AI usage/cost audit
- GitHub Actions for CI
- Cloud Build for GCP deployments
- Playwright for smoke tests
- Vitest for unit tests

Future additions:

- OpenTelemetry tracing
- uptime monitoring service

Reason:

The first system needs enough visibility to debug production quickly without building a heavy observability platform too early. GCP-native logs and metrics give us one place to inspect web, API, worker, database, and queue behavior.

#### Auth And Permissions

Default technology:

- Firebase Auth or Google Cloud Identity Platform for login
- Google sign-in enabled from day one
- email/password only if needed for users who cannot use Google
- JWT verified in API tier
- `memberships` table for tenant roles
- invitation tokens, class codes, and assignment codes for onboarding into a tenant
- server-side role checks in every protected route

Reason:

Firebase Auth is the simplest GCP-native login path for the first production system. Google Cloud Identity Platform is the stronger future option if we need enterprise identity features. Application-level memberships keep school-specific permissions under our control.

Important auth rule:

```text
Firebase/Google Auth proves identity.
LessonOps memberships decide school access and role.
```

Google login must not automatically create teacher/admin access inside a school tenant.

Allowed onboarding paths:

- teacher/admin invited by an owner or admin
- student invited by teacher/admin
- student joins with class code or assignment code
- school owner self-signup later for SaaS onboarding

Triway first-launch rule:

- no public teacher self-registration into the Triway tenant
- student access can begin with assignment links/codes
- Google login is supported but role and tenant access come from LessonOps database records

## 5. Repository Shape

Recommended monorepo:

```text
apps/
  web/
    admin/
    front/
    common/
  api/
    admin/
    front/
    common/
  worker/
packages/
  ui/
  config/
  api-client/
database/
  migrations/
  seed/
docs/
  system-design/        # source repo copy, or ~/.agents/system-design when shared globally
    ui-design.md
    architecture.md
    coding-standards.md
```

Ownership:

- `apps/web/admin`: main team
- `apps/web/front`: Kevin
- `apps/api`: shared, reviewed carefully
- `apps/api/admin`: admin-facing API modules
- `apps/api/front`: future student-facing API modules
- `apps/api/common`: shared backend logic and helpers used by admin/front APIs
- `apps/web/common`: shared frontend primitives/components used by both portals
- `apps/worker`: backend jobs if separated from the API service
- `packages/ui`: shared design system
- `packages/api-client`: generated TypeScript client from the Python API OpenAPI contract
- `database/migrations`: Alembic or SQL migration files
- `database/seed`: local and reviewed seed data
- backend domain services, repositories, validators, and AI adapters live under `apps/api/common` unless a dedicated backend package becomes necessary

## 6. Frontend Architecture

Recommended stack:

- TypeScript
- React
- Next.js App Router
- Tailwind CSS
- shadcn/ui with Radix UI primitives
- shared component package
- shared design tokens
- TanStack Query when client-side server-state caching is needed
- Playwright for workflow tests

Admin Portal:

- desktop-first
- table-heavy
- review/editor workflows
- source preview panel

Student Portal:

- mobile-friendly
- assignment and practice player
- approved content only

Both portals should call the API through typed clients generated or derived from the shared schema.

## 7. Backend Architecture

Recommended stack:

- Python 3.12+
- FastAPI for HTTP routing
- Pydantic v2 and OpenAPI for API contracts
- PostgreSQL
- SQLAlchemy 2.x for database access
- Alembic for migrations
- Cloud Tasks, Pub/Sub, and Cloud Run jobs for background work
- OpenAI service adapter behind the API/worker boundary

Initial API responsibilities:

- authentication and role checks
- tenant isolation
- source upload and metadata
- source parsing and chunking
- source search
- generation profile management
- AI generation orchestration
- deterministic validation
- review workflow
- question bank
- worksheets and assignments
- assessment builder and locked exam exports
- student attempts
- grading, marks, and result summaries
- analytics queries

### 7.1 FastAPI Runtime Pattern

LessonOps should follow the production lessons from AiUniScan's FastAPI service:

- `app.main` owns FastAPI app creation, middleware, lifespan startup/shutdown, and global exception handlers.
- Routers live under domain modules, such as auth, sources, knowledge, generation, review, assignments, attempts, assessments, and admin.
- Service modules own business workflows. Routers should validate, authorize, call services, and return typed responses.
- Repository/data-access modules own SQL and database calls.
- The DB pool is a process-wide shared service, closed during app shutdown.
- Database-pool exhaustion returns a clear `503` response, not an unbounded connection storm.
- Middleware assigns or propagates `X-Request-Id` and writes one structured request log per API request.
- Blocking SDK calls, Cloud Storage operations, and legacy synchronous helpers are run in a threadpool only when they are short enough for the request path.
- Internal worker endpoints are separate from public APIs and protected by OIDC and/or shared worker token checks.
- OpenAPI is treated as the frontend contract; generated frontend clients should consume it.

The local standard-library API server is allowed only for local development until the FastAPI service is in place. It is not a production runtime.

### 7.2 High-Volume Request Classes

LessonOps traffic will not be evenly distributed. The design should separate these request classes:

| Request class | Example | Target handling |
| --- | --- | --- |
| Static web and assets | Next.js exported HTML, JS, CSS | Firebase Hosting or Cloud Storage + Cloud CDN |
| Student package reads | Opening a practice assignment | API verifies access, returns signed Cloud Storage package URL |
| Student question navigation | Moving between questions | Browser reads immutable downloaded package, no per-question DB call |
| Attempt autosave / submit | Batched answer writes | API accepts small batched writes and final submit |
| Teacher/admin reads | dashboards, source library, review queues | paginated/indexed API queries |
| Teacher source upload | upload file or add URL | direct/signed upload plus queued ingestion |
| AI generation | draft question generation, preview generation | Cloud Tasks to worker, API returns job/batch status |
| Source processing | extraction, chunking, anchors, KB notes | Cloud Tasks/worker or batch Cloud Run job |
| Assessment export | exam PDF, answer key, package build | Cloud Tasks/worker, immutable output artifacts |
| Analytics rollups | weak topics, observed difficulty | asynchronous worker jobs |

The student portal must be optimized for repeated practice at scale:

- immutable student packages live in Cloud Storage
- package metadata and access checks live in PostgreSQL
- packages are downloaded once per assignment/session and cached by the browser where allowed
- autosave writes are batched and throttled
- final submit is one authoritative API call
- grading can be synchronous only for small deterministic submissions; large/open-response grading should queue review/AI-assisted grading work

This keeps high-volume student interactions away from PostgreSQL hot paths.

### 7.3 Cloud Run Scaling Model

Initial production deployment should use static frontend hosting plus separate Cloud Run backend services:

```text
web/admin             static Next.js export on Firebase Hosting or Cloud Storage + Cloud CDN
web/front             static Next.js export on Firebase Hosting or Cloud Storage + Cloud CDN
api                   FastAPI public API
worker-ingestion      source ingestion, extraction, KB indexing
worker-generation     AI generation, validation, preview generation
worker-assessment     PDF/package export and heavier assessment jobs
```

Starting configuration for early production:

| Service | Min instances | Max instances | Concurrency | Notes |
| --- | ---: | ---: | ---: | --- |
| `api` | 1 | 5-10 | 40 | Fast request/response only |
| `worker-ingestion` | 0 | 3 | 1-2 | source parsing can be CPU/memory heavy |
| `worker-generation` | 0 | 5-20 | 1-2 | bound by AI provider latency/cost limits |
| `worker-assessment` | 0 | 2-5 | 1 | PDF/package builds should be isolated |

Frontend static hosting scales through the hosting/CDN layer rather than Cloud Run instance counts. The exact Cloud Run values should be changed only after load testing. The important design point is separation: static UI delivery, API capacity, and worker capacity scale independently.

### 7.4 Database Pool And Backpressure

Every API/worker instance must use a bounded DB pool.

Initial defaults:

```text
API DB_POOL_MAX_SIZE: 10
API DB_POOL_WAIT_TIMEOUT_SEC: 5
worker DB_POOL_MAX_SIZE: 3-5
worker DB_POOL_WAIT_TIMEOUT_SEC: 5
```

Capacity rule:

```text
maximum possible database connections =
  api_max_instances * api_db_pool_size
+ sum(worker_max_instances * worker_db_pool_size)
+ migration/admin overhead
```

This number must stay below the safe Cloud SQL connection capacity with headroom.

If PostgreSQL or Cloud SQL starts to become the bottleneck:

- reduce Cloud Run max instances or pool size before the database is overloaded
- move repeated reads to immutable Cloud Storage packages or cache layers
- improve indexes and query plans
- add read replicas only for true read-heavy reporting workloads
- evaluate PgBouncer or Cloud SQL connection pooling patterns only after we have measured need

Never solve high traffic by allowing unbounded database connections.

### 7.5 Queue And Worker Backpressure

Long-running jobs must enter durable queues.

Recommended queues:

- `source-ingestion-jobs`
- `knowledge-vault-jobs`
- `generation-jobs`
- `preview-generation-jobs`
- `assessment-export-jobs`
- `grading-jobs`
- `analytics-rollup-jobs`

Each queue should define:

- max dispatches per second
- max concurrent dispatches
- retry attempts
- exponential backoff
- dead-letter or failed-job visibility
- tenant and actor metadata
- idempotency key

Cloud Tasks is the default for request-driven jobs. Pub/Sub is useful for event fan-out, such as "question approved" triggering analytics, cache/package invalidation, or downstream notifications.

Workers must be idempotent. Retried jobs must not duplicate approved questions, source anchors, student attempts, marks, packages, or audit events.

### 7.6 API Latency Targets

Targets for early production:

| Operation | p95 target | Notes |
| --- | ---: | --- |
| health check | < 100 ms | no DB dependency if possible |
| auth/session check | < 300 ms | cached public keys, indexed membership lookup |
| dashboard list page | < 800 ms | paginated queries |
| review queue page | < 1000 ms | indexed tenant/status filters |
| signed package URL | < 500 ms | no package assembly in request |
| attempt autosave batch | < 500 ms | small batched writes |
| final deterministic grading | < 1500 ms | queue complex grading |
| generation request creation | < 800 ms | returns batch/job id |
| source upload URL creation | < 500 ms | direct upload path |

AI generation, preview generation, source extraction, package export, and large analytics work should report job status instead of holding open normal API requests.

Streaming can be used for selected teacher-facing AI experiences, but it should not be required for core student practice delivery.

### 7.7 Rate Limits And Abuse Controls

High-volume production needs explicit limits:

- per-user and per-tenant limits for AI generation
- per-student attempt autosave throttling
- per-assignment package URL request throttling
- file upload size/type limits
- source URL import SSRF protection
- tenant-level monthly AI cost budgets and alerts
- admin override workflows for temporarily raising limits

Requests over limit should return clear `429` responses. Heavy jobs over tenant quota should remain queued, rejected, or require admin approval based on school policy.

### 7.8 Load Testing And Launch Gates

Before production launch, run load tests for:

- one class of 30 students opening the same assignment
- 200 students opening packages over 5 minutes
- 200 students submitting attempts over 10 minutes
- 10 teachers generating drafts at the same time
- source ingestion while normal student traffic continues
- review queue filtering with thousands of questions
- assessment export under worker load

Production launch gate:

- no endpoint opens unbounded DB connections
- no normal student navigation hits PostgreSQL per question
- all list APIs are paginated
- tenant/status/date filter columns are indexed
- queues have explicit rate/concurrency/retry settings
- DB pool exhaustion returns 503 and is observable
- Cloud Run concurrency/max instances are documented
- logs include request id, route, duration, status, and error code
- dashboards exist for API latency, error rate, queue depth, DB connections, and AI cost

## 8. Data Model

Core tables:

```text
tenants
users
auth_identities
memberships
invitations
students
classes
enrollments
class_join_codes
sources
source_versions
source_files
source_chunks
source_anchors
knowledge_vaults
knowledge_note_index
knowledge_link_index
knowledge_view_index
generation_profiles
generation_profile_versions
generation_batches
questions
question_choices
question_solutions
question_lineage
validation_runs
question_previews
preview_assets
preview_review_events
review_events
question_bank_items
worksheets
worksheet_items
assessment_blueprints
assessments
assessment_versions
assessment_sections
assessment_items
assessment_exports
assignments
assignment_items
assignment_access_codes
student_attempts
student_attempt_answers
student_attempt_scores
student_attempt_summaries
student_result_rollups
question_difficulty_stats
topic_taxonomy
audit_events
```

Knowledge Base content is not stored primarily in these tables. The Markdown Knowledge Vault is the source of truth. The `knowledge_*_index` tables are rebuildable indexes for search, permissions, views, and graph navigation.

Important fields:

- `tenant_id` on tenant-owned records
- `created_by`
- `updated_by`
- `status`
- `source_usage_status`
- `rights_category`
- `trust_level`
- `approval_status`
- `approved_by`
- `approved_at`
- `archived_at`
- `expires_at` for invitations and join/access codes
- `accepted_at` for invitations and onboarding events

Every generated question must connect to source lineage.

## 9. Tenant Isolation

LessonOps should be multi-tenant from the beginning, even while only Triway uses it.

Rules:

- every school is a tenant
- every user has memberships
- every query checks tenant scope
- no cross-tenant source access
- no cross-tenant question bank access
- super-admin access must be explicit and audited

Do not retrofit tenant isolation later. It is too expensive and risky.

### 9.1 Domain And Tenant Routing

LessonOps should support both shared platform domains and customer-owned school domains.

Initial Triway deployment:

```text
triwayeducation.com        existing public website
www.triwayeducation.com    existing public website
app.triwayeducation.com    LessonOps app on GCP
```

Future SaaS deployment:

```text
app.lessonops.ai          shared platform entry
schoolname.lessonops.ai   optional tenant subdomain
app.schooldomain.com      optional customer-owned school domain
```

Routing rules:

- hostname maps to tenant or shared platform entry
- path maps to portal area, such as `/admin` or `/practice`
- signed assignment links may route directly to `/practice/a/{assignment_code}`
- tenant lookup must happen server-side
- tenant branding should be configuration, not code forks
- unknown domains must fail closed

Custom domains should be treated as tenant configuration:

```text
tenant_id
hostname
domain_type
verification_status
tls_status
created_at
```

This supports one platform for many schools while allowing premium customers to use their own school domain.

### 9.2 Role Model And Teacher Permissions

LessonOps should use roles as permission bundles, but the backend should enforce capabilities.

Core roles:

- Owner
- Admin
- Curriculum Lead / Reviewer
- Teacher
- Assistant Teacher / Content Contributor
- Student

Teacher default capability:

```text
source.upload_own
source.tag_own
source.use_shared
kb_note.create_draft_own
generation.create
draft.review_own
draft.edit_own
worksheet.create_own_classes
assignment.create_own_classes
assessment.create_draft_own_classes
student_results.view_own_classes
```

Teacher optional capability, controlled by school policy:

```text
draft.publish_to_own_classes
question.approve_for_own_classes
source.share_with_class
kb_note.submit_for_review
assessment.finalize_own_classes
```

Reviewer / Curriculum Lead capability:

```text
source.approve_tenant_shared
kb_note.approve_tenant_shared
question.approve_tenant_shared
question.reject
review.assign
teacher_content.view_for_review
taxonomy.manage_content_tags
```

Admin capability:

```text
users.manage
classes.manage
tenant_settings.manage
source_library.admin
knowledge_vault.admin
content_workflow.admin
```

Owner capability:

```text
billing.manage
domains.manage
roles.manage
tenant.delete_or_export
```

Source visibility should be explicit:

```text
private_to_uploader
shared_with_class
tenant_shared
blocked
```

Teacher-uploaded sources should not automatically become tenant-wide shared sources unless the school enables that policy or a Reviewer/Admin approves the source rights and metadata.

## 10. Source Library Design

Source records should store:

- tenant
- title
- source entry method: upload or URL import
- subject
- grade
- course/program
- topic tags
- source type
- owner
- rights category
- trust level
- source usage status
- original URL if public
- URL fetch status
- fetched_at
- content type
- content length
- content hash/checksum
- uploaded file reference
- stored raw source object path
- extracted text
- chunks
- anchors
- generated question count

Source processing pipeline:

```text
teacher uploads file or adds source URL
-> source record created as processing
-> uploaded file is stored, or URL is downloaded by worker
-> raw source file is stored in Cloud Storage
-> original URL, fetch metadata, content type, and checksum are recorded
-> text extracted
-> metadata extracted
-> teacher confirms tags
-> chunks created
-> anchors created
-> source becomes usable for Knowledge Vault building and source-linked generation
```

URL import rules:

- URL import runs only in the backend worker, never directly from the browser.
- Only HTTP/HTTPS URLs are allowed.
- The worker must block localhost, private network, link-local, and cloud metadata service addresses.
- The worker must enforce file size, content type, redirect, and timeout limits.
- The worker must not bypass paywalls, logins, robots restrictions, or license terms.
- URL-imported sources still require teacher/reviewer confirmation of rights, trust, metadata, and allowed use before tenant-wide sharing.
- The stored Cloud Storage object becomes LessonOps' reviewed copy for extraction and audit; the original URL remains lineage, not the only source record.

Source usage statuses:

- school_owned
- public_domain_reference
- official_reference_research_only
- free_educator_use_restricted
- permission_required
- blocked

## 11. Knowledge Base Design

Detailed design: [Knowledge Base Design](knowledge-base.md).

LessonOps should use an Obsidian-style Knowledge Base.

The Knowledge Base source of truth is a per-tenant Markdown Knowledge Vault, not database rows and not a vector database.

```text
Source Library
-> extracted chunks and anchors
-> LLM/graphify draft analysis
-> Markdown KnowledgeNotes with properties and internal links
-> teacher/reviewer approval
-> approved KB slice used for generation
```

Knowledge Vault notes should use:

- Markdown content
- YAML frontmatter properties
- internal links/backlinks
- source anchors
- approval status
- teaching notes
- generation guidance
- common mistakes

The database may store rebuildable indexes:

- note path and hash
- note status
- properties
- links and backlinks
- source anchor references
- review state
- search index
- view index

If these index rows are lost, the system should rebuild them from the Markdown vault.

Do not use pgvector, another vector database, or embedding indexes in the planned core KB architecture. LessonOps should use properties, links, backlinks, graph traversal, source anchors, full-text search, and AI-built context bundles from approved Markdown notes.

Generation should use a KB slice, not only one source file:

```text
Teacher selects Grade 7 Ratio and Proportion
-> system loads approved KnowledgeNotes, linked prerequisites, common mistakes, and source anchors
-> generation profile controls question mix/difficulty/output
-> AI drafts questions with KB note IDs and source lineage
-> validators and teacher review run before student visibility
```

## 12. AI Architecture

AI should be behind service boundaries.

AI flow:

```text
API receives generation request
-> load Generation Profile and teacher overrides
-> load approved Knowledge Vault notes for the selected KB slice
-> attach source chunks and anchors referenced by those notes
-> construct prompt with schema
-> call model
-> parse structured output
-> run validators
-> store draft questions
-> create review events
```

Use structured output schemas for:

- question text
- choices
- correct answer
- solution steps
- hints
- source citations
- difficulty
- difficulty_level
- difficulty_source
- difficulty_factors
- topic tags
- question type
- answer type
- grading mode
- rubric or expected key points when needed
- preview plan and preview status when requested
- validation assumptions

Recommended AI rules:

- no generated content goes directly to students
- all drafts start as `draft`
- all prompts and outputs are logged with redaction
- model version is stored
- source IDs are stored in lineage
- Knowledge Vault note IDs are stored in lineage
- generation profile ID and version are stored on every generation batch
- preview prompt/version and generated asset metadata are stored when AI Learning Preview is used
- teacher edits are stored separately from raw generated draft

### 11.1 Teacher-Controlled Generation Profiles

LessonOps should not depend on raw prompt text as the main way teachers control generation.

A Generation Profile is a saved blueprint that defines:

- target subject, grade, course, and student level
- source set and source alignment mode
- question type mix
- difficulty mix
- answer format
- grading mode
- rubric or expected key-point requirements
- visual / preview requirements
- language
- optional teacher instruction

Supported question types should include:

- multiple choice
- multi-select
- numeric response
- short answer
- open response
- proof / justification
- reading comprehension
- essay / paragraph
- coding problem
- code tracing
- matching
- fill in the blank

Different question types require different structured output contracts:

- multiple choice: choices, correct choice, distractor rationale
- numeric / fraction / expression: canonical answer and accepted comparison rule
- short answer: accepted answer patterns and teacher notes
- open response / proof / essay: rubric, sample answer, expected key points, grading guidance
- reading comprehension: passage reference, answer support, reading skill tag
- coding: starter code, function signature, sample tests, hidden-test metadata, runtime

Generation batches must preserve the profile version and any one-time teacher override. This makes drafts auditable, reusable, and easier to regenerate consistently.

### 11.2 AI Learning Preview Generation

LessonOps should separate original evidence from learning support.

- Original Source Preview: teacher-facing source evidence extracted from the trusted source. It is used to compare the generated draft with the original source.
- AI Learning Preview: student-facing visual or contextual aid generated or rendered for the approved question.

The Original Source Preview must never be replaced by AI. It is evidence, not decoration.

Preview generation flow:

```text
draft question or approved question version
-> create preview plan
-> choose deterministic renderer or image generation
-> generate draft preview asset
-> store preview asset in Cloud Storage
-> teacher reviews / regenerates / approves / rejects
-> approved preview asset is included in student package
```

Use deterministic renderers for exact visual information:

- geometry diagrams
- number lines
- graphs
- tables
- charts
- code traces
- formula-heavy visuals

Use AI-generated images for contextual learning support:

- English story scenes
- character maps
- setting or mood visuals
- vocabulary context
- science concept scenes where exact labels are not critical
- non-essential math story context

Preview statuses:

- `draft`
- `needs_teacher_review`
- `approved`
- `rejected`
- `archived`

Recommended preview metadata:

- `question_id`
- `question_version_id`
- `preview_type`
- `preview_plan`
- `renderer_type`: deterministic, image_generation, or hybrid
- `teacher_instruction`
- `prompt_version`
- `model_provider`
- `model_name`
- `asset_path`
- `alt_text`
- `status`
- `approved_by`
- `approved_at`

Preview rules:

- previews must not reveal the answer
- generated image text must not carry critical math, spelling, grammar, code, or answer information
- exact labels and numbers should be rendered deterministically on top of the asset when needed
- only approved previews are student-visible
- preview assets are stored in Cloud Storage, not embedded as database blobs
- do not send student PII into preview generation prompts

OpenAI's current image-generation guidance supports either the Image API for a single prompt image or the Responses API for editable image experiences. LessonOps should keep this behind the AI service layer so the provider/API choice can change without changing portal code.

### 11.3 Question Difficulty Model

Difficulty should be stored as a structured educational signal, not only as display text.

Recommended internal scale:

| Level | Label | Meaning |
| --- | --- | --- |
| `D1` | Scaffolded | direct recall, one concept, guided or very low reading/calculation load |
| `D2` | Basic | one main skill, simple numbers, familiar setup |
| `D3` | Standard | grade-level practice, 2-3 steps, normal wording |
| `D4` | Challenging | multi-step or multi-concept, less direct setup, higher reasoning load |
| `D5` | Extension | contest-style, proof/analysis, transfer, or open-ended high independence |

Store both estimate and evidence:

- `difficulty_level`
- `difficulty_label`
- `difficulty_source`: teacher, source_anchor, ai_estimate, or observed_performance
- `difficulty_factors`: step count, concept count, prerequisite count, reading load, calculation complexity, abstraction, novelty, answer format complexity
- `estimated_time_minutes`
- `teacher_override_reason`
- observed stats: correct rate, median time, hint usage, retry count, abandon rate

Initial difficulty should come from source structure and teacher review. For CEMC-style contests, Part A can map roughly to D1-D2, Part B to D3-D4, and Part C to D5, with teacher override. For English, difficulty should consider passage length, vocabulary, literal vs inferential reading, evidence requirement, and writing/rubric complexity.

Observed student performance should update a separate observed difficulty signal. It can improve recommendations and filters, but should not silently overwrite teacher-approved difficulty metadata.

## 13. Validation Architecture

Validators should be deterministic where possible.

Validator package should support:

- multiple choice
- fractions
- decimals with tolerance
- integer arithmetic
- algebraic equivalence where safe
- geometry numeric values from structured specs
- reading comprehension answer key consistency
- coding sample tests and hidden tests

Validation status:

- passed
- failed
- not_applicable
- needs_teacher_review

Validation is evidence, not approval.

## 14. Assessment And Exam Builder Flow

Assessment Builder handles quizzes, unit tests, midterms, finals, mock contests, entrance tests, and other higher-stakes materials.

Assessment flow:

```text
teacher creates Assessment Blueprint
-> API records blueprint, sections, marks, topic coverage, and constraints
-> system searches approved bank and source anchors
-> worker generates candidate drafts where the bank has gaps
-> validators, duplicate checks, source-overlap checks, and coverage checks run
-> teacher reviews every candidate item
-> teacher assembles sections and marks
-> teacher finalizes and locks assessment version
-> worker writes student paper, answer key, solution guide, rubric, and package metadata to Cloud Storage
-> PostgreSQL stores immutable export paths, hashes, version, and audit events
```

Assessment Blueprint should include:

- assessment type
- tenant, school year, class, course, subject, and grade
- time limit and total marks
- section structure
- topic and curriculum coverage targets
- question type mix
- D1-D5 difficulty mix
- allowed tools
- source scope and approved bank scope
- rubric/marking rules
- number of versions
- output requirements

Assessment Builder should produce:

- student exam PDF
- teacher answer key
- full solution guide
- marking rubric
- online assessment package when needed
- version A/B packages when requested
- coverage and validation report

Higher-stakes rules:

- AI can create candidate drafts only
- final assessment versions require teacher approval and lock
- locked versions are immutable; changes create a new version
- assessments cannot finalize with unapproved draft questions
- answer keys, solution guides, and teacher rubrics must stay teacher-only unless explicitly released
- duplicate, near-duplicate, and source-overlap checks should run across the selected exam and recent tenant assessments
- source lineage, rights status, difficulty, marks, and validation status must remain auditable

Recommended statuses:

- `draft`
- `building`
- `needs_review`
- `ready_to_finalize`
- `locked`
- `published`
- `archived`

## 15. Assignment And Student Attempt Flow

Detailed student package delivery design: [Student Practice Package Storage Design](student-practice-packages.md).

Assignment flow:

```text
teacher selects approved questions
-> creates assignment
-> worker publishes immutable student package to Cloud Storage
-> PostgreSQL stores package path, version, hash, and assignment state
-> assigns to class or student
-> student opens portal
-> API checks access and returns signed package URL
-> browser downloads package once
-> submits attempts
-> API records batched answers and final attempt
-> API/worker grades using server-side answer key and rubric rules
-> system creates student and teacher summaries
-> analytics update weak topics
```

Student-facing practice packages should be served from Cloud Storage, not assembled from PostgreSQL on every question navigation.

Student attempts store:

- student
- assignment
- question
- submitted answer
- correctness
- time spent
- hint usage
- attempt number
- auto score
- manual score adjustment
- grading status
- result summary path or JSON
- created_at

## 16. Result Verification, Marks, And Summaries

After a student completes a practice session, quiz, test, or exam, the system should verify answers and produce marks and summaries.

Result flow:

```text
final submit
-> load locked package version and server-side answer key
-> grade deterministic answers immediately
-> run coding tests where applicable
-> apply accepted-answer rules for short answers
-> create rubric/AI-assisted draft score for open responses where enabled
-> flag uncertain or teacher-review-only answers
-> calculate provisional score, marks, and topic breakdown
-> write attempt score and summaries
-> update analytics and observed difficulty asynchronously
```

Grading modes:

- `auto_grade`: deterministic grading can decide correctness and marks
- `auto_grade_with_review`: system calculates a provisional result, but teacher review can adjust
- `ai_assisted_teacher_review`: AI can draft rubric evidence and suggested score; teacher finalizes
- `teacher_review_only`: system stores response and rubric, but does not assign final marks

Supported auto-verification:

- multiple choice and multi-select
- integer, decimal, fraction, expression, and equation answers
- short answer with accepted-answer rules
- coding sample tests and hidden tests
- reading comprehension when answers are exact or rule-based

Open response, proof, essay, writing, and complex reading answers should use rubric-assisted review. The system can draft feedback and provisional marks only when the teacher enables it.

Student summary should include:

- score or provisional score
- marks earned and total marks
- correct, incorrect, partial, and pending-review counts
- topic and D1-D5 difficulty breakdown
- time spent and hint usage
- explanations or solutions only when teacher settings allow release
- recommended next practice

Teacher summary should include:

- question-by-question results
- auto-graded vs teacher-review counts
- common wrong answers
- topic and difficulty weak areas
- item analysis for exams, including low-performing questions
- flags for ambiguous answers or grading errors
- suggested follow-up practice

For normal practice, results may be shown immediately. For exams and credit-course assessments, LessonOps can calculate provisional marks and summaries, but teacher finalization should control official marks, report-card marks, and credit-course records.

## 17. Security And Privacy

Minimum security requirements:

- all secrets server-side only
- no API keys in frontend
- tenant-scoped authorization on every API route
- role-based permissions
- audit events for source uploads, generation, approval, assessment finalization, assignment, and student record changes
- no sensitive student information in logs
- file upload scanning or at least type/size validation
- backups enabled for production database
- HTTPS only in production

Canadian school data should be handled with privacy-by-design discipline. This document is not legal advice, but the system should be built PIPEDA-aware and ready for school privacy questions.

## 18. Environments

Required environments:

- local
- development
- staging
- production

Rules:

- production data must never be copied to local without explicit redaction
- staging may use anonymized demo data
- local development uses seed data
- environment variables are documented
- migrations run through CI/CD

## 19. Observability

Production must have:

- request logs
- error tracking
- API latency metrics
- generation cost tracking
- model call logs with redaction
- queue/job monitoring
- database backup monitoring
- uptime check

Track business metrics:

- questions generated
- questions approved
- questions rejected
- average review time
- worksheet exports
- assignment completion
- student weak topics
- teacher time-saving proxy metrics

## 20. CI/CD

GitHub should trigger:

- type check
- lint
- unit tests
- API contract tests
- database migration check
- build
- Playwright smoke tests for major UI flows

Preview environments should be provided through one of these GCP-aligned paths:

- per-branch Cloud Run services for web/admin, web/front, and API
- Firebase App Hosting previews if we adopt Firebase App Hosting for the web portals
- lightweight local/staging preview when a full per-branch environment is not worth the cost

Production deploy should require:

- passing CI
- reviewed PR
- migration review when schema changes
- smoke test after deploy

## 21. Initial Build Milestones

Milestone 1: Foundation

- repo structure
- TypeScript app shells
- shared UI package
- auth
- tenant model
- database schema

Milestone 2: Source Library And Knowledge Base

- upload source
- metadata
- source table
- source preview
- chunks and anchors
- Knowledge Vault storage
- draft KnowledgeNotes
- links, backlinks, and source anchors
- KB index rebuild from Markdown
- KB review and approval

Milestone 3: AI Generation

- KB-slice generation
- AI context bundle assembly
- structured outputs
- generation batches
- draft storage
- validation runs

Milestone 4: Review Queue

- review UI
- original source preview
- edit and approve
- question bank

Milestone 5: Worksheet, Assignment, And Assessment

- worksheet builder
- online assignment
- assessment blueprint builder
- exam export package
- answer key and rubric package
- student portal API
- basic attempts

Milestone 6: Results And Analytics

- auto-verification and marks
- student result summary
- teacher result summary
- weak-topic tracking
- teacher dashboard
- approval and usage metrics

## 22. References

Internal implementation references reviewed:

- AiUniScan FastAPI app runtime: `services/api/app/main.py`
- AiUniScan shared DB pool: `services/api/app/services/db.py`
- AiUniScan async job dispatch: `services/api/app/services/scan_job_dispatch.py`
- AiUniScan API/worker Cloud Run and Cloud Tasks configuration: `infra/terraform/main.tf` and `infra/terraform/variables.tf`

The following current docs informed the hosting and AI direction:

- Next.js static exports: https://nextjs.org/docs/app/guides/static-exports
- Firebase Hosting: https://firebase.google.com/docs/hosting
- Google Cloud Storage static website hosting: https://cloud.google.com/storage/docs/hosting-static-website
- Google Cloud Run services: https://cloud.google.com/run/docs
- Google Cloud Run pricing: https://cloud.google.com/run/pricing
- Firebase App Hosting: https://firebase.google.com/docs/app-hosting
- Firebase App Hosting Next.js support: https://firebase.google.com/docs/app-hosting/frameworks/nextjs
- Firebase App Hosting costs: https://firebase.google.com/docs/app-hosting/costs
- Firebase pricing: https://firebase.google.com/pricing
- Google Cloud locations: https://cloud.google.com/about/locations
- Google Cloud SQL for PostgreSQL: https://cloud.google.com/sql/docs/postgres
- Google Cloud SQL pricing: https://cloud.google.com/sql/docs/postgres/pricing
- Google Cloud SQL PostgreSQL extensions: https://cloud.google.com/sql/docs/postgres/extensions
- Google Cloud Storage: https://cloud.google.com/storage/docs
- Cloud Tasks: https://cloud.google.com/tasks/docs
- Pub/Sub: https://cloud.google.com/pubsub/docs
- Secret Manager: https://cloud.google.com/secret-manager/docs
- Cloud Logging: https://cloud.google.com/logging/docs
- Cloud Monitoring: https://cloud.google.com/monitoring/docs
- Firebase Authentication: https://firebase.google.com/docs/auth
- Google Cloud Identity Platform: https://cloud.google.com/identity-platform/docs
- Next.js App Router: https://nextjs.org/docs/app
- Next.js deployment options: https://nextjs.org/docs/app/getting-started/deploying
- Tailwind CSS: https://tailwindcss.com/docs
- shadcn/ui: https://ui.shadcn.com/docs
- FastAPI: https://fastapi.tiangolo.com/
- Pydantic: https://docs.pydantic.dev/
- SQLAlchemy: https://docs.sqlalchemy.org/
- Alembic: https://alembic.sqlalchemy.org/
- uv: https://docs.astral.sh/uv/
- TanStack Query: https://tanstack.com/query/latest
- openapi-fetch: https://openapi-ts.dev/openapi-fetch/
- Playwright: https://playwright.dev/
- Vitest: https://vitest.dev/
- Vercel Deployments as an alternative reference: https://vercel.com/docs/deployments/deployment-methods
- Supabase docs as an alternative reference: https://supabase.com/docs/
- OpenAI API deployment checklist: https://developers.openai.com/api/docs/guides/deployment-checklist
- OpenAI data controls and regional endpoints: https://developers.openai.com/api/docs/guides/your-data
- OpenAI Image Generation guide: https://developers.openai.com/api/docs/guides/image-generation
- Obsidian internal links: https://help.obsidian.md/Linking%20notes%20and%20files/Internal%20links
- Obsidian graph view: https://help.obsidian.md/plugins/graph
- Obsidian Bases: https://help.obsidian.md/bases

## 23. Current Design Decision

Build on GCP from the beginning, while keeping the application code portable.

Recommended immediate path:

```text
Static Next.js Admin Portal on Firebase Hosting or Cloud Storage + Cloud CDN
Static Next.js Student Portal on Firebase Hosting or Cloud Storage + Cloud CDN
Cloud Run FastAPI / Python API
Cloud Run worker services/jobs
Cloud SQL for PostgreSQL
Cloud Storage for source files, Markdown Knowledge Vaults, and generated artifacts
Cloud Tasks and Pub/Sub for background work
Secret Manager for API keys and secrets
Cloud Logging and Monitoring
Firebase Auth or Google Cloud Identity Platform
OpenAI API through server-side API service
GitHub CI/CD
```

Recommended future additions:

```text
Firebase App Hosting only if it improves preview/deployment workflow without weakening region or control requirements.
OpenTelemetry tracing when production debugging needs deeper request visibility.
Multi-region disaster recovery when external customer contracts justify it.
```
