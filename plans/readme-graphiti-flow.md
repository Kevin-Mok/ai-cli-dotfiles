# ExecPlan: Integrate Graphiti Flow Into README

## Checklist

- [x] Read the current README structure and the checked-in Graphiti setup doc.
- [x] Identify where Graphiti belongs in the README narrative so it reads as part of the operating environment instead of an isolated concept.
- [x] Update the README table of contents, wording, and ordering to explain how Graphiti is used and where the setup doc lives.
- [x] Add a dedicated ExecPlan for this README update and keep it in the same commit.
- [x] Verify the README still flows from high-level operating model to concrete Graphiti usage and setup.

## Assumptions

- The README should stay centered on the four-Codex operating environment, not turn into a full Graphiti manual.
- The detailed setup steps belong in `docs/graphiti-mcp-codex.md`, while the README should explain why Graphiti exists here and point readers to the doc.
- Graphiti should be described as one part of the Codex operating layer, not as a separate product pitch.

## Review Notes

- The previous Graphiti section explained why Graphiti was conceptually useful, but it did not tell readers how it is actually used in this repo or where the concrete setup lives.
- The updated README now:
  - references `docs/graphiti-mcp-codex.md` directly
  - explains the repo-local `stdio + neo4j` setup at a high level
  - ties Graphiti back to the tracked Codex config and the four-Codex workflow
  - uses a more concrete section title and table-of-contents entry
