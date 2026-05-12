# LessonOps AI Real System Coding Standard

Date: 2026-05-09
Status: Draft v0.1

## 1. Purpose

This document defines how LessonOps AI code should be written, reviewed, tested, and maintained.

Every developer and AI agent should read this document before making production-system changes.

Related documents:

- [UI Design](ui-design.md)
- [System Design](architecture.md)
- [Student Practice Package Storage Design](student-practice-packages.md)
- [Trusted Sources and Categorization](trusted-sources.md)
- [Business Point of View](business-strategy.md)

## 2. Engineering Principles

```text
Make source lineage visible.
Keep teachers in control.
Prefer clear data contracts.
Validate what can be validated.
Protect student and school data.
Ship small, reviewed changes.
```

Do not build clever AI shortcuts that bypass review, source tracking, or tenant isolation.

## 3. Language And Stack Standards

Recommended default stack:

- TypeScript for frontend application code
- React and Next.js for frontends
- Next.js static export for first production frontend deployment
- Python 3.12+ for backend API and worker services
- FastAPI for backend HTTP APIs
- Pydantic v2 for backend validation and API schemas
- PostgreSQL for primary data
- SQLAlchemy 2.x for backend database access
- Alembic for database migrations
- OpenAPI as the contract from backend to frontend
- Playwright for end-to-end UI tests
- Vitest for frontend unit tests
- pytest for backend unit tests
- Ruff for Python linting/formatting
- Pyright or mypy for Python type checking

Rules:

- TypeScript strict mode must be enabled.
- Python type hints are required for public functions, service functions, and database/repository boundaries.
- Avoid TypeScript `any`; if required, isolate it and explain why.
- Avoid Python `Any`; if required, isolate it and explain why.
- Public API input must be runtime-validated.
- API types must be generated or derived from the backend OpenAPI contract, not copied manually across apps.
- Database schema changes must be committed as migrations.

## 4. Repository Standards

