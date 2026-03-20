# ExecPlan: Fix Fish SSH Abbreviation Spam

## Summary

Fish shell startup prints a large block of `abbr -a -- ...` lines on login. The failure reproduces by sourcing the generated abbreviation file directly.

## Assumptions

1. The intended behavior is silent shell startup while preserving existing abbreviations.
2. The fix should target the generation path for `~/.config/fish/key_abbr.fish`, not unrelated fish startup logic.
3. An executable reproducer command is sufficient in place of a dedicated automated test file for this shell-init bug.

## Reproducer

Failing command before the fix:

```sh
fish --no-config -c 'source "$HOME/.config/fish/key_abbr.fish"'
```

Observed behavior before the fix:

- Fish prints the full serialized abbreviation list.
- The generated file contains a bare `abbr` line, which causes Fish to print all abbreviations.

## Plan

- [x] Inspect the generator inputs and confirm which source line produces the bare `abbr`.
- [x] Patch the generator to ignore whitespace-only input lines and avoid emitting empty abbreviation commands.
- [x] Regenerate or simulate generation as needed and rerun the reproducer to confirm startup is silent.
- [x] Review the diff to keep the change minimal and reversible.

## Review

- Root cause: a whitespace-only line in `aliases/key_aliases.tmpl` became a bare `abbr` command in the generated fish abbreviation file.
- Fix: remove the stray whitespace-only input line and harden `scripts/executable_sync-shortcuts` so whitespace-only alias lines are discarded before fish abbreviation generation.
- Verification: regenerated an isolated `key_abbr.fish` from rendered alias inputs and confirmed `fish --no-config -c 'source .../key_abbr.fish'` produces `0` output lines, with no bare `abbr` lines present.
