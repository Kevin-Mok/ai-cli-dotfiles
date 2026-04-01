# ExecPlan: Replace Vim Instant Markdown Preview

## Checklist

- [ ] Replace `suan/vim-instant-markdown` with `iamcco/markdown-preview.nvim` in `dot_vimrc.tmpl`.
- [ ] Preserve the Markdown preview key workflow on `<F8>` and `<F9>`.
- [ ] Add a repo-tracked GitHub-like dark preview stylesheet under the rendered `~/.vim` tree.
- [ ] Update the shared smoke test checklist for the Markdown preview workflow.
- [ ] Run `refresh-config` and verify the rendered Vim config diff is correct.

## Assumptions

- The user wants the best integrated live Vim workflow, not a separate `grip`-style browser command.
- `markdown-preview.nvim` is acceptable here because this environment already uses Node/Yarn tooling.
- The repo-tracked Vim config should remain the source of truth and be applied through `refresh-config`.

## Review Notes

- Current mappings in `dot_vimrc.tmpl` still call `:InstantMarkdownPreview` and `:InstantMarkdownStop`.
- The existing config already contains a commented `markdown-preview.nvim` stanza near the old plugin.
- The new preview should stay dark and GitHub-like while keeping the manual preview-start workflow.