Target monorepo structure:

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
```

Rules:

- app-specific code stays inside its app
- reusable UI components go in `packages/ui`
- generated TypeScript API clients go in `packages/api-client`
- backend business/domain modules go in `apps/api/common` or the relevant `apps/api/admin` / `apps/api/front` package
- SQLAlchemy database models and repositories go in `apps/api/common` unless they later need a dedicated package
- Alembic or SQL migration files go in `database/migrations`
- seed data and local bootstrap SQL go in `database/seed`
- deterministic answer validators go in `apps/api/common` or a clearly named backend validation module
- AI prompts, schemas, and model adapters go in `apps/api/common` or a clearly named backend AI module

Module boundaries:

- keep application entrypoints thin; they should bootstrap, configure, and delegate
- split backend API code by endpoint/domain before files become large
- split frontend code into route/view modules plus reusable components
- shared helpers belong in explicit utility, service, repository, or component modules
- avoid single files that mix routing, database access, business logic, rendering, and event handling
- as a practical warning line, review any application file that grows past 300 lines and split it before it becomes a 500+ line maintenance problem

Current production implementation structure should follow the same direction:

```text
apps/api/server.py                    # local entrypoint only
apps/api/common/router.py             # shared route dispatch only
apps/api/common/server.py             # local standard-library API runtime
apps/api/common/db.py                 # database helpers/repositories
apps/api/common/source_import.py      # source-import service logic
apps/api/admin/                       # one admin-facing module per endpoint/domain
apps/api/front/                       # one student/front-facing module per endpoint/domain
apps/web/admin/app/                   # Next.js route shell
apps/web/admin/public/app.js          # current admin UI bootstrap and event wiring during React migration
apps/web/admin/public/components/     # current reusable layout and UI components during React migration
apps/web/admin/public/views/          # current one module per admin screen during React migration
```

Local and production frontend rules:

- local frontend development runs through the Next.js dev server
- local API development runs through a separate Python API server
- production frontend deployment uses `next build` static export first
- deploy generated HTML/CSS/JS to Firebase Hosting or Cloud Storage + Cloud CDN
- deploy the Python API separately as a Cloud Run service
- do not make the Python API serve the production frontend bundle
- do not put backend-only secrets, database credentials, or privileged service credentials in frontend code

## 5. Naming Standards

Use clear domain names.

Examples:

- `Source`
- `SourceAnchor`
- `KnowledgeVault`
- `KnowledgeNote`
- `KnowledgeLink`
- `GenerationProfile`
- `GenerationBatch`
- `DraftQuestion`
- `ApprovedQuestion`
- `ReviewEvent`
- `ValidationRun`
- `Assignment`
- `AssessmentBlueprint`
- `Assessment`
- `AssessmentVersion`
- `StudentAttempt`
- `StudentAttemptAnswer`
- `AttemptScore`
- `ResultSummary`

Avoid vague names:

- `Data`
- `Item`
- `Thing`
- `Obj`
- `Result2`
- `NewFlow`

IDs:

- database IDs should use UUID or cuid-style IDs
- external visible codes can be shorter slugs
- never rely on display names as unique keys

## 6. API Standards

Every API route must define:

- request schema
- response schema
- auth requirement
- tenant scope
- error cases

API responses should be predictable:

```json
{
  "data": {},
  "error": null
}
```

or:

```json
{
  "data": null,
  "error": {
    "code": "SOURCE_NOT_FOUND",
    "message": "Source not found"
  }
}
```

Rules:

- do not return stack traces to clients
- do not expose internal model prompts to students
- do not expose another tenant's IDs or metadata
- pagination is required for large lists
- filtering and sorting should be explicit

Backend API module standards:

- each endpoint/domain should have its own Python module
- route dispatch should not contain SQL, prompt logic, or long business workflows
- database access should go through repository/helper modules, not be scattered through route handlers
- source ingestion, question generation, grading, and assessment building should each have service modules
- endpoint functions should validate input, call domain services, and return response payloads
- local prototype code can be simple, but must keep the same separation so migration to FastAPI stays clean

## 7. Database Standards

Every tenant-owned table must include:

- `tenant_id`
- `created_at`
- `updated_at`

Most user-action tables should include:

- `created_by`
- `updated_by`

Important workflow tables should have immutable audit history.

Rules:

- use migrations, not manual production schema edits
- never run DDL from application runtime code
- never create, alter, drop, or patch database tables/indexes/columns inside request handlers, startup hooks, background jobs, seed scripts, or "auto-fix" code
- database structure changes must be applied separately through reviewed migration files and deployment steps
- app code may check that a required migration exists and fail fast with a clear error, but it must not try to repair schema at runtime
- do not delete important educational records by default; archive instead
- use foreign keys where practical
- index tenant and common filter columns
- store raw uploaded files separately from extracted text
- store source lineage separately from generated content when useful

Runtime DB connection policy:

- runtime API code must use the shared DB pool module, not direct per-request connection creation
- default pool size is 10 connections per app instance unless capacity testing changes it
- supported override environment variables are `DB_POOL_MAX_SIZE`, `API_DB_POOL_MAX_SIZE`, `DB_POOL_WAIT_TIMEOUT_SEC`, and `API_DB_POOL_WAIT_TIMEOUT_SEC`
- when the pool is exhausted, the API should wait briefly for a released connection and then fail clearly
- request code should use context-managed pooled connections so success commits, errors roll back, and connections return to the pool
- direct driver connection calls belong only inside the pool module, bootstrap/migration scripts, or focused tests
- this follows the AiUniScan pattern in `services/api/app/services/db.py`

## 8. Tenant Isolation Standards

Tenant isolation is mandatory.

Rules:

- every tenant-owned query must filter by `tenant_id`
- server-side authorization must check membership and role
- client-side hiding is not security
- background jobs must include tenant context
- source files must use tenant-scoped storage keys
- audit logs must include tenant and actor

Never add a quick endpoint that skips tenant isolation for demo convenience.

## 9. Auth And Registration Standards

Use Google login through Firebase Auth or Google Cloud Identity Platform as the default sign-in path.

Rules:

- Google/Firebase identity is not authorization.
- Every protected route must resolve the authenticated user to a LessonOps membership.
- Teacher/admin access requires an invitation or existing membership.
- Student access requires an invitation, class code, assignment code, or existing membership.
- Public teacher self-registration into an existing school tenant is not allowed.
- Public school-owner signup is a future SaaS onboarding flow and must create a new tenant, not join an existing tenant.
- Invite tokens, class codes, and assignment codes must be scoped, expiring where appropriate, and audit logged.
- Role assignment must happen server-side.
- Never trust a client-provided role, tenant id, or membership id without server-side verification.
- Deactivated users and revoked memberships must lose access immediately.

Recommended first-launch behavior:

```text
Teacher/Admin:
invited by owner/admin -> Google login -> membership activated

