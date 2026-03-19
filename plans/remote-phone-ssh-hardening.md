# ExecPlan: Harden SSH For Phone Access Over Public IP

## Checklist

- [x] Inspect repo conventions for scripts, docs, and plan files.
- [x] Confirm there is no existing managed `sshd` server config in the repo.
- [x] Add a setup script that installs a hardened `sshd_config.d` snippet.
- [x] Make the setup script validate key presence before disabling passwords.
- [x] Document router/NAT, firewall, and verification steps for phone access.
- [x] Add a follow-up hardening script for spam-resistant SSH settings.
- [x] Document the extra hardening layer and its tradeoffs.
- [x] Review the new files for correctness and scope.

## Assumptions

- The requested deliverable is a checked-in repo workflow, not only inline shell commands.
- The target host already has OpenSSH server installed and managed by `systemd`.
- The user wants key-only SSH login on a non-default TCP port, with router port forwarding handled manually outside the host.
- The repo should avoid lockout by refusing to disable password auth unless the target account already has an authorized public key or one is supplied during setup.

## Review Notes

- Added `scripts/executable_setup-phone-ssh.sh` as the host-side apply flow.
  It writes `/etc/ssh/sshd_config.d/80-phone-remote-access.conf`, refuses to
  disable password auth unless the target account already has at least one
  valid public key, optionally appends a supplied public key, opens the chosen
  port in `ufw` or `firewalld` when active, creates `/run/sshd` when missing,
  validates with `sshd -t`, re-execs itself through `sudo` when needed, updates
  `ssh.socket` `ListenStream` entries when socket activation is enabled, and
  otherwise enables and starts `ssh.service`.
- Added `docs/phone-ssh-public-ip.md` with prerequisites, exact usage,
  router-forwarding requirements, verification steps from cellular data, a
  host-side doctor command, and a rollback command.
- Added `scripts/executable_harden-phone-ssh.sh` as a separate follow-up
  hardening layer that writes
  `/etc/ssh/sshd_config.d/81-phone-ssh-hardening.conf`, restricts SSH to a
  chosen user with `AllowUsers`, forces `AuthenticationMethods publickey`, and
  tightens auth and connection limits to reduce spam and abuse surface.
- Local verification completed with:
  - `chmod +x scripts/executable_setup-phone-ssh.sh`
  - `bash -n scripts/executable_setup-phone-ssh.sh`
  - `bash scripts/executable_setup-phone-ssh.sh --help`
  - `chmod +x scripts/executable_harden-phone-ssh.sh`
  - `bash -n scripts/executable_harden-phone-ssh.sh`
  - `bash scripts/executable_harden-phone-ssh.sh --help`
  - `sed -n '1,240p' docs/phone-ssh-public-ip.md`
- I did not apply the SSH config on this machine because that would require
  changing the live host's `/etc/ssh` state and router/firewall environment.
- After the first version, the user provided a live repro showing
  `Missing privilege separation directory: /run/sshd` during `sshd -t`. The
  setup script now creates that runtime directory before validation.
- After a later user correction, the script was updated to require root up
  front by re-execing itself with `sudo`, so the documented invocation no
  longer needs `sudo bash ...`.
- After another live repro where the phone still got `Connection refused` on
  the custom port, I inspected the host unit files and found a stock
  `ssh.socket` listening on port `22`. The setup script now manages a socket
  override when `ssh.socket` is enabled or active so the custom port is exposed
  through systemd socket activation too.
- After a further live repro where the problem still persisted, I added
  `scripts/executable_doctor-phone-ssh.sh` so the host can report whether the
  failure is still local listener/firewall state or has moved out to
  router/public-IP reachability.
- The doctor script later showed a host with `ssh.socket` disabled and no live
  listener on either port `22` or the custom port. The setup script now uses
  `systemctl enable` plus `reload-or-restart` for `ssh.service` when socket
  activation is not controlling the listener, instead of the earlier
  `try-reload-or-restart` no-op on inactive services.
- After a live run of the new hardening script, I corrected its interface to
  default the SSH login user to `SUDO_USER` or the current user instead of
  requiring `--user` for the common single-user host case.
