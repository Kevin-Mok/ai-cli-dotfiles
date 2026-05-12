# LessonOps Student Practice Package Storage Design

Date: 2026-05-09
Status: Draft v0.1

## 1. Purpose

This document defines how LessonOps should deliver practice questions to the Student Portal quickly while keeping Cloud SQL PostgreSQL small and affordable.

The key decision:

```text
PostgreSQL stores metadata, workflow state, access state, and results.
Cloud Storage stores published student practice package content.
```

The Student Portal should not read every practice question from the database while a student is moving through an assignment.

## 2. Core Principle

```text
Publish once.
Read many times.
Do not put the database in the per-question hot path.
```

The database remains the system of record for business state. Cloud Storage becomes the delivery layer for immutable published practice content.

## 3. What Goes Where

### PostgreSQL

PostgreSQL should store structured state and indexes:

- tenant
- class
- student
- teacher
- source metadata
- question metadata
- topic tags
- approval status
- assignment metadata
- assessment metadata and locked version state
- package path, version, and hash
- access rules
- student attempt summary
- student answer events or batched responses
- audit history

Example metadata fields:

```text
assignment_id
tenant_id
package_version
student_package_path
student_package_hash
answer_key_path
published_at
published_by
status
```

### Cloud Storage

Cloud Storage should store published content files:

- student practice package JSON
- online assessment package JSON
- approved question content blobs if we choose content-in-object-storage
- diagrams and question media
- approved AI Learning Preview assets
- teacher answer keys
- locked exam PDFs, answer keys, solution guides, and marking rubrics
- printable worksheets and PDFs
- uploaded source PDFs and extracted source artifacts

Example paths:

```text
gs://lessonops-packages/{tenant_id}/assignments/{assignment_id}/v{version}/student-package.json
gs://lessonops-packages/{tenant_id}/assignments/{assignment_id}/v{version}/answer-key.json
gs://lessonops-packages/{tenant_id}/assessments/{assessment_id}/v{version}/student-exam.json
gs://lessonops-packages/{tenant_id}/assessments/{assessment_id}/v{version}/student-exam.pdf
gs://lessonops-packages/{tenant_id}/assessments/{assessment_id}/v{version}/teacher-answer-key.pdf
gs://lessonops-packages/{tenant_id}/assessments/{assessment_id}/v{version}/solution-guide.pdf
gs://lessonops-content/{tenant_id}/questions/{question_id}/v{version}/question.json
gs://lessonops-media/{tenant_id}/questions/{question_id}/v{version}/{asset_hash}.png
gs://lessonops-media/{tenant_id}/questions/{question_id}/v{version}/previews/{preview_id}.png
```

The student package path should be immutable. If the teacher changes an assignment, publish a new version instead of overwriting the existing object.

## 4. Student Package Content

A student package should include only what the student needs to complete the assignment.

Include:

- package schema version
- assignment id
- package id
- package version
- published timestamp
- question order
- approved question text
- choices or input requirements
- question type
- answer type
- grading mode
- student-visible rubric when the teacher allows it
- approved AI Learning Preview references
- preview alt text
- difficulty level and basic difficulty label
- allowed tools or settings
- media references
- point values
- student-visible topic/skill labels derived from approved KnowledgeNotes

Do not include:

- correct answers before submission
- full solutions unless the teacher setting allows immediate solution display
- teacher-only rubric notes
- unapproved preview assets
- preview generation prompts
- internal source-rights notes
- generation prompts
- teacher private notes
- unpublished drafts
- student PII
- other tenant data

## 5. Assessment Package Content

An assessment package should be immutable after the teacher locks the assessment version.

Student-visible assessment package should include:

- assessment id
- assessment version id
- package version
- assessment title
- time limit
- section order
- question order
- approved question text
- choices or input requirements
- marks
- allowed tools
- student-visible rubrics when the teacher allows it
- approved media and preview references
- basic topic/skill labels only when useful for the student experience

Teacher-only assessment artifacts should be stored separately:

- answer key
- full solution guide
- marking rubric
- coverage report
- validation report
- source-lineage report

Do not include answer keys, full solutions, teacher-only rubrics, hidden validation details, or teacher notes in the student assessment package.

## 6. Request Flow

### Publish Flow

```text
Teacher selects approved questions
-> Teacher creates or updates assignment
-> API records assignment metadata in PostgreSQL
-> Worker builds immutable student-package.json
-> Worker writes package and media references to Cloud Storage
-> Worker writes answer-key.json separately
-> API updates assignment package path, version, hash, and status in PostgreSQL
```

The published package is the student-visible artifact. PostgreSQL points to it.

### Assessment Publish / Lock Flow

```text
Teacher finalizes assessment version
-> API verifies every selected question is approved
-> API verifies coverage, duplicate, validation, answer-key, and rubric checks
-> API locks assessment version in PostgreSQL
-> Worker builds immutable student-exam package and PDFs
-> Worker writes teacher answer key, solution guide, rubric, and coverage report separately
-> API stores paths, hashes, lock state, and audit events in PostgreSQL
```

Locked assessment artifacts should never be overwritten. If the teacher changes the exam, create a new assessment version.

### Student Start Flow

```text
Student opens assignment
-> API checks login/link, tenant, assignment access, due date, and package status
-> API creates or resumes attempt/session
-> API returns package version, hash, and signed package URL
-> Browser downloads package once
-> Browser caches package for the session
```

The student should not need a database read for every question navigation.

### Student Answer Flow

