# Prompt: Create Or Refresh A `feedback-memory` Codex Skill

Use this prompt to create or refresh a Codex skill named `feedback-memory` that persists durable user corrections and preferences across sessions via a local `feedback.log` file.

## Context Files To Include

Paste these into the prompt context before asking for the skill update:

### Required

- the existing `feedback-memory/` skill folder if it already exists
- one representative local `SKILL.md` file that matches your preferred level of structure and tone

### Optional But Useful

- local skill-creation guidance, if your repo has one
- any existing `agents/openai.yaml` for the target skill

### Do Not Include Unless Needed

- unrelated skills
- large repo trees
- broad repo docs that do not affect skills

## Prompt

```md
You are an expert Codex skill designer and maintainer.

Task:
Create or refresh a Codex skill named `feedback-memory`.

Primary goal:
Make the skill reliably carry forward durable user corrections and preferences across sessions through a plain-text `feedback.log` file stored inside the skill folder.

Core behavior to implement:
1. Create a `feedback.log` file inside the `feedback-memory` skill folder.
2. Update the skill instructions so the agent reads `feedback.log` at the start of every session before doing anything else.
3. Update the skill instructions so that whenever I give a correction or preference during a session, the agent immediately appends it to `feedback.log`.
4. Only log general preferences or corrections that should apply to future sessions.
5. Skip anything specific to the current task, one-off requests, or ephemeral context.
6. Use judgment on how much detail to include per entry:
   - brief durable preferences can be one line
   - more nuanced corrections can include one or two sentences of context

Refresh scope:
- Do a broader cleanup or refresh of the skill if it improves clarity, triggering, or usability.
- Keep the skill lean and procedural, not verbose.
- Preserve any good existing content that still helps another Codex instance use the skill well.
- Rewrite unclear or redundant sections when needed instead of layering awkward patches on top.

Skill design requirements:
- Keep the skill name as `feedback-memory` unless the existing repo has a clearly better established name for this exact behavior.
- Keep the implementation simple. Use a plain append-only `feedback.log`; do not introduce JSON, databases, or extra complexity unless the existing system already requires it.
- Make the frontmatter description strong enough that Codex can tell when to use the skill.
- In the body, give crisp instructions for:
  - reading the log before work
  - deciding whether new feedback is durable enough to log
  - appending new entries immediately when durable feedback appears
  - avoiding task-specific or temporary notes
- If the skill has user-facing metadata such as `agents/openai.yaml`, refresh it if the SKILL.md changes make it stale.
- Do not create auxiliary docs like README files unless the existing skill system explicitly requires them.

Decision rules for what to log:
- Log reusable preferences about workflow, style, review expectations, formatting, tooling habits, communication preferences, or recurring quality bars.
- Log corrections that would prevent the same mistake in future sessions.
- Do not log facts that matter only to the current ticket, branch, file, or temporary investigation.
- When unsure, bias toward logging only if the note would still be useful in a different future task.

Implementation expectations:
- Inspect the existing skill first, if present, before rewriting it.
- Reorganize the skill so another Codex instance can follow it without guessing.
- Keep instructions concise, imperative, and operational.
- Add only the minimum extra structure needed to make the workflow reliable.
- Validate the skill with the local skill-validation flow if the repo provides one.

Output requirements:
1. Update or create the full skill contents.
2. Show the final files created or changed.
3. Summarize the final trigger description and the feedback logging rules.
4. Mention any assumptions made, especially if you had to infer surrounding skill structure.
```
