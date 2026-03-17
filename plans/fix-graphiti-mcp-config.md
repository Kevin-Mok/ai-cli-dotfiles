# ExecPlan: Fix Graphiti MCP Codex Config

## Checklist

- [x] Reproduce the broken Graphiti MCP registration from the local Codex setup.
- [x] Inspect the repo Codex config and the local Graphiti checkout for the correct launch mode.
- [x] Confirm the local Graphiti server loads `mcp_server/.env` and supports `--database-provider neo4j`.
- [x] Update the repo guidance to match the working `stdio + neo4j` setup.
- [x] Record the user correction in `tasks/lessons.md`.
- [x] Verify the final working diagnosis: port `8000` is occupied by another app and Neo4j must be reachable on `localhost:7687`.
- [x] Commit only the relevant Graphiti MCP changes.

## Assumptions

- `/home/kevin/coding/graphiti/mcp_server/.env` is the intended source of truth for local Graphiti runtime settings.
- The working local setup is Codex launching Graphiti directly over `stdio`, while Neo4j runs separately on `localhost:7687`.
- This repo should prefer the `stdio` guidance because host port `8000` is not reliably available on this machine.

## Review Notes

- The original Codex MCP registration targeted `http://localhost:8000/mcp/`.
- That endpoint returned an HTML `404` from an unrelated Django app instead of an MCP response.
- The local Graphiti checkout confirmed that `src/graphiti_mcp_server.py` loads `mcp_server/.env` automatically.
- The same checkout supports `--transport stdio` and `--database-provider neo4j`, which lets Codex launch Graphiti directly without any host-port dependency.
- The remaining startup timeout was caused by Neo4j not listening on `127.0.0.1:7687` yet.
- Running the upstream Neo4j Docker Compose setup also showed that the bundled `graphiti-mcp` container could not bind host port `8000`, confirming the local port collision.
- The working resolution is:
  - keep Neo4j running on `localhost:7687`
  - let Codex launch Graphiti via `stdio`
  - avoid the Dockerized Graphiti HTTP service on this machine