Student:
assignment link/code or invite -> optional Google login -> student profile/membership connected
```

## 10. Role And Permission Standards

Use capability checks in backend code. Do not rely only on role names.

Rules:

- Every protected API route must declare the required capability.
- A user's effective permissions come from tenant membership, role, and explicit grants.
- Teacher access is usually scoped to own sources, own drafts, own classes, and assigned students.
- Reviewer/Curriculum Lead access can approve shared question-bank and shared source-library content.
- Admin access can manage users/classes/settings but still needs tenant scope.
- Owner access can manage billing, domains, roles, and tenant-level export/delete operations.
- Source visibility must be enforced server-side.
- Client-side hiding of buttons is not permission enforcement.

Teacher default capabilities:

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
student_results.view_own_classes
```

Teacher optional capabilities:

```text
draft.publish_to_own_classes
question.approve_for_own_classes
source.share_with_class
kb_note.submit_for_review
```

Reviewer/Curriculum Lead capabilities:

```text
source.approve_tenant_shared
kb_note.approve_tenant_shared
question.approve_tenant_shared
question.reject
review.assign
teacher_content.view_for_review
taxonomy.manage_content_tags
```

Required tests:

- teacher can upload a source into own scope
- teacher can generate from own source and tenant-shared sources
- teacher can create draft KnowledgeNotes from own sources
- teacher can review/edit own generated drafts
- teacher can create draft assessments for own classes when enabled
- teacher cannot manage billing/domains/users without admin/owner capability
- teacher cannot approve tenant-shared source rights without reviewer/admin capability
- teacher cannot publish to shared question bank without reviewer/curriculum-lead capability

## 11. Source Library Standards

Every source must track:

- source title
- source owner
- source entry method: upload or URL import
- source type
- subject
- grade
- topic tags
- trust level
- rights category
- source usage status
- original URL if public
- URL fetch status, fetched_at, content type, content length, and checksum when URL-imported
- uploaded file reference if internal
- stored raw source object path
- extracted text status
- chunk/anchor status

URL import standards:

- URL downloads must run in backend workers only, never from browser code.
- Allow only `http` and `https` schemes.
- Block localhost, private IP ranges, link-local addresses, and cloud metadata endpoints to prevent SSRF.
- Enforce redirect limits, download size limits, content-type allowlists, and request timeouts.
- Do not send application cookies, user credentials, or privileged headers to source URLs.
- Do not bypass paywalls, login walls, robots restrictions, or source license terms.
- Store the fetched raw source in Cloud Storage and record checksum, fetch timestamp, URL, and fetch status.
- Treat URL-imported sources as `needs_review` until rights, trust, metadata, and allowed use are confirmed.

Every generated question must track:

- source IDs
- source anchors or chunks used
- generation batch
- model name/version
- prompt version
- transformation note
- rights usage status

Core rule:

```text
No source lineage, no approval.
```

## 12. Knowledge Base Standards

The Knowledge Base is an Obsidian-style Markdown Knowledge Vault.

Rules:

- KB note content lives in versioned Markdown files, not primarily in PostgreSQL
- PostgreSQL can store relational workflow data and rebuildable indexes only
- KB notes must use stable IDs in YAML frontmatter
- KB notes should use internal links for concept relationships
- KB notes must store approval status before they can drive trusted generation
- KB notes must reference source anchors when they make source-backed claims
- graphify and LLM-generated KB notes start as draft suggestions
- teacher/reviewer approval is required before a KnowledgeNote becomes trusted
- if a KB index table is deleted, the system must be able to rebuild it from the Markdown vault
- no embedding/vector index is part of the core KB architecture
- any future semantic index requires separate design review and must be rebuildable from the Markdown vault

Required KB note fields:

- `id`
- `type`
- `status`
- `subject`
- `grade_levels`
- `topic`
- `source_anchors`
- `approved_by`
- `approved_at`

Use Markdown links for human-readable relationships, and structured frontmatter fields for relationships the app needs to query.

## 13. AI Coding Standards

AI calls must go through the AI service layer.

Rules:

