---
name: smoke-test-capture
description: Use when work in this repo introduces a concrete manual verification step, changes the expected outcome of an existing manual check, or exposes an obvious gap in the shared smoke-test checklist.
---

# Smoke Test Capture

## Purpose

Keep the repo's manual smoke coverage in one shared document instead of
leaving manual checks buried in chat, plans, or one-off verification
notes.

## Canonical Document

Use `~/linux-config/docs/smoke-tests.md` as the canonical checklist for
this repo. If you are working from the repo root, that is
`docs/smoke-tests.md`.

Do not create per-task smoke files or per-skill smoke files when this
repo-tracked checklist is available.

## When To Use

Use this skill when:

- the current task creates a new manual verification path
- an existing manual smoke check now has a different expected result
- you notice a missing smoke check while working, even if it is not the
  main focus of the task
- a verification note in chat or a plan should become reusable repo
  documentation

Do not use this skill for:

- one-off debugging steps that are not worth keeping
- purely automated test cases that already live in code
- temporary workarounds or machine-specific checks

## Required Workflow

1. Open `docs/smoke-tests.md`.
2. Identify the manual check from the current task and any other obvious
   smoke-test gap you noticed while working.
3. Reuse the best existing section. If none fits, add one concise new
   section named after the repo area being tested.
4. Update an existing entry when the behavior is the same check with a
   changed expectation. Add a new entry only when the checklist gains a
   distinct manual check.
5. Keep entries short and concrete:
   - `Action:` the manual step a human can perform
   - `Expected:` the observable outcome that counts as success
6. Prefer stable checks that would still be useful in a later task.
7. If you changed repo behavior in a way that affects the smoke
   checklist, update the checklist in the same change instead of leaving
   the check only in verification notes.

## Entry Format

- Action: open the relevant UI, run the relevant command, or perform the
  manual operator step
- Expected: record the visible result, state change, or success
  criterion

Example:

```markdown
- Action: Add a new repo-tracked skill under `dot_agents/skills/`.
  Expected: The relevant skill docs and the public README surfaces stay aligned with the new workflow.
```

## Guardrails

- Do not duplicate an existing check just because wording differs.
- Do not leave stale expectations behind after behavior changes.
- Do not dump raw notes, branch-specific details, or task history into
  the smoke-test document.
- Do not create a new section when an existing one already matches the
  same repo area.
