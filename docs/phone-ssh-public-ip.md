# SSH From Your Phone Over Public IP

This repo now includes `scripts/executable_setup-phone-ssh.sh` to harden an
SSH server for direct phone access over a public IP.

What it changes:

- moves SSH to a non-default port
- disables password and keyboard-interactive login
- keeps public-key login enabled
- opens the chosen port in `ufw` or `firewalld` when one is active

What it does not change:

- router port forwarding
- ISP or carrier NAT restrictions
- dynamic DNS

## Prerequisites

- `sshd` is installed on the target machine
- your phone SSH client has a public/private keypair
- the target login user has that public key in `~/.ssh/authorized_keys`, or you
  will pass `--public-key /path/to/phone.pub`
- your router forwards a TCP port to this machine, or the machine already has a
  directly reachable public IP

If your ISP uses CGNAT and does not give you a real inbound public IP, raw SSH
by public IPv4 address will not work until you solve that upstream.

## Setup

Run the setup script normally. It will prompt for `sudo` and re-exec itself as
root. Replace `22229`, `kevin`, and the public-key path with your real values:

```bash
./scripts/executable_setup-phone-ssh.sh \
  --port 22229 \
  --user kevin \
  --public-key /path/to/phone.pub
```

Safer cutover if you want to keep `22` open while testing:

```bash
./scripts/executable_setup-phone-ssh.sh \
  --port 22229 \
  --user kevin \
  --public-key /path/to/phone.pub \
  --keep-port-22
```

The script writes:

- `/etc/ssh/sshd_config.d/80-phone-remote-access.conf`
- `/etc/systemd/system/ssh.socket.d/listen.conf` when `ssh.socket` is enabled or active

It validates the resulting config with `sshd -t` before reloading the SSH
service, and it creates `/run/sshd` first when that runtime directory is
missing. On systems using `ssh.socket`, it also updates the systemd
`ListenStream` entries so the custom port actually opens. On systems not using
socket activation, it enables and starts `ssh.service` if that service was
inactive.

## Router Step

Forward the same external TCP port on your router to this machine's LAN IP and
the same internal port.

Example:

- external `22229/tcp` -> `192.168.1.50:22229`

## Verify

1. Turn off Wi-Fi on your phone so you are not testing from inside the LAN.
2. Connect over cellular data with the public IP:

```bash
ssh -p 22229 kevin@PUBLIC_IP
```

3. Confirm the login succeeds without any password prompt.
4. If you used `--keep-port-22`, rerun the script without that flag after the
   custom port works.

## Extra Hardening Against SSH Spam

After the basic remote-access setup is working, apply the stricter SSH
hardening layer:

```bash
./scripts/executable_harden-phone-ssh.sh --port 22229
```

This writes:

- `/etc/ssh/sshd_config.d/81-phone-ssh-hardening.conf`

What it tightens:

- restricts SSH login to the chosen user with `AllowUsers`
- forces `AuthenticationMethods publickey`
- keeps password and keyboard-interactive auth disabled
- lowers `MaxAuthTries`
- shortens `LoginGraceTime`
- limits unauthenticated connection bursts with `MaxStartups`

Tradeoff:

- if you use SSH for any user other than the chosen one, this script will block
  those other SSH logins until you widen the rule
- agent forwarding is disabled by this hardening layer

If you need a different SSH login user, pass it explicitly:

```bash
./scripts/executable_harden-phone-ssh.sh --user kevin --port 22229
```

Quick verification:

```bash
sudo sshd -T | grep -E '^(allowusers|authenticationmethods|passwordauthentication|kbdinteractiveauthentication|maxauthtries|logingracetime|maxstartups) '
```

## If You Still Get `Connection refused`

Run the host-side doctor:

```bash
./scripts/executable_doctor-phone-ssh.sh --port 22229
```

What it tells you:

- whether `sshd` is effectively configured for `22229`
- whether `ssh.socket` is still forcing the listener to port `22`
- whether the host is actually listening on `22229`
- whether `ufw` or `firewalld` appears to allow the port

Interpretation:

- if the doctor says nothing is listening on `22229`, the problem is still on
  the host
- if the doctor says the host is listening on `22229`, the remaining likely
  causes are router forwarding, wrong LAN target IP, or CGNAT

## Risks And Notes

- Changing the SSH port reduces background scans and log noise. It is not the
  main security control.
- The actual hardening comes from disabling password login and using SSH keys.
- If another `sshd` config file still defines a different `Port`, SSH may keep
  listening there too. Check `sudo sshd -T | grep '^port '` if needed.
- If your distro uses `ssh.socket`, the actual listening ports come from
  systemd socket activation. This workflow now writes a drop-in so the custom
  port is applied there too.
- If your public IP changes often, add dynamic DNS or use the current IP each
  time.

## Rollback

Remove the managed config and reload SSH:

```bash
sudo rm /etc/ssh/sshd_config.d/80-phone-remote-access.conf
sudo rm -f /etc/systemd/system/ssh.socket.d/listen.conf
sudo systemctl daemon-reload
sudo systemctl restart ssh.socket 2>/dev/null || true
sudo systemctl reload ssh || sudo systemctl reload sshd
```
