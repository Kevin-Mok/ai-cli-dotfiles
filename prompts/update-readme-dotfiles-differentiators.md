# Prompt: Update README To Emphasize Key Differentiators

Use this prompt to rewrite `README.md` so it highlights why this repo is not a generic developer dotfiles setup.

## Context Files To Include

Paste these into the prompt context before asking for the rewrite:

### Required

- `README.md`
- `AGENTS.repo.md`
- `dot_codex/AGENTS.md`
- `dot_codex/config.toml`
- a short tree or file list for `dot_agents/skills/`
- one representative plan file from `plans/`

### Optional But Useful

- a short top-level tree covering only:
  - `AGENTS.md`
  - `AGENTS.repo.md`
  - `dot_codex/`
  - `dot_agents/`
  - `plans/`
- one or two representative skill files from `dot_agents/skills/`

### Do Not Include Unless Needed

- generic shell/editor/UI config files such as `dot_bashrc`, `dot_zshrc`, `dot_tmux.conf`, `dot_vimrc.tmpl`, or broad `dot_config/` content
- large unrelated screenshots or desktop assets
- the entire repo tree

## Prompt

```md
You are an expert technical editor and positioning strategist for developer tooling.

Task:
Rewrite this dotfiles repository README so the main message is immediately clear:
this is not just a standard personal dotfiles repo, but a versioned operating environment for AI-assisted engineering centered on a four-Codex workflow.

Primary goal:
Make the README clearly communicate the repo's key points and differentiators versus normal developer dotfiles repos.

Important framing:
- Most developer dotfiles repos focus on shell tweaks, editor preferences, window manager setup, aliases, themes, and local convenience.
- This repo does include normal dotfiles, but its distinctive value is that it turns AI coding-agent behavior into tracked, reproducible infrastructure.
- The README should make that distinction obvious within the first screenful.
- The README should also function as a showcase asset for potential software engineering recruiters and freelance clients looking for software engineering work to be done.
- The tone should feel high-signal, ambitious, and operator-level, like strong "AI alpha" positioning from sharp builders on Twitter/X.
- It should sound sharper and more impressive than neutral documentation, but still stay believable and concrete.
- Be concrete. Avoid vague claims like "supercharges productivity" unless followed by a mechanism.

Core differentiators to emphasize:
1. The repo is centered on a four-Codex workflow, not just desktop personalization.
2. AI agent behavior is versioned through an instruction chain:
   - `AGENTS.md`
   - `AGENTS.repo.md`
   - `dot_codex/AGENTS.md`
3. Runtime defaults are tracked in `dot_codex/config.toml`, so each Codex session starts with consistent model, reasoning, trust, MCP, and UI settings.
4. Reusable workflows live in `dot_agents/skills/`, turning repeated AI tasks into reusable skills instead of repeated prompting.
5. Execution discipline is tracked in `plans/`, so non-trivial work stays explicit across exploration, implementation, review, and verification.
6. The productivity gain is reproducible because the whole environment is managed through `chezmoi`, rather than being trapped in one machine's local state.

What to contrast against "regular dotfiles":
- Regular dotfiles optimize the terminal, editor, shell, or desktop.
- This repo also optimizes the AI engineer.
- Regular dotfiles usually configure tools.
- This repo configures tool behavior, workflow discipline, and reusable agent capabilities.
- Regular dotfiles often capture preferences.
- This repo captures a repeatable system for shipping work with terminal agents.

Audience:
- Developers who already understand normal dotfiles repos
- People experimenting with Codex / AI coding agents
- Builders interested in agentic engineering workflows
- Software engineering recruiters evaluating technical judgment, leverage, and workflow maturity
- Freelance clients evaluating whether this setup reflects someone who can ship real software work efficiently

Writing requirements:
- Keep the README grounded, direct, and specific.
- Lead with the differentiator early.
- Use concrete mechanism over abstract benefit.
- Preserve technical credibility.
- Optimize for perceived engineering leverage, systems thinking, and operational maturity.
- Let the writing have some swagger and positioning weight, as long as each strong claim is backed by mechanism.
- Avoid marketing-speak, corporate language, and generic AI buzzwords.
- Avoid sounding like a generic OSS template.
- Avoid sounding desperate, cheesy, or like a generic sales page.
- Keep it readable for someone scanning quickly.

Desired structure:
1. Title
2. Strong opening section that explains the repo's main differentiator in 2-4 short paragraphs
3. "Why this is different from normal dotfiles" section
4. "How the system works" or equivalent section
5. "Core components" section covering AGENTS chain, Codex config, skills, and plans
6. "Four Codex workflow" section
7. `chezmoi` / reproducibility section
8. Brief note that the repo still contains traditional desktop/shell/editor dotfiles, but those are secondary

Specific instructions:
- Rewrite the intro so the first paragraph communicates the repo's real identity immediately.
- Add an explicit comparison section that contrasts this repo with ordinary dotfiles repos.
- Make the README feel like it contains practical insight gathered from real AI-tool usage, not theory.
- Make it useful for someone deciding whether to hire the repo owner as a software engineer or contractor.
- Frame the repo as evidence of how the owner thinks about leverage, repeatability, and shipping quality software with AI tools.
- Keep the existing strengths: four-Codex workflow, tracked instructions, reusable skills, stable defaults, reproducibility.
- Tighten repetition where possible.
- Preserve accuracy: do not invent tools, workflows, folders, or claims that are not supported by the provided files.
- Retain a technically literate tone.

Source material to preserve and sharpen:
- The repo is `chezmoi` managed.
- The central idea is a four-Codex workflow.
- The productivity comes from tracked instructions, tracked runtime defaults, reusable local skills, and explicit plans.
- The repo is useful because it makes AI-assisted engineering faster, more repeatable, and less dependent on fragile local state.
- The rest of the repo still contains conventional dotfiles, but that is not the main differentiator.

Output requirements:
1. Provide the full rewritten README in Markdown.
2. After the README, provide a short section called "Positioning Notes" with:
   - the top 3 messaging changes you made
   - any remaining weak spots in the README positioning
3. Do not use tables.
4. Do not use emojis.
5. Do not make up social proof, usage numbers, or performance claims.

Context files included below:

[PASTE README.md]

[PASTE AGENTS.repo.md]

[PASTE dot_codex/AGENTS.md]

[PASTE dot_codex/config.toml]

[PASTE short tree or file list for dot_agents/skills/]

[PASTE one representative plans/*.md file]
```
