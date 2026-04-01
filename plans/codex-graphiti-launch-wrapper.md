# ExecPlan: Codex Graphiti Launch Wrapper

## Checklist

- [x] Confirm the existing Codex and Graphiti launch points in the repo.
- [x] Add a failing test that proves the launcher starts the Graphiti background command before delegating to the real `codex` binary.
- [x] Implement a `codex` wrapper script in `scripts/` that starts the requested Graphiti command only when it is not already running.
- [x] Update the root `README.md`, Graphiti documentation, and smoke-test checklist so the launcher behavior and `stdio` caveat stay truthful.
- [x] Run focused verification for the new script, test, and docs references.

## Assumptions

- The user wants a repo-tracked launcher change, not a one-off manual shell command.
- Shadowing the real `codex` binary with a script installed via `~/scripts` is acceptable because that path already precedes the fnm-managed Node bin directory in fish.
- A background `--transport stdio` process can satisfy the user’s explicit request to keep the command running, even though Codex still launches its own separate stdio MCP child for actual tool communication.

## Review Notes

- `dot_codex/config.toml` already defines the same Graphiti MCP command for Codex-managed stdio startup.
- The wrapper must therefore be explicit that the background process is a launch-time sidecar, not the MCP process Codex talks to.
- Verification completed with:
  - `bash tests/scripts/executable_codex_test.sh`
  - `bash scripts/executable_codex --help`
