# ExecPlan: Reinforce Push-After-Commit Defaults

## Goal

Make the repo's commit-related instructions consistently state that when
Codex creates commits in this repo, it should push the active branch
after each successful commit by default unless the user explicitly says
not to.

## Assumptions

- The user's wording "commit after every push" means "push after every
  successful commit" because that matches the existing repo guidance and
  is operationally coherent.
- The change should touch both human-readable docs and the skill/agent
  surfaces that shape Codex behavior.
- Planning-only surfaces such as `commit-plan` should not perform push
  actions, but should state the default execution expectation.

## Checklist

- [x] Review the existing AGENTS and commit-skill instructions for
      current push-default wording.
- [x] Add explicit repo-level guidance in `AGENTS.repo.md`,
      `dot_codex/AGENTS.md`, and `AGENTS.md`.
- [x] Update `commit-plan`, `commit-push`, and `commit-session`, plus
      their `agents/openai.yaml` prompts, to reinforce the default.
- [x] Refresh the skill catalog and root README so the public workflow
      description matches the new instruction wording.
- [x] Record the user correction in `tasks/lessons.md` and
      `dot_agents/skills/feedback-memory/feedback.log`.
- [x] Verify the changed instruction surfaces with targeted reads and a
      diff review.
