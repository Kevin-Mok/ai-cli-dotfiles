# Graphiti MCP Server For Codex

Checked against the working local setup on 2026-03-17.

## Working Local Setup

This machine uses Graphiti over `stdio` from
`/home/kevin/coding/graphiti/mcp_server` and keeps runtime settings in the
local `.env` file in that checkout.

Add this block to `~/.codex/config.toml`:

```toml
[mcp_servers.graphiti]
command = "uv"
args = [
  "run",
  "main.py",
  "--transport",
  "stdio",
  "--database-provider",
  "neo4j",
  "--model",
  "qwen3:14b",
]
cwd = "/home/kevin/coding/graphiti/mcp_server"
startup_timeout_sec = 120
tool_timeout_sec = 120
```

Why this setup works here:

- Graphiti loads `/home/kevin/coding/graphiti/mcp_server/.env` on startup, so
  Codex does not need the Neo4j or model credentials duplicated.
- `http://localhost:8000/mcp/` is not reliable on this machine because another
  local app is already bound to host port `8000`.
- The upstream Dockerized `graphiti-mcp` service also wants host port `8000`,
  so the practical local split is: keep Neo4j running, but let Codex launch
  Graphiti itself with `stdio`.
- Neo4j must already be reachable on `localhost:7687` before Codex starts the
  Graphiti server.

## Validation

1. Make sure Neo4j is running on `localhost:7687`.
2. Manually test the Graphiti server:

```bash
cd /home/kevin/coding/graphiti/mcp_server
uv run main.py --transport stdio --database-provider neo4j --model qwen3:14b
```

3. Restart Codex and confirm the MCP registration:

```bash
codex mcp list
codex mcp get graphiti --json
```

## Troubleshooting

- If Graphiti logs `Failed to establish connection` for `127.0.0.1:7687`, Neo4j
  is not reachable yet.
- If Codex reports that Graphiti timed out after `120` seconds, verify Neo4j
  first and then confirm the local model endpoint is available.
- If you want the default FalkorDB-based setup instead, remove
  `--database-provider neo4j` from the MCP args and follow the upstream Docker
  flow instead of this repo-local configuration.

## Sources

- OpenAI Codex config reference:
  https://developers.openai.com/codex/config-reference/
- Local Graphiti checkout:
  `/home/kevin/coding/graphiti/mcp_server`
