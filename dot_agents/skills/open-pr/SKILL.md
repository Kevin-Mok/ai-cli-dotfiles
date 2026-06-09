---
name: open-pr
description: Use when asked to draft, write, prepare, open, update, or improve a pull request title or body from current branch changes, including base-branch comparisons, `docs/pr` sync, GitHub PR creation or editing with `gh`, DD/Cindy LessonOps handoffs, or reviewer-focused PR context.
---

# Open PR

## Purpose

Draft or publish a strong pull request title and body from evidence in the
current branch compared with the requested base branch.

Treat the PR body as the reviewer's central context hub: explain why the
branch exists, what changed, how to verify it, what risks remain, and what
kind of feedback is most useful.

## Required Workflow

1. Determine the desired base branch from the user request.
   - Infer `main` only when repo context makes that obvious.
   - If multiple bases are plausible, ask one concise question before
     drafting.
2. Capture worktree and branch state:
   - `git status --short`
   - `git branch --show-current`
   - `git remote -v` when remote/base context matters
   - branch tracking info when the head branch or fork context is ambiguous
3. Compute the branch comparison against the chosen base:
   - `git merge-base HEAD <base>`
   - `git log --oneline <merge-base>..HEAD`
   - `git diff --stat <merge-base>..HEAD`
   - `git diff --name-only <merge-base>..HEAD`
4. Inspect meaningful changed files and supporting context:
   - selected source diffs for the files that drive the PR story
   - related tests, docs, README sections, active `plans/`, and
     `docs/smoke-tests.md`
   - existing `docs/pr/` files or repository PR templates
   - verification output, CI links, screenshots, live URLs, issue links, or
     handoff notes when present
5. Keep a brief evidence ledger:
   - facts directly observed from commands, files, screenshots, links, or logs
   - inferences made from those facts
   - missing evidence that should not be invented
6. Synthesize the PR from evidence, not from the latest commit message alone.
7. When the repository uses PR docs, create or update the matching Markdown
   file under `docs/pr/` and keep it in sync with the GitHub PR body.
8. If the user explicitly asks to open or update a GitHub PR and `gh` is
   available, confirm the base/head context, then use the generated title/body
   with `gh pr create` or `gh pr edit`. If the user only asks for a draft, do
   not create or edit the GitHub PR.

## Drafting Rules

- Title: concise, specific, and action-oriented. Start with a present-tense
  verb when that matches the repository convention.
- Scope: call out large diffs, unrelated churn, missing tests, migration risk,
  rollback complexity, or PRs that should be split.
- Specificity: prefer concrete files, flows, commands, URLs, data shapes, and
  user impact over generic "updates/fixes" language.
- Honesty: never invent tests, smoke results, screenshots, live links, issue
  references, CI status, or reviewer approval. Say "not run", "not captured",
  or "not available" when evidence is missing.
- UI and docs rendering: ask for or include screenshots, before/after notes,
  previews, or live links when reviewer inspection would benefit from visual
  evidence.
- AI cleanup: trim filler, inflated importance, and line-by-line diff retelling.
  Add business context and environment-specific test steps that tooling cannot
  infer.

## PR Body Template

Use these sections unless the repository provides a stricter template. If a
section is not applicable, include `Not applicable` plus a short reason.

```markdown
## Summary / Why This Matters

## What Changed

## How To Smoke Test

## Tests Written / Verification Run

Automated tests written or updated:

Commands run:

Commands not run:

Known failing suites or unrelated failures:

## Follow-Up / Next Steps

## Reviewer Focus / What To Look For

## Risks, Caveats, Known Failures, And Rollback

## UI Screenshots / Live Links
```

In `How To Smoke Test`, use exact local commands and URLs when known. If a
reviewer needs a local backend or other local service, state that explicitly.

In `Reviewer Focus / What To Look For`, request the feedback type that would
help most: product fit, frontend/backend contract, security, smoke
reproducibility, content quality, UI behavior, data shape, rollback safety, or
another concrete concern suggested by the diff.

## Repository-Specific Handling

Read [references/lessonops-style.md](references/lessonops-style.md) when the
work is in `/home/kevin/coding/lesson-ops`, the repository remote is
`admintriwayeducation/lessonops`, or the request mentions DD, Dongdong, Cindy,
LessonOps, local backend review, Google classroom/progress flows, Gauss/CEMC
worksheets, approved worksheets, or `docs/pr/` LessonOps handoff docs.

Read [references/pr-writing-guidance.md](references/pr-writing-guidance.md)
when you need the external rationale behind the template, especially for title
quality, small/focused PRs, screenshot expectations, AI-generated PR cleanup,
and reviewer-focus guidance.

## GitHub PR Commands

When creating or editing a GitHub PR:

- Prefer writing the final body to a temporary Markdown file or the repo
  `docs/pr/` file, then pass it with `--body-file` to avoid shell quoting bugs.
- Use `gh pr create --base <base> --head <head> --title <title> --body-file <file>`
  only after confirming base/head context.
- Use `gh pr edit <number-or-url> --title <title> --body-file <file>` when
  updating an existing PR.
- Use `gh pr view` after create/edit when available and report the resulting
  URL.

## Output Contract

When done, show:

1. Final PR title.
2. Final PR body in Markdown.
3. The `docs/pr/` path created or updated, if any.
4. The GitHub PR URL, if one was created or edited.
5. Exact evidence inspected: base branch, merge base, commit range, changed
   file summary, docs reviewed, and verification output reviewed.
6. Important evidence not run, not checked, or not available.
