---
name: feedback-memory
description: Persist durable user corrections and preferences across sessions through a repo-tracked plain-text `feedback.log`. Use when starting a session that should honor prior reusable feedback, or when the user gives durable guidance about workflow, formatting, style, tooling, review expectations, or communication that should apply again later.
---

# Feedback Memory

## Purpose

Carry forward reusable user feedback across sessions with one canonical append-only log.

## Log Path

Use this resolution order:

1. Prefer `~/linux-config/dot_agents/skills/feedback-memory/feedback.log` when it exists. In this chezmoi-managed setup, that is the canonical log because `~/linux-config` is the source state.
2. Otherwise, fall back to `feedback.log` in this installed skill folder.
3. If both files exist, read and append only the repo-tracked path.

## When to use

Use this skill when:
- starting a session and prior durable feedback may matter
- the user gives a correction or preference that should change future behavior
- the feedback is about workflow, style, formatting, review expectations, tooling habits, or communication

## When not to use

Do not log:
- task-specific instructions tied to the current ticket, branch, file, or investigation
- one-off requests or temporary preferences
- ephemeral facts that will age out quickly
- details that duplicate the current task context instead of generalizing beyond it

## Required workflow

1. Resolve the canonical log path using the rules above.
2. Before doing anything else in the session, read the canonical `feedback.log`.
3. Treat the log as durable operating guidance. Apply it throughout the session unless the user overrides it explicitly.
4. When the user gives new durable feedback, append it to the canonical log immediately before continuing.
5. Do not create, update, or reconcile a second log when the repo-tracked path exists.
6. Keep the file append-only. Do not rewrite, reformat, dedupe, or move old entries unless the user explicitly asks.
7. If the feedback is ambiguous, log only the durable part that would still help in a different future task.

## What to log

Log reusable notes such as:
- formatting and response-style preferences
- review expectations and quality bars
- tooling habits or workflow preferences
- corrections that would prevent repeating the same mistake

## Entry format

- Prefix each entry with `YYYY-MM-DD - `
- Use one line for brief durable preferences.
- For nuanced corrections, add one short continuation line indented by two spaces.
- Keep entries concrete and operational.

## Rule Of Thumb

Log it only if it would still be useful in a different future task.
