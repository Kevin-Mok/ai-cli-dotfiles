# KM's Four-Codex Operating Environment

<p align="center">
  <img src="ai-cli-workflow.png"
       alt="Multi-agent AI CLI workflow across Codex, Claude, skills, and AGENTS files"
       width="100%">
</p>

**This is not a generic dotfiles repo.**

It is a `chezmoi`-managed operating environment for AI-assisted engineering built around a **four-Codex workflow**: **exploration**, **implementation**, **review/refinement**, and **verification/docs**. The shell, editor, terminal, and desktop configuration still matter, but the distinguishing value of the repo lives higher in the stack: it version-controls **how Codex behaves**, **which defaults it boots with**, **what reusable workflows it can invoke**, and **how non-trivial work stays explicit** from start to finish.

**Most dotfiles repos optimize local ergonomics.** This one also optimizes the AI engineer. Instead of relying on ad hoc prompting and machine-local state, it tracks an instruction chain, runtime defaults, reusable skills, and execution plans in source control. That turns AI usage from a personal habit into something **operational, inspectable, and repeatable**.

If you are evaluating me as a software engineer or contractor, this repo is a useful proxy for how I work: I care about **leverage**, **reproducibility**, **small reversible changes**, **verification**, and **keeping hidden state to a minimum**. The repo is not just a desktop setup. It is evidence of how I structure real software work with terminal agents.

## Table of Contents