```text
Student answers questions locally
-> Browser autosaves batched answers every 10-20 seconds or on page change
-> API writes answer batch to PostgreSQL
-> Final submit writes final attempt transaction
-> Worker/API grades using server-side answer key and rubric rules
-> System creates marks and result summaries
-> API returns released result or pending-review state
-> Analytics updates run asynchronously
```

The database is used for access, progress, results, and audit, not question delivery.

### Result Summary Flow

```text
Final submit
-> deterministic answers are graded immediately
-> open/rubric answers are marked pending teacher review or provisional AI-assisted review
-> attempt score is calculated
-> student summary is created
-> teacher summary is created
-> weak-topic and observed-difficulty updates run asynchronously
```

Student-visible summary can include:

- score or provisional score
- marks earned and total marks
- correct, incorrect, partial, and pending-review counts
- topic and difficulty breakdown
- time spent and hint usage
- recommended next practice
- released solutions only when the teacher setting allows it

Teacher-only summary can include:

- answer key comparison
- per-question marks
- grading method and confidence/evidence
- pending-review items
- manual adjustment history
- common wrong answers
- class-level item analysis

## 7. Caching Rules

Use versioned immutable package paths.

Recommended browser/cache behavior:

- student package is downloaded once per assignment version
- unchanged package can be reused by browser cache
- new assignment version creates a new URL/path/hash
- old attempts remain pinned to the package version the student started

Cloud Storage object metadata should set clear `Cache-Control` values. For private packages, access should go through signed URLs or signed cookies, with the bucket itself not publicly readable.

Cloud CDN can be added later if traffic grows or if many students download the same package at the same time.

## 8. API Memory Cache

API memory cache is allowed but must not be required for correctness.

Good uses:

- short-lived package metadata cache
- answer-key cache for grading hot assignments
- tenant settings cache

Bad uses:

- only copy of package content
- only copy of student progress
- cache that assumes all Cloud Run instances share memory

Cloud Run instances can scale up and down. Instance memory is local to one instance and can disappear. The durable package lives in Cloud Storage; durable state lives in PostgreSQL.

## 9. Small Cloud SQL Strategy

To keep a small Cloud SQL PostgreSQL instance healthy:

- one database read when a student starts or resumes an assignment
- no database read for next/previous question navigation
- autosave answers in batches
- final submit uses one transaction
- analytics and weak-topic updates run async
- API uses SQLAlchemy connection pooling
- Cloud Run max instances should be capped to protect DB connection limits
- heavy package generation runs in workers, not request handlers

This design lets the Student Portal feel fast even when PostgreSQL is intentionally small.

## 10. Security Rules

- Cloud Storage buckets are private by default.
- Student package access is authorized by the API.
- Signed URLs or signed cookies should expire.
- Student package must not include answer keys unless the package is specifically a post-submit solution package.
- Answer keys and grading details are server-side only before submit.
- Package files must be tenant-scoped.
- Package hash should be checked or stored so tampering/version mismatch can be detected.
- Audit events should record publish, assignment access, submit, and package version.

## 11. Implementation Notes

Recommended tables:

```text
assignments
assignment_packages
student_attempts
student_attempt_answers
student_attempt_scores
student_attempt_summaries
student_attempt_events
assessment_packages
```

`assignment_packages` should track:

```text
id
tenant_id
assignment_id
version
student_package_path
student_package_hash
answer_key_path
answer_key_hash
status
published_by
published_at
created_at
```

`assessment_packages` should track:

```text
id
tenant_id
assessment_id
assessment_version_id
version
student_exam_package_path
student_exam_package_hash
student_exam_pdf_path
student_exam_pdf_hash
teacher_answer_key_path
teacher_answer_key_hash
solution_guide_path
solution_guide_hash
rubric_path
rubric_hash
status
locked_by
locked_at
published_by
published_at
created_at
```

`student_attempt_scores` should track:

```text
id
tenant_id
attempt_id
package_version
score
max_score
percentage
grading_status
auto_graded_count
pending_review_count
teacher_adjusted_count
finalized_by
finalized_at
created_at
updated_at
```

`student_attempt_summaries` should track:

```text
id
tenant_id
attempt_id
student_summary_json
teacher_summary_json
released_to_student
released_at
created_at
updated_at
```

No runtime DDL is allowed. These tables must be created through reviewed Alembic migrations.

## 12. Current Decision

Use PostgreSQL plus Cloud Storage together:

```text
PostgreSQL:
metadata, workflow state, access control, attempts, results, audit

Cloud Storage:
student practice package JSON, media, answer-key artifacts, PDFs, source files
```

Do not store the rendered student practice package as the primary delivery content in PostgreSQL.

Assessment packages follow the same storage principle. PostgreSQL stores metadata, lock state, access, hashes, and audit events. Cloud Storage stores locked student exam packages, answer keys, solution guides, rubrics, and PDFs.

## 13. External References

- Cloud Storage object metadata and `Cache-Control`: https://cloud.google.com/storage/docs/metadata
- Cloud CDN signed URLs: https://cloud.google.com/cdn/docs/using-signed-urls
- Cloud CDN signed cookies: https://cloud.google.com/cdn/docs/using-signed-cookies
- Cloud SQL from Cloud Run: https://cloud.google.com/sql/docs/postgres/connect-run
- Cloud SQL connection pooling: https://cloud.google.com/sql/docs/postgres/manage-connections
- Cloud Run container runtime and memory behavior: https://docs.cloud.google.com/run/docs/container-contract