- do not call OpenAI directly from UI components
- do not put API keys in frontend code
- use structured output schemas where possible
- require a Generation Profile or explicit equivalent settings for question generation
- store prompt version and model version
- store generation profile ID and version on generation batches
- store KnowledgeNote IDs and source anchor IDs used for generation
- store generated draft before teacher edits
- store generated preview drafts before teacher approval
- keep teacher edits as the authoritative reviewed content
- redact PII from logs
- add cost tracking metadata where possible

Prompt files should be versioned in Git.

AI output statuses:

- `draft`
- `needs_teacher_review`
- `validated`
- `approved`
- `rejected`
- `archived`

AI must never create `approved` content directly.

Generation Profile standards:

- do not use a raw free-text prompt as the only generation control
- every generated question must declare `question_type`, `answer_type`, `grading_mode`, and `validation_method`
- every generated question must declare `difficulty_level`, `difficulty_source`, and `difficulty_factors`
- multiple-choice questions must include choices, correct choice, and distractor notes
- short-answer questions must include expected answer rules or teacher-review notes
- open response, essay, proof, and reading questions must include a rubric or expected key points
- coding questions must include runtime, starter code if used, sample tests, and hidden-test metadata
- regenerate actions must keep the original profile/version and record teacher overrides separately
- teacher-created profiles can be personal, shared to a class/team, or approved as tenant templates
- deleting or changing a shared profile must not rewrite historical generation batches
- profile changes that affect structured output should be versioned

AI Learning Preview standards:

- do not replace Original Source Preview with AI-generated preview content
- AI Learning Preview assets are drafts until teacher-approved
- only approved preview assets can be included in student packages
- exact diagrams, labels, numbers, charts, tables, and code traces should use deterministic renderers when correctness matters
- generated bitmap images should not contain answer-revealing content
- critical text, spelling, numbers, formulas, and code should not rely on image-generation text
- store preview prompt version, model/provider, teacher instruction, asset path, alt text, status, approved_by, and approved_at
- preview regeneration must create a new preview version or review event rather than overwriting approval history
- do not send student PII into preview generation prompts
- provide alt text for every student-visible preview

Difficulty standards:

- use `D1` to `D5` internally, even if UI displays Easy, Medium, and Hard
- store teacher/source/AI estimated difficulty separately from observed student-performance difficulty
- do not silently overwrite teacher-approved difficulty based on student data
- difficulty recalibration jobs must create audit events
- open-response and essay difficulty must consider rubric complexity, not only reading level
- English difficulty must consider passage length, vocabulary, literal/inferential reasoning, evidence requirements, and writing load

Assessment Builder standards:

- AI can generate candidate exam items only; it must never finalize an assessment
- final assessment versions require teacher approval and a lock action
- locked assessment versions are immutable; edits create a new version
- assessment finalization must block unapproved draft questions
- answer keys, full solutions, and teacher rubrics are teacher-only by default
- online student assessment packages must not include answer keys before release
- every assessment item must keep question version, marks, source lineage, difficulty, validation status, and review status
- duplicate, near-duplicate, and source-overlap checks must run before finalization
- coverage reports must show topic mix, D1-D5 difficulty mix, question type mix, marks, and source coverage
- Version A/B generation must preserve equivalent topic, difficulty, mark, and question type coverage
- exam exports must be tenant-scoped and audit logged
- high-stakes assessment workflows should favor explicit teacher actions over auto-publish behavior

Result and grading standards:

- grade only against server-side answer keys, rubrics, and locked package versions
- browser-side grading can be used for immediate feedback, but server-side grading is authoritative
- store per-answer grading status, score, max score, method, and grader source
- use deterministic grading whenever possible
- AI-assisted grading can draft rubric evidence and suggested marks, but teacher review must be available
- open response, proof, essay, and complex reading answers should support partial marks and teacher adjustment
- exam marks should remain provisional until released or finalized by the teacher when the school requires it
- manual score adjustments must store old score, new score, reason, adjusted_by, and adjusted_at
- result summaries must distinguish `auto_graded`, `pending_review`, `teacher_adjusted`, and `finalized`
- do not reveal hidden tests, answer-key internals, or teacher-only rubric notes to students
- result release settings must control when students see marks, solutions, and explanations

## 14. Validation Standards

Use deterministic validators when possible.

Validator outputs should include:

- status
- method
- details
- warnings
- checked_at

Statuses:

- `passed`
- `failed`
- `not_applicable`
- `needs_teacher_review`

Validation does not equal approval.

## 15. Frontend Standards

Follow [UI Design](ui-design.md).

Rules:

