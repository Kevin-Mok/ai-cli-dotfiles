---
name: commit-session
description: Commit and push only the git changes dirtied during the current Codex session, while leaving pre-existing dirty work from other sessions uncommitted. Use when I say `commit-session`, `commit session`, `ship this session`, `commit only this Codex session`, or explicitly ask to avoid committing pre-existing or other-session dirty changes. Do not use for commit planning only, all-dirty shipping, history rewrites, or cases where session scope cannot be proven from Codex logs.
---

# Commit Session

Use this skill for explicit write requests that should ship only the files dirtied during the current Codex session. Treat the pre-write dirty baseline as the primary safety boundary.

## Required Workflow

1. Confirm the current directory is a git repository and identify the active branch and upstream.
2. Read `CODEX_THREAD_ID`. If it is missing, stop and report that session-scoped shipping is unavailable.
3. Run the scope helper before staging anything:
   - `git rev-parse --show-toplevel`
   - `python3 dot_agents/skills/commit-session/scripts/session_scope.py --repo-root <repo-root>`
4. Inspect the helper output.
   - If `status` is `unsafe`, stop and report the `unsafe_reason`.
   - If `status` is `empty`, stop and report that there are no current-session dirty files to ship.
   - Continue only with `commitable`.
5. Review diffs only for the `commitable` files.
   - `commitable` can include directly observed edits and files that became dirty after the session baseline.
   - If any `commitable` file still looks mixed or suspicious, stop instead of guessing.
6. Run the smallest relevant automated checks for the scoped change.
7. Run `readme-recruiter-sync` against the root `README.md`.
   - Treat the gate as mandatory before staging or committing.
   - If the gate passes without README changes, continue.
   - If the gate requires `README.md` edits, continue only when `README.md` is already present in `commitable`.
   - If `README.md` was already dirty at the session baseline or is otherwise excluded from `commitable`, stop and report that the session-scoped commit cannot satisfy the required README gate safely.
8. Stage only the union of `stage_paths` from `commitable`.
9. Write the commit message.
   - Use a concise Conventional Commit subject line.
   - Add a body with around 5 to 10 concrete bullet points describing the actual changes.
10. Create the commit.
11. Push to the configured upstream.
    - If no upstream exists or the push target is unclear, stop and ask instead of guessing.
    - Do not amend, rebase, squash, or force-push unless the user explicitly asks.
12. Report the result with the validation performed, commit SHA, push target, skipped files, and remaining worktree state.

## Guardrails

- Never stage files listed under `skipped_preexisting`.
- Never stage files listed under `skipped_unknown`.
- Never bypass `readme-recruiter-sync` because the scoped diff looks small.
- Never invent README claims, flags, install steps, or recruiter copy that the repo does not support.
- If the helper cannot find a pre-write `git status --short` baseline for the session, fail closed instead of reconstructing scope from timestamps or memory.
- If a file was already dirty at the session baseline and the current session also edited it, leave the file uncommitted unless the user explicitly asks for a manual split.
- Review newly eligible generated or companion files before staging them; baseline-delta scoping is intentionally permissive, not blind.
- Never bundle unrelated dirty changes just because they happen to be present in the same repository.
- Never stage secrets, credentials, caches, build output, or machine-local files unless they clearly belong in version control.

## Scope Helper

Use `scripts/session_scope.py` to compute the session file set from:

- the current session id from `CODEX_THREAD_ID`
- the matching Codex session log under `~/.codex/sessions/`
- successful `apply_patch` edits and known scaffold writes from the current session
- successful in-repo commands from the current session that are not on the helper's read-only allowlist
- the latest successful `git status --short` captured before the first repo write in that session
- the current repository dirty state

The helper returns JSON with:

- `commitable`: files that were clean at the session baseline and are dirty now, with an `ownership_reason` of `observed_touch` or `newly_dirty_since_baseline`
- `skipped_preexisting`: files that were already dirty before this session started writing
- `skipped_unknown`: compatibility bucket for dirty files the helper still cannot classify safely
- `unsafe_reason`: why the skill must stop when the session boundary is not trustworthy

## Output Contract

After a successful run, report:

- the final commit subject and short SHA
- the session id used for scoping
- the validation commands or manual checks that were run
- the branch and push destination
- which files were committed from `commitable`, including their `ownership_reason`
- which files were left dirty from `skipped_preexisting` and `skipped_unknown`
- whether the worktree is now clean or what still remains dirty
