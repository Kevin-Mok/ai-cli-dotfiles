# LessonOps AI Real System UI Design

Date: 2026-05-09
Status: Draft v0.1
Primary focus: Teacher/Admin Portal

## 1. Purpose

This document defines the product UI direction for the real LessonOps AI system.

The MVP proved the idea:

- teachers need to see original source beside generated questions
- source grouping by year, contest, passage, grade, and topic matters
- review and approval must stay central
- AI should save prep time, not replace teacher judgment

The real system should split into two separate user experiences:

- Teacher/Admin Portal: internal school operations, source library, Knowledge Base, generation, review, worksheets, assignments, analytics
- Student Portal: student practice and assignment completion

The Teacher/Admin Portal is the first build focus. The Student Portal will be handled separately by Kevin, but it must follow the same API contracts, design tokens, approval rules, and source-lineage model.

## 2. Product UI Principle

```text
Source first.
AI drafts second.
Teacher approves before students see it.
```

The UI should make this workflow obvious without explaining it too much on screen.

Every generated teaching item must show:

- source lineage
- generation status
- validation status
- review status
- ownership and rights status

The teacher should never wonder: "Where did this come from?" or "Is this ready for students?"

## 3. Portal Split

### 3.1 Teacher/Admin Portal

Owner: LessonOps main development stream.

Primary users:

- school owner
- academic admin
- teacher
- content reviewer
- operations staff

Core jobs:

- manage source library
- manage Knowledge Base notes and links
- generate draft questions and worksheets
- review source-aligned generated drafts
- approve content
- build assignments and worksheets
- monitor student weak areas
- draft parent updates
- manage school settings and users

Design character:

- quiet
- professional
- compact
- table-friendly
- built for repeated daily use

This is an operations tool, not a marketing page.

### 3.2 Student Portal

Owner: Kevin, with shared platform contracts.

Primary users:

- student
- possibly parent later

Core jobs:

- open assigned practice
- answer questions
- receive hints and solutions
- see progress
- retry weak topics

Design character:

- focused
- mobile-friendly
- low-distraction
- clear feedback
- one learning task at a time

The student portal should never expose draft or unapproved content.

## 4. Entry Page And Portal Routing

Use one entry point for each school deployment.

For Triway's first launch:

```text
triwayeducation.com
www.triwayeducation.com
```

should remain the existing public marketing website.

Only the new app subdomain should point to LessonOps on GCP:

```text
app.triwayeducation.com
```

The entry page at `app.triwayeducation.com` should route users by role:

```text
Teacher / Admin -> /admin
Student         -> /practice
```

Direct assignment links can bypass the landing choice:

```text
app.triwayeducation.com/practice/a/{assignment_code}
```

Design rules for the entry page:

- keep it simple and fast
- show the school brand clearly
- support Google login
- do not look like a marketing landing page
- support teacher/admin sign-in
- support student sign-in or assignment-code entry
- redirect signed-in users automatically based on role
- never expose draft/admin routes to student accounts
- do not allow public teacher self-registration into an existing school tenant

Future school deployments should use the same product pattern:

```text
app.lessonops.ai               Shared LessonOps platform entry
schoolname.lessonops.ai        Optional tenant subdomain
app.schooldomain.com           Optional customer-owned domain
```

The UI should read tenant branding from the backend so the same app can support Triway, Maxfield, and future schools without code forks.

## 5. Teacher/Admin Information Architecture

Phase 1 navigation:

```text
Dashboard
Source Library
Knowledge Base
Generate
Review Queue
Question Bank
Worksheets
Assignments
Assessments
Students
Analytics
Settings
```

Phase 1 can ship with some modules thin, but the navigation should already reflect the real product shape.

Recommended first release depth:

- Dashboard: light summary
- Source Library: strong
- Knowledge Base: strong
- Generate: strong
- Review Queue: strong
- Question Bank: medium
- Worksheets: medium
- Assignments: light
- Assessments: medium
- Students: light
- Analytics: light
- Settings: tenant, users, subjects, tags

## 6. Global Layout

### 6.1 Responsive Design Requirement

The LessonOps web app must be responsive across common desktop, tablet, and mobile screen sizes.

Responsive does not mean every workflow must be equally comfortable on every device. The Teacher/Admin Portal is desktop-first because teachers will often review sources, edit questions, compare evidence, and build worksheets on larger screens. However, the UI must still adapt cleanly for tablets and phones so admins can quickly review, approve, reject, check assignment status, or look up student progress.

