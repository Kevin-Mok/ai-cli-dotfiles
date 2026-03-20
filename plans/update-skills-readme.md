# ExecPlan: Update Skills README

## Goal

Refresh `dot_agents/skills/README.md` so it documents the current live
skill inventory under `dot_agents/skills/*/SKILL.md` instead of the
older, incomplete catalog that is in the repo today.

## Assumptions

- The user's request targets `dot_agents/skills/README.md`, not the root
  `README.md`, unless a follow-up sync check shows the root README is now
  inaccurate.
- Only directories that currently expose `SKILL.md` count as live skills
  for this catalog.
- The new untracked skill directories shown in `git status --short` are
  intentional repo work and should be reflected in the catalog rather
  than treated as noise.

## Checklist

- [x] Audit the live `dot_agents/skills/*/SKILL.md` inventory and compare
      it against the current catalog.
- [x] Rewrite `dot_agents/skills/README.md` so every live skill appears
      exactly once with a direct link and concise summary.
- [x] Verify the rewritten catalog against the filesystem and confirm the
      documented count matches the live skill count.
- [x] Run the root README sync check and record whether it is
      `pass_no_change` or needs a follow-up edit.

## Verification

- `find dot_agents/skills -mindepth 2 -maxdepth 2 -name SKILL.md | sort`
- `python3 - <<'PY' ... PY` to compare live skill directories with README
  headings
- `rg -n '^(##|###) ' dot_agents/skills/README.md`
- Root README sync outcome recorded after checking `README.md` against the
  repo evidence touched by this change

## Review Notes

- The previous catalog documented 18 linked skills while the live
  inventory under `dot_agents/skills/*/SKILL.md` contained 39.
- The rewritten catalog now links 39 unique skills, which exactly matches
  the current live inventory. Verification reported no missing or extra
  entries.
- The catalog structure was expanded to cover Git workflow, frontend
  generators, UX and system-alignment skills, targeted design passes,
  docs and knowledge skills, browser automation, and document or media
  tools.
- The empty legacy `dot_agents/skills/push-dirty/` directory remains
  intentionally undocumented because it still lacks a `SKILL.md`.
- Root README sync outcome: `pass_no_change`. The root `README.md`
  already links the skills catalog, references the local skills surface,
  and remained accurate after this docs-only update.
