# ExecPlan: Add Manual Command Script Handoff Guidance

## Checklist

- [x] Review the current AGENTS files, README sync rule, and durable-memory files.
- [x] Add the manual-command handoff rule to the AGENTS documents that guide Codex behavior here.
- [x] Update `README.md` so the AI operating-surface docs mention the new handoff expectation.
- [x] Record the durable preference in `dot_agents/skills/feedback-memory/feedback.log` and `tasks/lessons.md`.
- [x] Verify the diff is limited to the intended instruction and documentation files.

## Assumptions

- The request is to change repo-tracked agent guidance, not runtime shell or app behavior.
- The rule applies when Codex needs the user to run commands manually instead of executing them directly.
- When elevation is required, the handoff should include an explicit `sudo` invocation for the generated script.

## Review

- Added a new "Script Manual Commands" subsection to both `AGENTS.md` and `dot_codex/AGENTS.md`.
- Synced `README.md` so the AI operating-layer description mentions scripted manual handoffs with explicit `sudo` guidance.
- Logged the durable preference in both `dot_agents/skills/feedback-memory/feedback.log` and `tasks/lessons.md`.