The Student Portal is mobile-first because students may complete practice from phones, tablets, Chromebooks, laptops, or desktops.

Required supported viewport groups:

- mobile: 390px and up
- tablet: 768px and up
- laptop: 1280px and up
- desktop/wide: 1440px and up

Responsive rules:

- no overlapping text or controls
- no clipped primary actions
- tables collapse into cards or horizontal scroll only when appropriate
- split panes become tabs, drawers, or stacked sections on small screens
- source preview remains accessible on mobile, even if moved into a drawer
- student practice must be comfortable on mobile
- admin-heavy workflows may be optimized for desktop but must not break on mobile

### 6.2 Desktop Layout

Teacher/Admin Portal is desktop-first.

Default layout:

```text
Left sidebar navigation
Top workspace bar
Main content region
Optional right inspector / preview drawer
```

The left sidebar should be stable. Teachers should not need to relearn navigation by page.

The top workspace bar should hold:

- current school or tenant
- page title
- search
- main action button
- user menu

The main content region should prefer:

- tables
- split panes
- tabs
- filters
- drawers
- modals for short tasks only

Avoid stacked marketing-style cards for operational workflows.

### 6.3 Mobile Layout

Admin mobile is secondary but should remain usable for quick review.

Mobile should support:

- approve/reject quick actions
- view source preview
- student lookup
- assignment status check

Heavy workflows like source ingestion and worksheet building can be optimized for desktop first.

## 7. Design Tokens

### 7.1 Color Roles

Use a restrained professional palette with clear semantic roles.

Recommended roles:

- Primary action: blue
- Approved / ready: green
- Draft / review: amber
- Error / rejected: red
- Source / lineage: teal
- Neutral UI: white, light gray, slate text
- Sidebar: dark ink or neutral charcoal

Avoid a one-color blue-only product. The status system needs semantic color.

### 7.2 Typography

Use a modern system sans-serif stack or Inter.

Guidelines:

- page title: 24-30px
- section title: 18-22px
- table text: 13-15px
- form labels: 11-12px, uppercase only when useful
- body copy: 14-16px

Do not scale font size based on viewport width. Text must not overlap containers.

### 7.3 Density

Teacher screens should be scan-friendly and moderately dense.

Use:

- compact table rows
- sticky filters when helpful
- badges for status
- side-by-side source and generated content
- drawers for detail inspection

Avoid:

- giant hero blocks
- oversized cards
- decorative gradients
- nested cards
- hidden critical metadata

## 8. Core Screens

### 8.1 Dashboard

Purpose: daily operating view.

Primary sections:

- pending review count
- failed validation count
- Knowledge Base notes needing review
- source coverage gaps
- orphan concepts with no source anchors
- recently generated drafts
- recently approved content
- student weak-topic highlights
- upcoming assignments
- quick actions

Recommended quick actions:

- Upload Source
- Add Source URL
- Open Knowledge Base
- Build Knowledge Notes
- Generate Questions
- Review Drafts
- Create Worksheet

Dashboard should be useful, but not block the build. The real value starts in Knowledge Base, Generate, and Review Queue.

### 8.2 Source Library

Purpose: trusted source management.

Default view: grouped table.

Primary entry actions:

- Upload File
- Add Source URL

The add-source flow should support both teacher-owned internal material and public/reference web sources.

Add Source URL form should include:

- URL
- title override
- subject
- grade/course
- topic tags
- source collection
- trust estimate
- rights category
- intended use
- visibility: private, class-shared, or tenant-shared request

After submit, the UI should show a `processing` source record immediately while the worker downloads, stores, extracts, and analyzes the source.

Primary grouping options:

- subject
- source collection
- year
- grade
- topic
- rights status
- owner

Required filters:

- search
- subject
- grade
- source type
- rights status
- trust level
- upload owner
- last used

Table columns:

```text
Source Set | Subject | Grade | Collection | Rights | Trust | Anchors | Generated | Last Used | Actions
```

Source detail view should show:

- source title
- source entry method: uploaded file or URL import
- original URL and fetched timestamp when imported from URL
- original file preview
- stored source file reference
- extracted text
- source metadata
- tags
- rights and usage status
- anchors or chunks
- linked KnowledgeNotes
- generated questions from this source
- audit history

Source status values:

- uploaded
- processing
- ready
- needs_review
- archived
- blocked

