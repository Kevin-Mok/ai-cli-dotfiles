# Windows Install Agent Surface Script Plan

## Summary

This plan defines the final Windows workflow for installing the repo-managed
agent surface globally from this repo. The script does not bootstrap another
repo. Instead, it treats this checkout as the `chezmoi` source of truth and
applies the tracked source state into the current user's home directory.

The script name is:

- `scripts/executable_install-agent-surface.ps1`

## Intended Behavior

1. Resolve the repo root from the script location.
2. Ensure `chezmoi` is available.
3. If `chezmoi` is missing and the user passed `-InstallChezmoi`, install it
   through the official Windows PowerShell installer flow.
4. Ensure a usable `chezmoi` config exists.
   - If the live config is missing, render the tracked
     `dot_config/chezmoi/chezmoi-template.toml.tmpl`.
   - For `-DryRun`, use a temporary rendered config instead of writing the
     live config file.
5. For real apply runs, request Windows elevation through a UAC prompt when
   the current PowerShell session is not already elevated.
6. Run `chezmoi` against this repo as the source:
   - dry run: `chezmoi -S <repo> apply -n -v`
   - real apply: `chezmoi -S <repo> apply`
7. Print the exact command being run so the operator can verify the flow.

## Why Elevation Matters

This repo manages the `superpowers` install as a symlink target under the
global agent surface. On Windows, creating that symlink can require elevated
rights or Developer Mode. The script should therefore elevate for real apply
runs before `chezmoi apply` executes.

If symlink creation still fails after elevation, the script should return a
clear message telling the operator to enable Windows Developer Mode or grant
symlink privileges.

## Public Interface

Supported flags:

- `-DryRun`
- `-InstallChezmoi`
- `-Help`

The script should not require a target repo path. The repo containing the
script is the source.

## Verification Flow

1. `-Help` should describe the global install/apply workflow.
2. `-DryRun` should preview the apply without changing home-directory files.
3. A normal run should request elevation when needed, then run global
   `chezmoi apply`.
4. After a successful apply, the live global paths should reflect the repo's
   tracked source state, including the agent surface.
