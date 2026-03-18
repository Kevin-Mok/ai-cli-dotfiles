# ExecPlan: Bind `Mod4+c` To Kitty Codex

## Checklist

- [x] Inspect the managed i3 template and confirm how `Mod4+c` is currently used.
- [x] Choose a launch command that opens `kitty` and starts `codex` reliably from i3.
- [x] Update the managed i3 template with the new Codex binding and move the Metamask shortcut to a new mnemonic key.
- [x] Verify the resulting diff only changes the intended bindings.

## Assumptions

- The requested `fn/windows key + c` maps to `Mod4+c` in the active i3 setup.
- Reassigning the existing Metamask shortcut to `Mod4+Alt+m` is acceptable because it is mnemonic and currently unused.
- Launching Codex through the stable `~/.local/share/fnm/aliases/default` Node alias is safer than depending on shell startup or a transient `/run/user/.../fnm_multishells` path.

## Review Notes

- `Mod4+c` now opens `kitty` in `/home/kevin/linux-config` and runs the Codex CLI via the stable `~/.local/share/fnm/aliases/default` Node alias, avoiding shell startup dependence.
- The previous `pass -c finances/metamask` action moved to `Mod4+Alt+m`, which matches the existing secret-shortcut pattern and keeps the mnemonic on `m`.
- Validation included a clean-environment repro showing `bash -lc` could not resolve `codex`, plus a clean-environment check that the stable Node alias could launch the Codex CLI help output.