Rights status values:

- school_owned
- public_domain
- open_license
- official_reference_only
- free_educator_use_restricted
- permission_required
- blocked

### 8.3 Knowledge Base

Purpose: organize source materials into an Obsidian-style teaching Knowledge Vault.

Default view: note table plus graph/sidebar.

Knowledge Base is the center of the Teacher/Admin Portal. It should feel like teacher-readable notes and curriculum structure, not a database admin screen.

Recommended layout:

```text
Left: subject / grade / topic tree
Middle: selected KnowledgeNote editor or reader
Right: graph, backlinks, source anchors, and generation readiness
```

Primary views:

- concept notes by subject/grade/topic
- graph view of linked concepts
- backlinks and related notes
- prerequisite map
- common mistakes by topic
- source coverage by concept
- notes needing review
- orphan notes with no source anchors

Knowledge note should show:

- Markdown content
- properties/frontmatter
- internal links
- backlinks
- source anchors
- approval status
- generation guidance
- common mistakes
- related approved questions and assessments

Actions:

- build draft notes from selected sources
- create note
- edit note
- approve note
- link notes
- attach source anchor
- import graphify suggestions
- assemble AI context bundle preview
- generate from this KB slice

Important UI rules:

- KB note content is stored in the Markdown Knowledge Vault
- database-backed views are indexes over the vault, not the content source of truth
- generation starts from approved KB slices and source anchors, not from hidden vector search
- teacher/reviewer approval is required before a KB note can drive trusted generation
- graphify and LLM suggestions should appear as draft suggestions, not approved knowledge

### 8.4 Generate

Purpose: create controlled drafts from approved Knowledge Base slices and trusted source anchors.

Recommended layout:

```text
Left: generation settings
Middle: selected KB notes, linked sources, and anchors
Right: preview / generation summary
```

Inputs:

- generation profile
- subject
- grade
- course/program
- topic
- difficulty
- difficulty level D1-D5
- question type mix
- count
- source set
- knowledge base slice
- output type
- student level
- grading mode
- answer format
- source alignment mode
- rubric template
- teacher instruction

Output types:

- multiple-choice questions
- multi-select questions
- short answer questions
- open response questions
- proof / justification questions
- worksheet
- quiz
- explanation set
- reading comprehension set
- coding exercise
- parent feedback draft

Generation Profile controls:

- select saved profile
- create profile from current settings
- choose question type mix, such as 4 multiple choice, 4 short answer, 2 open response
- set difficulty mix
- set difficulty level using D1 scaffolded, D2 basic, D3 standard, D4 challenging, D5 extension
- set source alignment: close variation, same skill/new numbers, same skill/new story, easier scaffold, harder challenge, exam-style rewrite
- choose answer format: A/B/C/D, numeric, fraction, paragraph, code, rubric-scored
- choose grading mode: auto-grade, AI-assisted teacher review, teacher review only
- attach or create a rubric for open response, proof, essay, reading, and writing questions
- add one optional teacher instruction

The UI should make structured choices visible before the free-text instruction. Free-text instructions are helpful, but they should not be the only way to control generation.

Generation must create drafts, not approved content.

### 8.5 Review Queue

Purpose: fastest possible teacher review.

Recommended layout:

```text
Left pane: grouped draft queue
Center pane: generated draft editor
Right pane: original source preview and validation evidence
```

For narrower screens, the right pane can become a drawer.

Queue grouping:

- source collection
- source set
- year
- grade
- topic
- generated batch
- validation status

Review item must show:

- generated question
- answer
- choices
- solution
- hints
- original source preview
- AI Learning Preview draft or approved preview status
- source links
- validation result
- difficulty level and difficulty factors
- transformation note
- usage rights badge

Actions:

- Save Edits
- Approve
- Reject
- Regenerate Similar
- Generate Preview
- Regenerate Preview
- Approve Preview
- Reject Preview
- Mark Needs Expert Review
- Add to Worksheet

Important UI rule:

The original source preview should be visible in the review workflow, not hidden behind a link.

Preview model:

