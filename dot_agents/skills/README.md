# Local Skills Catalog

This directory packages repo-tracked local skills for recurring Codex
work. The catalog below documents every directory under
`dot_agents/skills/` that currently exposes a `SKILL.md`, grouped by
the kind of job it handles so you can scan by intent first and then jump
straight to the source file.

The live Codex install also mounts the external
[`obra/superpowers`](https://github.com/obra/superpowers) bundle at
`~/.agents/skills/superpowers` by cloning it into `~/.codex/superpowers`
and symlinking its `skills/` directory. It is intentionally omitted from
the catalog below because this file only documents repo-tracked skill
sources that live under `dot_agents/skills/`. The legacy `push-dirty/`
directory is also omitted because it does not currently define a live
skill.

Many of the design skills are composable rather than mutually
exclusive: `teach-impeccable` captures persistent design context,
generator skills create or redesign a feature, and the narrower pass
skills tighten one specific aspect of an existing interface.

## Git Workflow

- [`commit-plan`](commit-plan/SKILL.md): Plans safe commit boundaries for
  all dirty git changes without staging, committing, or pushing.
- [`commit-push`](commit-push/SKILL.md): Verifies scope, runs the minimum
  relevant checks, then stages, commits, and pushes ready changes in the
  current repository.
- [`commit-session`](commit-session/SKILL.md): Ships only the files
  dirtied during the current Codex session by combining a pre-write git
  baseline with session-log evidence.
- [`gh-fix-ci`](gh-fix-ci/SKILL.md): Investigates failing GitHub Actions
  PR checks with `gh`, summarizes the real failure context, and drafts a
  fix plan before implementation.

## Frontend Direction And Generators

- [`teach-impeccable`](teach-impeccable/SKILL.md): Performs one-time
  design-context capture, writes a `## Design Context` section to
  `.impeccable.md`, and gives later design work a persistent audience,
  tone, and aesthetic baseline.
- [`frontend-design`](frontend-design/SKILL.md): Creates distinctive,
  production-grade interfaces while insisting on explicit audience, use
  case, and brand context before any design implementation starts.
- [`design-taste-frontend`](design-taste-frontend/SKILL.md): Acts as a
  senior UI/UX engineer for high-agency frontend work, with strict rules
  around component architecture, motion quality, typography, and
  avoiding generic AI aesthetics.
- [`high-end-visual-design`](high-end-visual-design/SKILL.md): Pushes an
  interface toward premium agency-style execution through stronger font,
  spacing, card, and animation choices.
- [`minimalist-ui`](minimalist-ui/SKILL.md): Drives a restrained
  editorial direction with warm monochrome tones, flat bento structure,
  typographic contrast, and muted accent color.
- [`redesign-existing-projects`](redesign-existing-projects/SKILL.md):
  Upgrades an existing site or app to higher visual quality without
  throwing away its current framework, CSS approach, or functionality.

## UX, Quality, And System Alignment

- [`adapt`](adapt/SKILL.md): Adjusts a design for different screen
  sizes, devices, contexts, or platforms so the experience stays
  coherent outside its original happy path.
- [`audit`](audit/SKILL.md): Runs a broad interface audit across
  accessibility, performance, theming, and responsive behavior, then
  reports issues with severity and recommendations.
- [`critique`](critique/SKILL.md): Reviews visual hierarchy, information
  architecture, emotional resonance, and overall UX quality from a
  design-review perspective.
- [`extract`](extract/SKILL.md): Pulls reusable components, design
  tokens, and repeated patterns into a more systematic design-system
  surface.
- [`harden`](harden/SKILL.md): Improves production readiness through
  better error states, i18n handling, text overflow behavior, and edge
  case coverage.
- [`normalize`](normalize/SKILL.md): Realigns a feature with the existing
  design system, tokens, and component patterns, and explicitly routes
  through the design-context workflow first.
- [`onboard`](onboard/SKILL.md): Designs or improves onboarding, empty
  states, and first-run flows so users understand value and next steps
  faster.
- [`optimize`](optimize/SKILL.md): Focuses on frontend performance across
  loading speed, rendering, animation cost, image handling, and bundle
  size.

## Targeted Design Passes

- [`animate`](animate/SKILL.md): Adds purposeful motion,
  micro-interactions, and state transitions that improve usability
  instead of decorating for its own sake.
- [`arrange`](arrange/SKILL.md): Reworks layout, spacing, and visual
  rhythm when a feature feels flat, crowded, or compositionally weak.
- [`bolder`](bolder/SKILL.md): Turns an overly safe design into
  something more expressive and visually interesting without losing
  usability.
- [`clarify`](clarify/SKILL.md): Rewrites fuzzy labels, microcopy, error
  messages, and instructions so the interface is easier to understand.
- [`colorize`](colorize/SKILL.md): Introduces strategic color when a
  feature feels too monochrome or lacks visual energy.
- [`delight`](delight/SKILL.md): Adds moments of personality,
  surprise, and joy that make a competent interface feel memorable.
- [`distill`](distill/SKILL.md): Removes unnecessary complexity so the
  interface gets cleaner, sharper, and more focused on its core job.
- [`overdrive`](overdrive/SKILL.md): Pushes a feature into technically
  ambitious territory with standout interactions or visual effects that
  make the implementation feel hard to ignore.
- [`polish`](polish/SKILL.md): Performs a final quality pass on spacing,
  alignment, consistency, and edge details before shipping.
- [`quieter`](quieter/SKILL.md): Dials back an interface that feels too
  loud or visually aggressive while keeping it intentional.
- [`typeset`](typeset/SKILL.md): Tightens font choice, hierarchy, sizing,
  weight, and readability so the typography looks deliberate instead of
  default.

## Docs, Knowledge, And Output Control

- [`feedback-memory`](feedback-memory/SKILL.md): Stores durable user
  corrections and working preferences in a repo-tracked `feedback.log`
  so later sessions can honor them.
- [`full-output-enforcement`](full-output-enforcement/SKILL.md): Prevents
  truncated delivery on tasks where partial code or partially generated
  structured output would break the result.
- [`openai-docs`](openai-docs/SKILL.md): Handles OpenAI product and API
  questions with current, citation-ready answers grounded in official
  OpenAI documentation.
- [`readme-recruiter-sync`](readme-recruiter-sync/SKILL.md): Treats the
  root `README.md` as a hard documentation gate for repo-surface changes,
  keeping setup, usage, command flags, stack rationale, and recruiter
  framing aligned with the repo.

## Browser And Desktop Automation

- [`playwright`](playwright/SKILL.md): Uses terminal-driven Playwright
  automation for navigation, form filling, screenshots, extraction, and
  other real-browser tasks.
- [`playwright-interactive`](playwright-interactive/SKILL.md): Keeps a
  browser or Electron session alive through `js_repl` for fast iterative
  UI debugging without constant relaunches.
- [`screenshot`](screenshot/SKILL.md): Captures desktop-level screenshots
  when the user needs a full-screen, window, or system-level image and a
  more integrated tool cannot grab it.

## Documents And Media

- [`imagegen`](imagegen/SKILL.md): Generates or edits images through the
  OpenAI Image API, including concept art, product shots, background
  replacement, masking, and transparent outputs.
- [`pdf`](pdf/SKILL.md): Handles PDF reading, generation, and review when
  rendering fidelity matters as much as extracted text.
- [`transcribe`](transcribe/SKILL.md): Transcribes audio or video into
  text, with optional diarization and known-speaker hints when speaker
  labeling matters.
