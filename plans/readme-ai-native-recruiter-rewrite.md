# ExecPlan: Expand Root README For Technical Depth And Stronger Hook

## Summary

Replace the compressed root `README.md` with a recruiter-first technical
narrative that restores much more of the repo's proof surface. Keep the
opening hook sharper than before, but bring back deeper AI-layer
explanations, a lighter table of contents, a more substantial repo tour,
and enough architectural detail that the README still stands out to
AI-native engineers.

## Assumptions

- The root README should still sell the repo as a serious technical
  artifact, not collapse into pure branding copy.
- The strongest proof points are the AGENTS chain, tracked Codex config,
  local skills, ExecPlans, `chezmoi`, terminal tooling, and the
  Graphiti-backed `codex` launch path.
- The root README should restore technical depth without fully returning
  to the earlier 500-line catalog and footnote-link style.
- The hero image still helps the README communicate the workflow quickly
  and should stay.

## Checklist

- [x] Verify the documented commands and flags that the rewritten README
      will keep.
- [x] Rewrite `README.md` around a catchier hook, stack rationale, AI
      operating-surface depth, install flow, day-to-day usage, command
      reference, and a selective broader repo tour.
- [x] Restore a table of contents and the most useful deep sections from
      the earlier README without reviving the old repeated narrative.
- [x] Keep the Graphiti explanation accurate to the tracked `codex`
      launcher behavior.
- [x] Harden the approved README structure in `AGENTS.repo.md` so future
      rewrites default to the same technical-deep shape.
- [x] Re-read the README against the recruiter-sync contract and run the
      relevant verification commands.

## Review Notes

- Re-expanded the README into a deeper technical narrative after the
  shorter rewrite proved too compressed for the repo and audience.
- Kept the recruiter-facing hook and stack rationale at the top, but
  restored deeper sections for the AI operating surface, core
  components, Graphiti memory layer, reproducibility, and the broader
  Linux environment.
- Preserved the current Graphiti accuracy fixes and the repo-local
  `codex` wrapper option coverage from the shorter rewrite.
- Restored a lighter table of contents because the README is long enough
  again to benefit from navigation.
- Kept inline relative links instead of reviving the earlier footnote
  block, which preserves scanability while still grounding claims in repo
  evidence.
- Added repo-local README-structure rules to `AGENTS.repo.md` so this
  technical-deep, AI-layer-first layout becomes the default for future
  refreshes unless the user explicitly asks for a different shape.
- Added a repo-local rule that when the README documents a repo-wrapped
  external tool such as `codex`, it must also document how the
  underlying tool is obtained.
- Tightened the README's `codex` launcher wording after review showed the
  wrapper does not always win on `PATH`; the README now distinguishes
  between invoking `"$HOME/scripts/codex"` directly and using plain
  `codex` only when the wrapper wins on `PATH`.

## Verification

- `chezmoi diff --help`
- `chezmoi apply --help`
- `codex --help`
- `codex mcp list --help`
- `sed -n '1,240p' dot_config/fish/functions/refresh-config.fish`
- `rg -n "superpowers|~/.agents/skills/superpowers|~/.codex/superpowers" -g '*' .`
- `sed -n '1,260p' README.md`
- `wc -l README.md`
- `rg -n '^## ' README.md`
- `rg -n "Table Of Contents|^## License$|^## Graphiti Memory Layer$|CODEX_WRAPPER_GRAPHITI_CWD|CODEX_WRAPPER_STATE_DIR|localhost:7687" README.md`
- `which -a codex`
- `sed -n '70,95p' dot_config/fish/config.fish.tmpl`
- `sed -n '118,136p' dot_zshrc`
- `git diff --check -- README.md AGENTS.repo.md dot_agents/skills/feedback-memory/feedback.log tasks/lessons.md plans/readme-ai-native-recruiter-rewrite.md`
- Parallel read-only review of the updated README against the recruiter
  sync contract and repo evidence after the final wrapper-wording fix:
  no findings.