- Original Source Preview is teacher-facing evidence from the trusted source. It proves alignment and supports review.
- AI Learning Preview is student-facing support that helps a student understand the question context. It may be a diagram, story scene, character map, vocabulary scene, sequence storyboard, code trace, or concept visual.
- These previews should be visually separated so teachers do not confuse source evidence with generated learning support.
- AI Learning Preview must remain in draft status until the teacher approves it.
- Math diagrams, graphs, tables, number lines, and code traces should use deterministic SVG/canvas renderers when accuracy matters.
- AI-generated image previews are best for English stories, vocabulary, scene context, mood/tone, and non-critical visual scaffolding.
- Preview regeneration should allow a short teacher instruction, such as "make it simpler", "show the story setting", or "do not show the answer".

### 8.6 Question Bank

Purpose: approved reusable content.

Only approved content appears by default.

Filters:

- subject
- grade
- topic
- source collection
- difficulty
- format
- last used
- performance

Question card or row should show:

- title
- subject and grade
- topic
- difficulty
- source label
- approval badge
- usage count
- performance summary

Actions:

- preview
- edit metadata
- duplicate as draft
- add to worksheet
- assign
- archive

### 8.7 Worksheet Builder

Purpose: turn approved content into printable and online practice.

Flow:

```text
Choose class or student group
Choose topic/source filters
Select approved questions
Order questions
Preview student version
Preview answer key
Export PDF or assign online
```

Required outputs:

- student worksheet PDF
- teacher answer key PDF
- online assignment link

### 8.8 Assessment / Exam Builder

Purpose: help teachers prepare quizzes, tests, midterms, finals, mock contests, and entrance assessments with stronger review controls than normal practice.

Recommended layout:

```text
Left: Assessment Blueprint and section outline
Center: candidate question pool and selected exam items
Right: coverage, difficulty, marks, source lineage, and validation checks
```

Assessment Builder flow:

```text
Choose assessment type
Define time, marks, sections, topics, difficulty mix, and question type mix
Select source set and approved bank scope
Generate or suggest candidate pool
Review/edit candidate questions
Run validation, duplicate, and coverage checks
Assemble final assessment
Preview student paper and teacher materials
Finalize and lock version
Export or publish
```

Blueprint controls:

- assessment type: quiz, unit test, midterm, final, mock contest, entrance test
- subject, course, grade, and class
- total time and total marks
- section structure, such as Part A/B/C or multiple choice / short answer / long answer
- topic coverage and curriculum expectations
- D1-D5 difficulty mix
- question type mix
- marks per section and per question
- allowed tools, such as calculator, formula sheet, dictionary, or IDE
- source set and approved question-bank scope
- rubric or marking style
- number of versions, such as Version A and Version B

Required outputs:

- student exam PDF
- teacher answer key
- solution guide
- marking rubric
- online assessment package when needed
- coverage report
- version A/B package when requested

Assessment statuses:

- draft
- building
- needs_review
- ready_to_finalize
- locked
- published
- archived

Important UI rules:

- exams cannot be finalized with unapproved draft questions
- the final locked version should be visibly different from an editable draft
- answer keys and rubrics must be teacher-only by default
- coverage gaps, duplicate/similar questions, missing solutions, and validation failures should be shown before finalization
- source lineage and rights status must remain visible for every selected question

### 8.9 Assignments

Purpose: manage practice links.

Assignment list columns:

```text
Assignment | Class/Students | Due Date | Questions | Completion | Avg Score | Status
```

Assignment statuses:

- draft
- scheduled
- open
- closed
- archived

### 8.10 Students

Purpose: basic student management and weak-area tracking.

Student profile should show:

- contact info
- enrolled classes
- assignments
- attempts
- scores and provisional scores
- result summaries
- topic strengths
- weak topics
- teacher notes

Student PII should be minimal and role-protected.

### 8.11 Analytics

Purpose: guide teaching decisions.

Phase 1 analytics:

- weak topics by student
- weak topics by class
- question performance
- practice/exam score distribution
- questions needing teacher grading
- item analysis for assessments
- assignment completion
- generated content approval rate
- teacher prep activity

Avoid vanity analytics early. Show only metrics that change teacher action.

### 8.12 Settings

Settings groups:

- school profile
- users and roles
- subjects
- grades
- courses/classes
- source tags
- generation templates
- approval rules
- billing later

## 9. Student Portal Contract

Detailed package delivery design: [Student Practice Package Storage Design](student-practice-packages.md).

Kevin's student portal should consume only approved assignments and approved questions.

For speed, the practice player should load an approved assignment package from Cloud Storage once, then navigate between questions locally. The API should handle access checks, signed package URLs, batched answer saves, final submit, grading, and progress state.

Student-facing pages:

