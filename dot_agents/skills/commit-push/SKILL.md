---
name: commit-push
description: Commit and push ready working changes in the current git repository after verifying scope and running the minimum relevant checks. Use when I explicitly ask to `commit-push`, `commit and push this`, `ship these changes`, or otherwise want a real commit and push performed in the current session. Do not use for commit planning only, history rewrites, force-pushes, or ambiguous mixed diffs.
---

# Commit Push

Use this skill for explicit write requests to create a real git commit and push it from the current repository. Treat speed as secondary to shipping a coherent, verified change.

## Required Workflow

1. Confirm the current directory is a git repository and identify the active branch and upstream.
2. Inspect `git status`, changed files, and relevant diffs before staging anything.
3. Decide whether the worktree is safe to ship as requested.
   - If the changes are coherent, continue.
   - If unrelated or suspicious changes are mixed in, stop and ask how to split or exclude them instead of guessing.
4. Verify the change.
   - Run the smallest relevant automated checks.
   - Add or run a failing reproducer first for bug fixes when practical.
   - Do not commit failing or unverified work just because the user asked for a quick push.
5. Stage only the intended files or hunks.
6. Write the commit message.
   - Use a concise Conventional Commit subject line.
   - Add a body with around 5 to 10 concrete bullet points that describe the actual changes.
7. Create the commit.
8. Push the branch.
   - Push to the configured upstream by default.
   - If no upstream exists or the target remote is unclear, stop and ask instead of guessing.
   - Do not amend, rebase, squash, or force-push unless the user explicitly asks.
9. Report the result with the validation performed, commit SHA, push target, and remaining worktree state.

## Guardrails

- Do not use this skill when the task is only to plan commits or group dirty changes without writing. Use `push-plan` for that case.
- Never bundle unrelated dirty changes into one commit to save time.
- Never stage secrets, credentials, caches, build output, or machine-local files unless they clearly belong in version control.
- Respect pre-existing user changes. Do not revert or discard work you did not make.
- If the diff is too mixed to ship safely without a decision, ask one short clarifying question and stop there.

## Output Contract

After a successful run, report:

- the final commit subject and short SHA
- the validation commands or manual checks that were run
- the branch and push destination
- whether the worktree is now clean or what still remains dirty
