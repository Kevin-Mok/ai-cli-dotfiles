# ExecPlan: Commit All Dirty Changes

## Checklist

- [x] Inventory the current dirty files in the worktree.
- [x] Group the changes into coherent commit boundaries.
- [ ] Commit Codex workflow updates with partial staging.
- [ ] Commit Codex trusted-project additions.
- [ ] Commit shell navigation alias additions.
- [ ] Commit the i3 monitor output fix.
- [ ] Verify the worktree is clean after the commit sequence.

## Assumptions

- The request is to produce a commit plan for the current dirty worktree, not to create the commits yet.
- The dirty changes should be split by concern instead of bundled into one commit.
- Partial staging for `dot_codex/config.toml` is acceptable so the commit-message rule and trusted-project additions can be committed separately.

## Proposed Commit Sequence

### 1. Codex workflow updates

Files:
- `dot_codex/config.toml` (stage only the `developer_instructions` hunk)
- `aliases/key_aliases.tmpl`
- `aliases/key_files.tmpl`
- `plans/commit-all-dirty.md`

Why:
- These changes all support the Codex workflow: better commit-message guidance, a shortcut to the tracked Codex config, and a file shortcut for the commit-plan document.

Suggested commit:
- `chore(codex): tighten commit workflow guidance`

Staging notes:
- Use `git add -p dot_codex/config.toml` and stage only the hunk that adds the detailed commit-body instruction.
- Stage `aliases/key_aliases.tmpl` and `aliases/key_files.tmpl` fully.
- Stage `plans/commit-all-dirty.md` with this commit so the ExecPlan ships with the related Codex workflow changes.

### 2. Codex trusted paths

Files:
- `dot_codex/config.toml` (stage only the trusted-project additions)

Why:
- These are separate from commit workflow behavior. They change which local paths Codex treats as trusted.

Suggested commit:
- `chore(codex): trust additional local workspaces`

Staging notes:
- Use `git add -p dot_codex/config.toml` and stage only the added `[projects."..."]` blocks for the new paths.

### 3. Shell directory shortcuts

Files:
- `aliases/key_dirs.tmpl`

Why:
- This is a separate shell navigation change for new local project shortcuts.

Suggested commit:
- `feat(aliases): add shortcuts for active project directories`

### 4. i3 monitor output fix

Files:
- `dot_config/i3/config.tmpl`

Why:
- This is an environment-specific display fix and should stay isolated from Codex or shell alias changes.

Suggested commit:
- `fix(i3): update nzxt output names`

## Verification

- Before committing each group, run `git diff --cached --stat` and `git diff --cached`.
- After each commit, run `git status --short` to confirm only the remaining planned changes are still dirty.
- After the final commit, run `git status --short` and confirm there is no output.

## Risks / Notes

- `aliases/key_aliases.tmpl` now includes both `cpcx` and `cpx`, both copying the same Codex config. Keep both only if that duplication is intentional.
- The Codex config change combines behavior changes and trust-list additions in one file, so staging the right hunks matters.
