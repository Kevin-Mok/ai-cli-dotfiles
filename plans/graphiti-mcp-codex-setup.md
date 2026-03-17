# ExecPlan: Add Graphiti MCP Setup Doc For Codex

## Checklist

- [x] Inspect the repo's existing Codex and documentation conventions.
- [x] Verify current Codex MCP configuration support in official OpenAI docs.
- [x] Verify current Graphiti MCP server setup guidance from upstream sources.
- [x] Add a focused Markdown doc for setting up Graphiti with Codex.
- [x] Keep the change scoped to the standalone doc and ExecPlan.
- [x] Verify the new files and changed content after editing.

## Assumptions

- The requested deliverable is a checked-in repo doc, not only inline setup notes.
- The target Codex surface is the current CLI/App configuration model centered on
  `~/.codex/config.toml` and `codex mcp`.
- The doc should prefer current upstream behavior even if older Graphiti examples
  still show deprecated SSE-style endpoints.

## Review Notes

- The repo already had unrelated local `README.md` edits, so the new work stays
  scoped to a standalone doc under `docs/` plus this ExecPlan.
- Verification completed with:
  - `sed -n '1,240p' docs/graphiti-mcp-codex.md`
  - `sed -n '1,220p' plans/graphiti-mcp-codex-setup.md`
  - `rg -n "graphiti-mcp-codex|Graphiti MCP Server For Codex|/sse|graphiti_mcp_server.py|http://localhost:8000/mcp/|env_vars =" docs/graphiti-mcp-codex.md plans/graphiti-mcp-codex-setup.md README.md`
  - `git status --short README.md docs/graphiti-mcp-codex.md plans/graphiti-mcp-codex-setup.md`
