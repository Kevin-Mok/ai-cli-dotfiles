# Local Skills Catalog

This directory packages reusable local skills for recurring Codex work. The sections below group each live skill by the kind of job it handles, so you can scan by category first and then read a short summary of each skill's purpose, trigger cases, and distinctive tool or guardrail. Each skill subheading links directly to its `SKILL.md` file. The empty legacy `push-dirty/` directory is omitted because it does not currently define a live skill.

## Git Workflow

### [commit-session](commit-session/SKILL.md)

`commit-session` is the session-scoped shipping skill for cases where the user wants a real git commit and push, but only for files dirtied during the current Codex session. It computes the commit scope from the current `CODEX_THREAD_ID`, the matching `~/.codex/sessions/` log, and a pre-write `git status --short` baseline, then excludes anything that was already dirty at that baseline and still refuses to guess when the session boundary itself is ambiguous.

### [commit-push](commit-push/SKILL.md)

`commit-push` is the shipping skill for cases where the user explicitly wants a real git commit and push performed in the current repository. It is meant for ready-to-ship changes, not planning or history surgery, and it emphasizes checking the worktree, staging only the intended scope, running the smallest relevant verification, and producing a Conventional Commit message with a concrete bullet summary before pushing upstream.

### [gh-fix-ci](gh-fix-ci/SKILL.md)

`gh-fix-ci` is for debugging failing GitHub PR checks that run in GitHub Actions when the user wants failure analysis before any fix is attempted. It uses `gh` to locate the relevant PR, inspect actionable logs, summarize the real failure snippet, and draft a concrete remediation plan, while explicitly treating non-GitHub providers like Buildkite as out of scope apart from surfacing their details URL.

### [commit-plan](commit-plan/SKILL.md)

`commit-plan` is the read-only git planning skill for turning a dirty worktree into a sensible set of commit boundaries without staging, committing, or pushing anything. It is the right choice when the user wants help grouping changes, reviewing scope, or deciding commit order, and its main constraint is that it must remain planning-only even while inspecting the repository in detail.

## Design And Frontend

### [design-taste-frontend](design-taste-frontend/SKILL.md)

`design-taste-frontend` is a high-agency frontend generation skill for building intentional interfaces instead of default LLM layouts. It is the right fit when a task needs a fresh React or Next.js UI with strong art direction, because it enforces explicit design-variance controls, dependency checks, component architecture rules, Tailwind version awareness, and performance-minded motion rather than generic boilerplate.

### [high-end-visual-design](high-end-visual-design/SKILL.md)

`high-end-visual-design` is the premium visual polish skill for designs that need to look like agency work rather than standard SaaS output. It is best used when the goal is a cinematic, expensive-feeling interface, because it dictates typography, spacing, card treatment, motion quality, and anti-pattern bans so the result avoids generic fonts, lazy shadows, and repetitive layouts.

### [minimalist-ui](minimalist-ui/SKILL.md)

`minimalist-ui` is the editorial minimalism skill for interfaces that should feel quiet, typographic, and deliberately restrained instead of glossy or trend-chasing. Use it when the desired direction is warm monochrome, flat bento structure, muted accent color, and strong text hierarchy, because it tightly restricts gradients, heavy shadows, common SaaS fonts, generic iconography, and other defaults that would dilute that aesthetic.

### [redesign-existing-projects](redesign-existing-projects/SKILL.md)

`redesign-existing-projects` is the upgrade skill for improving an existing website or app without rewriting it from scratch. It starts by scanning the current stack and design patterns, audits the interface for generic AI-looking decisions, and then applies targeted upgrades that fit the existing framework or CSS approach while preserving the underlying functionality.

## Research And Output Control

### [feedback-memory](feedback-memory/SKILL.md)

`feedback-memory` is the durable preference-capture skill for carrying reusable user corrections and working preferences across Codex sessions through a repo-tracked plain-text `feedback.log`. It is the right fit when the user gives process, formatting, tooling, review, or communication feedback that should keep applying later, because it requires reading the canonical log before work starts, appending durable feedback immediately, and explicitly skipping ticket-specific or temporary notes.

### [full-output-enforcement](full-output-enforcement/SKILL.md)

`full-output-enforcement` is the anti-truncation skill for tasks where partial delivery would break the result, such as full files, complete component sets, or exhaustive structured output. It forces the model to count deliverables up front, bans placeholder shortcuts like omitted middle sections or "continue the pattern" prose, and requires token-limit splits to preserve completeness instead of silently dropping content.

### [openai-docs](openai-docs/SKILL.md)

`openai-docs` is the documentation lookup skill for OpenAI product and API questions that need current, authoritative answers with citations. It prioritizes the OpenAI docs MCP tools over general web browsing, uses targeted official docs fetches for exact guidance, and only falls back to official OpenAI domains if the MCP route cannot answer the question well enough.

## Browser And Desktop Automation

### [playwright](playwright/SKILL.md)

`playwright` is the CLI browser automation skill for tasks that need a real browser session from the terminal, such as navigation, form filling, screenshots, data extraction, or UI-flow debugging. It is designed around `playwright-cli` and the bundled wrapper script, starts with checking that `npx` is available, and stays focused on ad hoc terminal-driven automation rather than switching to authored Playwright test suites unless the user asks for that explicitly.

### [playwright-interactive](playwright-interactive/SKILL.md)

`playwright-interactive` is the persistent-browser variant for fast iterative debugging of web or Electron apps when restarting the automation stack would waste time. It keeps Playwright handles alive through `js_repl`, expects the relevant Codex feature flag and a fresh session, and is optimized for repeated inspection and QA passes in the same live browser context instead of one-off CLI commands.

### [screenshot](screenshot/SKILL.md)

`screenshot` is the system capture skill for requests that need a desktop-level screenshot, a specific app or window capture, or an OS-level fallback when a more integrated tool cannot grab the needed view. It centers on save-location rules and tool selection, preferring specialized capture paths when available but handling platform details such as macOS permission preflight when full-system capture is the practical route.

## Documents And Media

### [imagegen](imagegen/SKILL.md)

`imagegen` handles image generation and image editing requests through the OpenAI Image API, including concept art, covers, product shots, inpainting, background replacement, transparent assets, and batch runs. It prefers the bundled `scripts/image_gen.py` CLI for reproducible execution, requires `OPENAI_API_KEY` for live calls, and structures the job around a clear generate-versus-edit decision, explicit invariants, and output inspection before iteration.

### [pdf](pdf/SKILL.md)

`pdf` is the PDF-focused skill for reading, generating, or reviewing documents where layout fidelity matters as much as the extracted text. It favors visual validation by rendering pages, uses tools like Poppler, `reportlab`, `pdfplumber`, and `pypdf` for generation and extraction, and treats repeated render-and-check cycles as part of the normal workflow instead of trusting plain text output alone.

### [transcribe](transcribe/SKILL.md)

`transcribe` is the audio transcription skill for turning speech from audio or video into text, with optional diarization and known-speaker hints when the user needs labeled speakers. It prefers the bundled `transcribe_diarize.py` CLI for repeatable runs, requires `OPENAI_API_KEY`, and distinguishes between fast default transcription and diarized output based on the requested response format.
