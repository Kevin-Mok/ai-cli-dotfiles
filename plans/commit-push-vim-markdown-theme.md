# ExecPlan: Ship Vim Markdown Theme And Ignore Update

## Checklist

- [x] Review the current dirty diff and confirm the worktree is coherent to ship as one change.
- [x] Run the smallest relevant validation for the `dot_vimrc.tmpl` template change.
- [x] Stage only `.gitignore`, `dot_vimrc.tmpl`, and this ExecPlan.
- [ ] Create a Conventional Commit with a detailed body.
- [ ] Push `master` to `origin/master` and confirm the remaining worktree state.

## Assumptions

- The current dirty worktree is limited to the Markdown preview theme change in `dot_vimrc.tmpl` and the local log ignore entry in `.gitignore`.
- No additional README or other docs update is required because the change does not alter the repo's documented AI operating surface.
- Template rendering is the meaningful automated validation for this config-only change; full editor startup validation is not practical from this repo state.

## Review Notes

- Confirmed the worktree is limited to two user-facing config updates: ignore local Neovim log output and set the Instant Markdown preview theme to dark.
- Validation completed with `git diff --check`.
- Validation completed with `chezmoi execute-template < dot_vimrc.tmpl | sed -n '268,274p'`, which rendered the expected `let g:instant_markdown_theme = 'dark'` line.
