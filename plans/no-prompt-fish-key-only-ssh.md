# ExecPlan: Stop Fish Pass Prompts And Prove Key-Only SSH

## Checklist

- [x] Inspect fish startup and existing phone SSH hardening scripts.
- [x] Change fish startup so password-store lookups never prompt during shell open.
- [x] Make SSH verification output show the key-only authentication method.
- [x] Guard SSH hardening against applying key-only auth without an authorized key.
- [x] Run syntax checks and targeted verification.
- [x] Apply repo config refresh if local tooling allows it.

## Assumptions

- The startup password prompt is caused by `pass show career/openai-openclaw`
  in `dot_config/fish/config.fish.tmpl`.
- The desired fish behavior is to skip loading `OPENAI_API_KEY` when the GPG
  key is locked, not to remove password-store integration entirely.
- The SSH hardening scripts are the canonical repo workflow for enforcing
  key-only SSH on the host.

## Review Notes

- Updated fish startup to run the OpenAI key `pass show` with non-interactive
  GPG options, so a locked key fails closed instead of prompting when fish
  opens.
- Updated the phone SSH doctor to include `authenticationmethods` in effective
  `sshd -T` output so key-only auth is visible during diagnosis.
- Added an authorized-key guard to the hardening script so it will not force
  key-only SSH for an account that has no valid public key installed.
- Applied the fish config target with `chezmoi apply ~/.config/fish/config.fish`.
  A full `refresh-config` run was attempted first, but full `chezmoi apply`
  prompted on the live `.codex/config.toml` mode diff, so I did not approve an
  unrelated permission change.
- Attempted to apply live SSH hardening with
  `./scripts/executable_harden-phone-ssh.sh --port 22229`, but the command
  stopped at sudo authentication. No live `/etc/ssh` change was made by that
  attempt.
