---
name: commit-plan
description: Plan commits for all dirty git changes in the current repository. Use when I say `commit-plan`, `commit plan`, `plan to commit all dirty`, `group my dirty changes into commits`, or ask for a safe commit plan without actually committing. Do not use when I explicitly want you to commit or push immediately, rewrite history, or work outside git.
---

# Commit Plan

## Purpose

Create a safe, reviewable commit plan for the current repository's dirty changes without making any write actions.

This skill is planning-only. It inspects the worktree and proposes commit boundaries, but it must not stage, commit, or push changes.

## When to use

Use this skill when the goal is to inspect the current git working tree and turn all dirty changes into a sensible commit plan.

Typical triggers:
- `commit-plan`
- `commit plan`
- `plan to commit all dirty`
- `group all dirty changes into commits`
- `what should I commit here`
- `split my current changes into logical commits`

## When not to use

Do not use this skill when:
- I explicitly ask you to create commits right now
- I explicitly ask you to push right now
- I want to rebase, squash, amend, cherry-pick, or rewrite history
- I only want review of one file or one tiny change
- the current directory is not a git repository

## Definitions

For this skill, "dirty changes" include:
- modified tracked files
- staged changes
- unstaged changes
- deleted files
- renamed files
- untracked files

## Required workflow

1. Confirm the current directory is a git repository.
2. Inspect the working tree and branch state.
3. Review changed files and diffs in sensible batches.
4. Infer the smallest logical commit grouping that keeps each commit coherent.
5. Identify suspicious or risky items, including:
   - secrets or credential-like files
   - generated files or build output
   - lockfile-only drift
   - unrelated refactors mixed into feature work
   - large binary files
   - vendor or cache artifacts
6. Identify whether `readme-recruiter-sync` will likely require a root `README.md` update before any commit is safe.
   - Pay extra attention when changes touch `AGENTS.md`, `AGENTS.repo.md`, `dot_codex/`, `dot_agents/`, `plans/`, the root `README.md`, onboarding or setup flows, or any command the README currently documents.
7. Produce a commit plan that covers all dirty changes, ordered from the oldest changes to the newest changes.
8. Assume that when the plan is later executed in this repo, each successful commit will be pushed to the active branch by default unless the user explicitly says not to.
9. Do not run any write action unless I explicitly ask for it.

## Write actions forbidden by default

Do not run these unless I explicitly ask:
- `git add`
- `git commit`
- `git push`
- `git restore`
- `git reset`
- `git stash`
- `git clean`
- any command that changes files, index state, or history

## Output contract

Return the result in this structure:

### 1) Working tree summary
- branch name if relevant
- concise summary of staged, unstaged, deleted, renamed, and untracked files
- one short sentence about the overall shape of the change

### 2) Proposed commit plan
List the proposed commits in execution order from oldest to newest.

For each proposed commit:
- commit number
- purpose
- files to include
- README impact (`include root README`, `no README change expected`, or `blocked by README gate`)
- why these belong together
- suggested commit message:
  - a concise Conventional Commit-style subject line
  - a detailed commit body
  - around 5 to 10 bullet points in the body
  - each bullet should describe a concrete change made
  - avoid vague bullets like "updated stuff" or "misc fixes"

### 3) Risks or cleanup notes
Call out anything that should probably be excluded, split out, double-checked, or cleaned up first.

### 4) Optional manual commands
Provide manual `git add ...`, `git commit ...`, and `git push ...` commands I can run myself if useful.

### 5) Commit message summary
End the response with a compact summary of the suggested commit message subjects:
- put this section at the very bottom of the response
- list one subject line per proposed commit, in commit order
- keep each line to the concise Conventional Commit-style subject only
- if there is only one proposed commit, still include the one-line summary

## Commit message rules

When writing git commit messages:
- use a concise Conventional Commit-style subject line
- include a detailed commit body
- the body should contain around 5 to 10 bullet points
- each bullet should describe a specific, concrete change
- prefer clear, implementation-level details over generic summaries
- make the bullets collectively cover the meaningful parts of the diff
- avoid filler bullets written only to hit the count

Prefer the most specific Conventional Commit type that fits:
- `feat:`
- `fix:`
- `refactor:`
- `docs:`
- `test:`
- `build:`
- `ci:`
- `chore:`

Keep subject lines concise, specific, and action-oriented.

Example shape:

feat: add retry handling for webhook delivery

- add retry logic for failed webhook POST requests
- cap retry attempts and surface final failure states in logs
- separate transport errors from non-retryable application errors
- update webhook status persistence to track retry metadata
- add tests covering first-attempt success and repeated failure cases
- document retry behavior and operational expectations

## Decision rules

- Prefer multiple small coherent commits over one giant mixed commit.
- Order proposed commits from the oldest changes to the newest changes.
- If all dirty changes clearly belong together, say so and propose a single commit.
- If the diff is messy, propose a cleanup or split strategy before proposing final commits.
- If a file is ambiguous, call out the ambiguity instead of guessing.
- If validation matters, recommend the minimum relevant checks before commit.
- If `readme-recruiter-sync` likely requires a README update, include it in the matching commit or call out the blocker explicitly.
- When suggesting how the plan would be executed in this repo, assume each successful commit is followed by a push unless the user explicitly says not to.
