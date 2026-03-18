# Lessons

- When a user widens README scope after an initial pass, update the documented surface to include every newly named repo entrypoint, not just the most obvious directories.
- When reframing the README, preserve requested navigation and coverage elements from the prior version, especially the hero screenshot, table of contents, and expanded non-AI dotfiles sections.
- When repo instructions require logging user corrections to `tasks/lessons.md`, create the file first if it does not already exist.
- When updating committed Codex config content, treat the current edited file as the source of truth for new additions, restore any deleted committed content, and do not duplicate entries while merging.
- When wrapping CLI diagnostics, do not trust exit status alone for subcommands that may still print a structured failure message; inspect the output for known error text before reporting success.
- When writing installer scripts for distro-packaged tools, do not assume the needed package exists in the user's current repositories; include a safe upstream fallback when the distro package source can vary.
- When a user points to a specific env-backed MCP checkout, prefer launching that checkout directly and verify that the default HTTP port is not already serving a different local app before keeping a URL-based MCP registration.
- When a user wants README wording to stay functionality-based, do not introduce explicit internal skill names there if the existing capability description is already accurate.
- When the user specifies a concrete new skill name, use that exact name instead of inventing a nearby alternative.
