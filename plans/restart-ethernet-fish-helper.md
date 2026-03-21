# ExecPlan: Add Fish Ethernet Restart Helper

## Summary

Add a fish function named `restart_ethernet` that runs the existing
`nmcli connection down/up` sequence for the wired connection, and add an
`RIN` abbreviation that expands to that function.

## Assumptions

1. The intended default NetworkManager connection name is
   `netplan-enp42s0`.
2. The user wants a reusable fish helper in tracked dotfiles rather than
   a one-off shell script.
3. An executable fish harness is sufficient verification for this shell
   helper without adding a permanent repo test file.

## Plan

- [x] Add `dot_config/fish/functions/restart_ethernet.fish` with a
  default connection name, optional override argument, and minimal error
  handling.
- [x] Add `abbr RIN "restart_ethernet"` to
  `dot_config/fish/config.fish.tmpl` near the existing fish function
  abbreviations.
- [x] Verify the function loads in fish and the abbreviation is declared
  as expected with a non-destructive harness.

## Review

- Added `restart_ethernet` as a dedicated fish helper that defaults to
  `netplan-enp42s0`, accepts an optional first argument to override the
  connection name, checks that `nmcli` exists, and stops if the
  `connection down` step fails.
- Added `abbr RIN "restart_ethernet"` alongside the existing
  function-oriented abbreviations in `dot_config/fish/config.fish.tmpl`.
- Verified with:
  - `fish --no-config -n dot_config/fish/functions/restart_ethernet.fish`
  - a mocked `sudo`/`nmcli` fish harness that produced:
    - `connection down custom-conn`
    - `connection up custom-conn`
  - `rg -n '^abbr RIN "restart_ethernet"$' dot_config/fish/config.fish.tmpl`