- teacher/admin UI is desktop-first and compact
- student UI is mobile-friendly and focused
- use shared components for repeated patterns
- no nested cards for page layout
- no marketing hero layout inside the app
- all critical actions need loading and error states
- destructive actions need confirmation or undo
- source lineage must stay visible in review workflows
- long tables must support search/filter/sort

Frontend module standards:

- the main app file should only bootstrap data, choose the current view, wire events, and call API/client modules
- screen rendering belongs in separate view modules, one module per major screen
- reusable layout pieces such as sidebar, header/topbar, footer, workspace shell, panels, badges, metrics, tables, and form controls belong in component modules
- repeated display logic such as status badges, rights badges, metrics, and property rows must not be copied across screens
- API calls belong in an API client module, not directly inside view-rendering modules
- new UI work should add or reuse components first, then compose screens from those components
- if a view starts carrying multiple workflows, split smaller workflow components before adding more behavior

Accessibility:

- form inputs need labels
- icon buttons need accessible labels
- keyboard navigation must work for modals and forms
- color cannot be the only way to show status

Responsive quality gate:

- check 390px width
- check 768px width
- check 1280px width
- check 1440px width
- no text overlap
- no clipped primary actions

## 16. Testing Standards

Minimum tests:

- unit tests for validators
- unit tests for source classification
- unit tests for AI output parsing
- API tests for tenant isolation
- API tests for role permissions
- API tests that KB indexes rebuild from Markdown vault files
- API tests for invitation acceptance
- API tests that public teacher self-registration into an existing tenant is blocked
- API tests for student class/assignment code access
- API tests that assessment finalization blocks unapproved questions and missing answer keys
- API tests for final submit grading, marks, summary creation, and pending-review status
- API tests that student-visible summaries do not include answer-key internals
- UI smoke tests for Source Library, Knowledge Base, Generate, Review Queue, Question Bank, and Assessment Builder
- Playwright test for approving a generated question

Before merge:

- type check passes
- lint passes
- Python formatting/linting passes
- tests pass
- build passes
- changed core workflow has at least one relevant test

## 17. Security Standards

Rules:

- never commit secrets
- never log API keys
- never put student PII in AI prompts unless explicitly required and approved
- minimize student PII in the database
- use server-side permission checks
- validate file upload type and size
- scan or quarantine suspicious uploads when file processing is added
- production must use HTTPS
- production database backups must be enabled

Secrets:

- use environment variables locally
- use platform secret manager in production
- document required environment variables

## 18. Git And Review Standards

Branch naming:

```text
feature/source-library
feature/review-queue
fix/tenant-scope
docs/design-references
```

Commit style:

```text
Add English source ingestion pilot
Fix review queue source preview
Document real system UI design
```

Pull request checklist:

- what changed
- why it changed
- screenshots for UI changes
- tests run
- migration impact
- source/rights impact if content-related
- tenant/security impact if backend-related

Main branch should be protected once the real system starts.

## 19. Documentation Standards

Update docs when changing:

- navigation
- source model
- generation workflow
- approval workflow
- hosting or infrastructure
- API contract
- coding standard

Do not let docs become a museum. They should be working memory.

## 20. AI Agent Workflow

For now, repo documents are the best way to work with an AI coding agent.

At the start of a major task, the AI agent should read:

```text
~/.agents/system-design/ui-design.md
~/.agents/system-design/architecture.md
~/.agents/system-design/coding-standards.md
~/.agents/system-design/student-practice-packages.md
~/.agents/system-design/trusted-sources.md
```

Then it should inspect the code and implement within those rules.

### Docs vs Skills

Use documents for project truth:

- product decisions
- system architecture
- coding standards
- business rules
- source and rights rules

Use Skills later for repeatable AI workflows:

- "ingest a new source library"
- "generate source-aligned questions"
- "review code against LessonOps standards"
- "prepare a release checklist"
- "create a new portal screen using LessonOps UI patterns"

Recommended path:

1. Start with these repo documents.
2. Use them for several real development tasks.
3. When a workflow repeats three or more times, convert that workflow into a Skill.

This keeps the AI agent grounded in the repo first, while Skills become useful automation instead of another place where truth can drift.

## 21. Current Decision

The first real build should follow this standard:

- TypeScript
- shared source-lineage model
- teacher approval before student visibility
- tenant isolation from day one
- docs as project memory
- Skills later for repeated workflows
