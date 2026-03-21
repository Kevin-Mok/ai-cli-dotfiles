# ExecPlan: Fix Adapt Skill YAML Front Matter

## Summary

Codex reports `dot_agents/skills/adapt/SKILL.md` as invalid because its
front matter does not parse as YAML.

## Assumptions

1. The skill content itself is correct and the bug is limited to front
   matter syntax.
2. A direct YAML parse of the front matter is a sufficient reproducer for
   this repo-local config bug because the failing loader lives outside this
   repository.
3. The safest fix is to preserve the same argument hint text and only make
   it valid YAML.

## Reproducer

Failing command before the fix:

```sh
python3 - <<'PY'
from pathlib import Path
import yaml

text = Path('dot_agents/skills/adapt/SKILL.md').read_text()
front_matter = text.split('---', 2)[1]
yaml.safe_load(front_matter)
PY
```

Observed behavior before the fix:

- `yaml.safe_load` raises `ParserError`.
- The parse failure points at the second bracketed token in
  `argument-hint: [TARGET=<value>] [CONTEXT=<value>]`.

## Plan

- [x] Reproduce the YAML parse failure against the current `adapt` skill
      front matter.
- [x] Patch only the malformed front matter entry so the metadata parses
      without changing the skill semantics.
- [x] Re-run the YAML parse reproducer and review the diff for accidental
      scope creep.

## Review

- Root cause: YAML treats the unquoted second bracket group in
  `argument-hint` as invalid syntax in a plain scalar.
- Fix: quote the full `argument-hint` value in
  `dot_agents/skills/adapt/SKILL.md`.
- Verification: the direct `yaml.safe_load` reproducer now parses
  successfully.