- Google login or assignment link/code
- assignment list
- practice player
- result and solution
- exam/practice result summary
- progress summary

Student onboarding rules:

- a student can use an assignment link or code before full account setup if the assignment allows it
- Google login should be available for saving progress across devices
- joining a school/class requires an invite, class code, or assignment code
- students cannot browse other school content after login

Practice player must support:

- one question at a time
- answer submission
- hint
- show solution after attempt or teacher setting
- progress indicator
- mobile layout

Result summary must support:

- score or provisional score
- marks earned and total marks
- correct, incorrect, partial, and pending-review counts
- topic breakdown
- D1-D5 difficulty breakdown
- time spent and hint usage
- recommended next practice
- teacher-review pending message when open responses or exam marks are not finalized

Teacher-facing result view must support:

- question-by-question answers and marks
- auto-graded vs pending-review items
- common wrong answers
- topic and difficulty weak areas
- item analysis for assessments
- manual score adjustment with audit history
- release results / release solutions controls

Student portal must not show:

- source-rights internals
- draft content
- teacher notes
- generation prompt
- raw AI output

## 10. Roles And Permissions

Initial roles:

- Owner: all school settings, billing, domains, users, roles, and data export
- Admin: school operations, users/classes, source library and Knowledge Base administration, and content workflow management
- Curriculum Lead / Reviewer: shared source review, Knowledge Base approval, question-bank approval, quality control, and teacher support
- Teacher: upload sources, draft KnowledgeNotes, generate drafts, review/edit drafts, create worksheets, assign practice, and view own class results
- Assistant Teacher / Content Contributor: upload/tag sources and prepare drafts, but cannot publish without review
- Student: assigned practice only

Teacher default permissions:

- upload source materials
- tag and organize sources they upload
- draft KnowledgeNotes from their own sources
- generate drafts from school shared sources and sources they uploaded
- review/edit generated drafts
- approve or publish practice for their own classes if the school enables teacher publishing
- create worksheets and online assignments for their own classes
- view attempts and weak-topic analytics for their own students/classes

Teacher default restrictions:

- cannot manage billing, domains, or tenant-wide settings
- cannot manage all users unless granted Admin permission
- cannot approve source rights for tenant-wide library unless granted Reviewer permission
- cannot publish content into the shared school question bank unless granted Reviewer or Curriculum Lead permission
- cannot access another teacher's private sources, classes, or student data unless explicitly shared

Source visibility options:

- private_to_uploader
- shared_with_class
- tenant_shared
- blocked

Uploaded sources should start as `private_to_uploader` or `needs_source_review` unless the school policy allows trusted teachers to publish directly into the shared source library.

Registration rules:

- Google login proves identity only
- teacher/admin access requires an invitation or existing membership
- student access requires an invitation, class code, assignment code, or existing membership
- public school-owner signup can be added later for SaaS onboarding

Future roles:

- Parent
- External content author
- School district / multi-school operator

## 11. Component Standards

Use common components for:

- status badges
- source badges
- trust and rights badges
- filter bars
- data tables
- split-pane editors
- source preview frame
- KnowledgeNote editor
- backlinks panel
- concept graph view
- question editor
- choice editor
- validation panel
- assessment blueprint editor
- coverage and difficulty report
- exam finalization checklist
- result summary panel
- grading review queue
- assignment progress
- empty/loading/error states

Do not create one-off UI for repeated workflows.

## 12. UI Quality Gates

Before a UI change is accepted:

- no text overlap at 390px, 768px, 1280px, and 1440px widths
- all buttons have clear labels or accessible icon labels
- all tables have useful empty states
- all destructive actions require confirmation or undo
- loading and error states are implemented
- keyboard navigation works for forms and modals
- source lineage remains visible wherever generated content is reviewed
- Original Source Preview and AI Learning Preview are clearly labeled and not visually conflated
- student-visible previews show only approved preview assets
- Assessment Builder clearly separates draft, ready-to-finalize, locked, and published states
- answer keys, solution guides, and teacher rubrics are not shown in student-facing previews
- screenshots are checked for major workflow pages

## 13. Current Design Decision

Start with Teacher/Admin Portal.

The real system should keep the MVP's strongest workflow:

```text
Source Library
-> Knowledge Base
-> Generate Drafts
-> Review With Original Source
-> Approve
-> Assign / Worksheet / Assessment
```

Student Portal should be built separately but must share data contracts and design tokens.