- [Workflow At A Glance](#workflow-at-a-glance)
- [AI Layer Highlights](#ai-layer-highlights)
- [Why This Is Different From Normal Dotfiles](#why-this-is-different-from-normal-dotfiles)
- [How The System Works](#how-the-system-works)
- [Core Components](#core-components)
- [Four Codex Workflow](#four-codex-workflow)
- [Reproducibility Through Chezmoi](#reproducibility-through-chezmoi)
- [Rest Of Repo](#rest-of-repo)
  - [Shells And Shared Shortcuts](#shells-and-shared-shortcuts)
  - [Editor, Terminal, And Media](#editor-terminal-and-media)
  - [Window Manager And Desktop UI](#window-manager-and-desktop-ui)
  - [Productivity And File Management](#productivity-and-file-management)
  - [Scripts, Assets, And Machine-Specific State](#scripts-assets-and-machine-specific-state)

## Workflow At A Glance

**The screenshot above is the workflow.** The README now centers the repo area highlighted by the left-side tree: the tracked instruction chain, Codex defaults, reusable skills, and plans that make parallel terminal-agent work faster and more disciplined.

```text
AGENTS.md
AGENTS.repo.md
dot_codex/
dot_agents/
plans/
```

Those files and directories define the operating layer:

- **`AGENTS.md`:** the reusable cross-repo baseline for AI assistants.
- **`AGENTS.repo.md`:** the repo-local pointer that says `dot_codex/AGENTS.md` is authoritative for Codex here.
- **`dot_codex/AGENTS.md`:** the canonical merged instruction document for this repository, which pushes Codex toward plan-first, verification-heavy engineering behavior.
- **`dot_codex/config.toml`:** the tracked runtime config for model defaults, reasoning level, trust boundaries, MCP servers, and session behavior.
- **`dot_agents/skills/`:** the reusable workflow layer for higher-level jobs like CI repair, browser automation, screenshots, docs lookup, PDF work, image generation, transcription, and commit planning.
- **`plans/`:** the place where non-trivial work becomes explicit, checklisted, reviewable, and easier to validate.

The screenshot still reflects a broader terminal-agent environment, but the main story here is the **Codex operating layer** that makes the workflow reproducible.

## AI Layer Highlights

The repo now treats the AI operating layer as documentation-worthy
surface area, not hidden implementation detail. Repo-local guidance
explicitly requires `README.md` updates whenever these paths
materially change:

```text
AGENTS.md
AGENTS.repo.md
dot_codex/
dot_agents/
plans/
```

That matters because the most interesting changes here are often not
traditional dotfile tweaks. They are workflow upgrades.

- **Instruction chain upgrades:** changes in `AGENTS.md`,
  `AGENTS.repo.md`, or `dot_codex/AGENTS.md` can tighten planning,
  verification, bug-fix discipline, and repo-specific behavior.
- **Runtime default upgrades:** `dot_codex/config.toml` versions the
  model, reasoning, trust, MCP, and session defaults that every new
  Codex pane inherits.
- **Skill surface growth:** `dot_agents/skills/` packages recurring
  jobs into reusable local capabilities instead of one-off prompts.
- **Execution discipline:** `plans/` makes non-trivial tasks
  explicit, reviewable, and easier to validate after the fact.

Keeping the README tied to those changes makes the repo easier to
evaluate: the high-leverage additions stay visible instead of
disappearing into internal docs and folder trees.

## Why This Is Different From Normal Dotfiles

Regular dotfiles repos usually do a familiar set of jobs well: shell aliases, editor preferences, window manager setup, themes, and local convenience.

**This repo still does that, but that is not the main story.**

The main story is that it treats AI-assisted engineering as something worth configuring with the same seriousness people usually reserve for shells and editors. In practice, that means:

- **It does not just configure tools; it configures tool behavior.**
- **It does not just store preferences; it stores operating rules.**
- **It does not just make one machine comfortable; it makes agent workflows reproducible.**
- **It does not just save keystrokes; it reduces re-prompting, context drift, and fragile local state.**

That is the difference between a personalized Linux setup and a **versioned engineering environment**.

## How The System Works

The part of the repo that matters most looks like this:

```text
AGENTS.md
AGENTS.repo.md
dot_codex/
dot_agents/
plans/
```

Those files and directories form the operating layer for the workflow:

1. **The AGENTS chain** defines how Codex should behave in this repo.
2. **`dot_codex/config.toml`** defines startup defaults, trust boundaries, and session behavior.
3. **`dot_agents/skills/`** packages recurring work into reusable local skills.
4. **`plans/`** keeps larger tasks explicit, checklisted, and reviewable.
5. **`chezmoi`** makes the whole setup reproducible instead of trapping it in one machine's local state.

Mechanically, this matters because Codex CLI is designed to read AGENTS-style instruction files into context and inherit defaults from `~/.codex/config.toml`. That means the repo is not merely documenting the workflow; it is **actively shaping how each session starts and behaves**.

## Core Components

### 1. Instruction chain

`AGENTS.md`, `AGENTS.repo.md`, and `dot_codex/AGENTS.md` are the behavioral backbone.

- **`AGENTS.md`** holds the shared baseline.
- **`AGENTS.repo.md`** tells Codex to treat `dot_codex/AGENTS.md` as authoritative for this repo.
- **`dot_codex/AGENTS.md`** is the canonical working document for this codebase.

That canonical document is not generic philosophy. It encodes concrete engineering behavior:

- **Plan mode for non-trivial work:** larger tasks should be broken into explicit steps, assumptions, risks, and verification, instead of being handled as one long improvisation. In practice, that means work should move through an ExecPlan in `plans/` when the task is big enough that sequencing and review matter.
- **Failing reproducers before bug fixes:** bug work should start with a test or other executable proof of failure, so the fix is grounded in observed behavior instead of guesswork. The target is to make the problem fail for the right reason first, then fix it, then keep that reproducer as a regression check.
- **Explicit verification before done:** work is not considered complete until the result is demonstrated through tests, diffs, logs, or a clear manual check. A change is not "done" because the code looks right; it is done when there is evidence that behavior matches the claim.
- **Docs updates with behavior changes:** when the workflow or behavior changes, the related documentation and plans should change with it so the repo stays truthful. If a README, plan, setup step, or operator workflow is now different, the documentation should be updated in the same change rather than deferred.
- **Small reversible diffs:** changes should be narrow, reviewable, and easy to back out, rather than broad refactors that mix multiple concerns. That pushes the work toward focused commits and away from drive-by cleanup that makes failures harder to isolate.
- **Conventional Commits:** commit history should communicate intent clearly and consistently, not leave future readers to infer what happened. A subject like `docs: expand README instruction-chain examples` is part of the system's operating discipline, not just a stylistic preference.
- **A clear definition of done:** the system defines completion as working implementation, updated supporting docs or types where needed, and enough context for another engineer to verify the result. The goal is that someone else can read the diff, run the checks, and understand why the task is actually complete.

This is where agent behavior stops being prompt folklore and becomes **versioned repo policy**.

### 2. Tracked Codex defaults

`dot_codex/config.toml` makes each Codex session start strong instead of neutral.

It tracks the default model and reasoning effort, trusted local project paths, MCP servers, notification and status-line preferences, and extra developer instructions for commit and plan hygiene. In the current config, even commit discipline is codified: plan updates should ship with related work, and commit messages should use concise Conventional Commit subjects with detailed bullet summaries in the body.

That matters because a new Codex pane inherits the same defaults immediately. **No re-briefing. No guesswork.**

### 3. Reusable local skills

`dot_agents/skills/` turns repeated prompting into reusable capabilities.

The current skill tree includes workflows for GitHub CI repair, OpenAI docs lookup, browser automation with Playwright, screenshots, PDFs, image generation, transcription, and commit planning. Several skills are packaged with `SKILL.md`, agent metadata, helper scripts, and reference material, which makes them closer to local tools than to one-off prompts.

That is one of the clearest differences from a normal dotfiles repo. Instead of re-explaining recurring work every week, the workflow is already **packaged and versioned**.

### 4. ExecPlans

`plans/` is where non-trivial work stays explicit.

A representative plan like `plans/commit-all-dirty.md` does not just say "commit the changes." It inventories the dirty worktree, groups changes into coherent commit boundaries, notes where partial staging is required inside a single file, defines verification after each step, and calls out concrete risks.

That is **execution discipline you can inspect**.

The point of keeping plans in the repo is simple: larger tasks should not live only in chat scrollback or memory.

## Four Codex Workflow

The operating model is four Codex sessions in parallel, each with a distinct job:

1. **Exploration**: read the codebase, trace behavior, inspect docs, and surface constraints before editing.
2. **Implementation**: make focused code changes once the path is clear.
3. **Review and refinement**: look for regressions, weak assumptions, and cleaner solutions.
4. **Verification and docs**: run tests, validate behavior, and keep documentation or plans aligned with the work.

This split only works because the sessions stay aligned. When every pane inherits the same instruction chain, config defaults, trust rules, and reusable skills, parallelism becomes **leverage instead of chaos**.

## Reproducibility Through Chezmoi

**The productivity gain is not trapped inside one laptop.**

This repo is `chezmoi`-managed, which means the environment itself is tracked as source state and can be applied back into `$HOME` through the standard `chezmoi` workflow. The same files that shape the Codex workflow, including AGENTS documents, Codex config, skills, aliases, templates, and supporting dotfiles, are part of a reproducible setup rather than fragile local state.

That matters for two reasons.

First, **the workflow is portable**. When the setup changes, the change is versioned.

Second, **the leverage is inspectable**. You can see exactly which instructions, defaults, packaged skills, and plans are doing the work.

Typical commands are still the usual ones:

```bash
chezmoi diff
chezmoi apply
```

The difference is what is being reproduced. It is not only shell comfort. It is the **operating environment for AI-assisted engineering**.

## Rest Of Repo

The rest of the repository is still a full desktop-dotfiles setup, not just an AI CLI config repo. The major non-AI surfaces break down like this.

### Shells And Shared Shortcuts

- **`dot_bashrc` and `dot_zshrc`:** keep the fallback shells in sync around shared aliases, `xset` repeat rate, `xmodmap`, `wal` colors, and the usual shell-framework hooks.
- **`aliases/key_aliases.tmpl`, `aliases/key_dirs.tmpl`, and `aliases/key_files.tmpl`:** form the canonical shortcut layer. `scripts/executable_sync-shortcuts` regenerates shell aliases, fish abbreviations, and ranger mappings from those sources.
- **`dot_config/fish/config.fish.tmpl`:** is the main interactive shell setup. It wires in prompt and path configuration, auto-syncs shortcuts, starts X on login when appropriate, and loads the large helper set under `dot_config/fish/functions/`.
- **`dot_config/fish/completions/`:** adds project-specific and tool-specific completions for commands like `kubectl`, `minikube`, `pass`, `timetrace`, and `watson`.

### Editor, Terminal, And Media

- **`dot_config/kitty/kitty.conf` and `dot_config/st/config.def.h.tmpl`:** share the themed terminal layer, including Nerd Font choices, `wal` color integration, opacity, and clipboard behavior.
- **`dot_tmux.conf`:** is the multiplexing layer with a custom prefix, mouse mode, TPM plugins, Powerline-style status, and copy-mode mappings that push selections to `xclip`.
- **`dot_vimrc.tmpl` plus `dot_config/nvim/init.vim`:** define the main editing environment across Vim and Neovim, with the plugin list, language-specific autocommands, and leader mappings for git, formatting, folds, and navigation.
- **`dot_config/mpv/`, `dot_config/zathura/`, and `dot_config/neofetch/`:** round out the terminal-centric app stack for media playback, PDF reading, and system info.

### Window Manager And Desktop UI

- **`dot_xinitrc.tmpl`, `dot_Xresources.tmpl`, and the `dot_Xmodmap*` variants:** control X startup, DPI and font choices, keyboard remaps, `wal` wallpaper theming, and host-specific differences between desktop, laptop, and VM setups.
- **`dot_config/i3/config.tmpl`:** is the main desktop control plane for workspace movement, app assignments, launcher bindings, display and audio shortcuts, layout control, and the external hands-free toggle binding on `Pause`.
- **`dot_config/i3blocks/` and its script directory:** provide the status bars for primary and secondary displays, with blocks for things like battery, wifi, volume, Spotify, temperature, and crypto or ticker data.
- **`dot_config/dunst/dunstrc` and `dot_config/picom/picom.conf`:** shape the notification and compositing layer, while other app-specific configs under `dot_config/` cover tools like `MangoHud`, `Vesktop`, `Code`, and `Cursor`.

### Productivity And File Management

- **`dot_taskrc` and `dot_taskopenrc`:** set up Taskwarrior and Taskopen with contexts, urgency tuning, sync targets, and the preferred note or annotation workflow.
- **`dot_config/ranger/`:** contains the file-manager workflow, including custom commands, fzf helpers, preview logic, plugins, and the shared key-mapping layer generated from the aliases templates.
- **`dot_config/neomutt/neomuttrc` and `dot_config/msmtp/config`:** cover terminal email, while `dot_config/zathura/zathurarc` keeps the reading stack aligned with the rest of the theme.
- **`dot_config/mgba/` and `dot_minikube/config/config.json`:** show the broader pattern of app-specific config managed in the same repo, including emulator settings and local Kubernetes defaults.

### Scripts, Assets, And Machine-Specific State

- **`scripts/`:** holds the automation layer behind the desktop, including wallpaper shuffling, `dmenu` helpers, audio sink changes, pass integration, package installation, finance or status scripts, backup helpers, and small terminal utilities.
- **`scripts/colors/` and `txt/`:** hold supporting assets such as terminal art, package lists, backup exclude files, TeX cleanup inputs, USB notes, and other small operational datasets.
- **`dot_config/chezmoi/chezmoi-template.toml.tmpl`:** is the host-data entrypoint for machine-specific toggles such as `gui`, `ext_kb`, and `linux_os`, which then feed template logic across the repo.
- **`private_dot_calcurse/`, `private_dot_gnupg/`, and `dot_ssh/`:** cover the sensitive or machine-population side of the setup, alongside config files like `msmtp` or `taskrc` that should be treated carefully when syncing credentials.

That broader dotfiles surface is still substantial, but the README stays centered on the **four-Codex operating environment** because that is the most distinctive and actively evolving part of the repo right now.
