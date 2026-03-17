# KM's AI CLI Workflow Dotfiles

<p align="center">
  <img src="ai-cli-workflow.png"
       alt="Multi-agent AI CLI workflow across Codex, Claude, skills, and AGENTS files"
       width="100%">
</p>

This repo is a `chezmoi`-managed Linux config repo, but the
main workflow documented here is the AI CLI stack shown in
the screenshot above: parallel agent work in the terminal,
shared instruction files, and tracked config for Codex,
Claude, and reusable agent skills. In practice, this setup
improves my agentic engineering a lot because it gives the
agents a stricter operating model, faster access to tools,
and reusable workflows that stay versioned with the rest of
my environment.

The center of gravity is the instruction chain and config
surface around `AGENTS.md`, `AGENTS.repo.md`,
`dot_codex/AGENTS.md`, `dot_codex/config.toml`,
`dot_claude/settings.json`, and `dot_agents/skills/`.

## Table of Contents
- [Workflow At A Glance](#workflow-at-a-glance)
- [Instruction Chain](#instruction-chain)
- [AI CLI Surfaces](#ai-cli-surfaces)
- [Why This Improves Agentic Engineering](#why-this-improves-agentic-engineering)
- [Daily Workflow](#daily-workflow)
- [Sync And Apply](#sync-and-apply)
- [Rest Of Repo](#rest-of-repo)
  - [Shells And Shared Shortcuts](#shells-and-shared-shortcuts)
  - [Editor, Terminal, And Media](#editor-terminal-and-media)
  - [Window Manager And Desktop UI](#window-manager-and-desktop-ui)
  - [Productivity And File Management](#productivity-and-file-management)
  - [Scripts, Assets, And Machine-Specific State](#scripts-assets-and-machine-specific-state)

## Workflow At A Glance

The README now focuses on the repo area highlighted by the
left-side tree in the screenshot:

```text
AGENTS.md
AGENTS.repo.md
dot_agents/
dot_claude/
dot_codex/
```

Those files and directories define the AI CLI workflow:

- `AGENTS.md` is the reusable cross-repo baseline for AI
  assistants.
- `AGENTS.repo.md` is the repo-local pointer that says
  `dot_codex/AGENTS.md` is authoritative for Codex here.
- `dot_codex/AGENTS.md` is the canonical merged instruction
  document for this repository, which makes the agent behave
  more like a disciplined engineering teammate than a loose
  autocomplete layer.
- `dot_codex/config.toml` tracks the Codex model, reasoning
  level, trusted projects, MCP servers, and TUI status line
  so the terminal agent starts with better defaults instead
  of re-learning the environment every session.
- `dot_claude/settings.json` tracks Claude-side permissions,
  model selection, and enabled plugins so Claude can operate
  with less permission friction in the same stack.
- `dot_agents/skills/` tracks reusable local skills for
  commit planning, browser automation, screenshot capture,
  GitHub CI repair, OpenAI docs lookup, PDF work, image
  generation, and transcription.

## Instruction Chain

For Codex work in this repo, the effective precedence is:

1. Active user and developer instructions in the session.
2. `dot_codex/AGENTS.md` as the canonical Codex source of
   truth for this repository.
3. `AGENTS.md` as the shared baseline.
4. `AGENTS.repo.md` as the repo-local pointer and
   clarification layer.
5. Any stricter nested `AGENTS.md` files under subdirectories.
6. `AGENTS.override.local.md` for untracked local-only
   strict additions.

That means the root AGENTS files still matter, but the
effective repo-specific behavior is centralized in
`dot_codex/AGENTS.md` so the local Codex setup has one
authoritative document to follow.

## AI CLI Surfaces

### `AGENTS.md`

Defines the reusable baseline across repositories:

- precedence rules
- plan-mode expectations
- verification and testing standards
- code-change hygiene
- completion criteria

### `AGENTS.repo.md`

Keeps the repo-local rule simple and explicit: after reading
the shared baseline, Codex should treat
`dot_codex/AGENTS.md` as authoritative when guidance
overlaps.

### `dot_codex/AGENTS.md`

This is the repo's real Codex playbook. It merges the shared
baseline, local addenda, and recent cross-repo guidance into
one tracked document. It also carries repo-specific behavior
such as:

- creating and maintaining ExecPlans in `plans/`
- starting bug work with a reproducer
- writing prompt requests to `prompts/`
- keeping changes small, verified, and reviewable

### `dot_codex/config.toml`

Tracks the Codex runtime configuration, including:

- default model and reasoning effort
- per-project trust entries
- persistent developer instructions
- MCP server registrations
- TUI notifications and status line settings

### `dot_claude/settings.json`

Tracks the Claude-side environment:

- permission allowlist for file, web, and shell actions
- model selection
- enabled plugins
- extra readable directories

### `dot_agents/skills/`

Stores focused reusable workflows for common agent tasks.
The current tracked local skills cover commit planning,
browser automation and screenshot capture, GitHub PR and CI
repair, OpenAI docs lookup, PDF handling, image generation,
and transcription.

This makes `dot_agents` the lightweight skill layer beside
the heavier instruction and CLI-config layers in
`dot_codex` and `dot_claude`.

## Why This Improves Agentic Engineering

This config materially improves my agentic engineering
because it removes a lot of the normal slop around terminal
agents:

- `dot_codex/AGENTS.md` pushes Codex toward plan-first,
  verification-heavy behavior with smaller diffs, explicit
  repro steps, and tighter docs coupling.
- `dot_codex/config.toml` gives Codex stronger defaults up
  front: `gpt-5.4`, `xhigh` reasoning, trusted project
  mappings, MCP servers, and a status line that keeps the
  session legible while I work.
- `dot_claude/settings.json` reduces tool friction by
  pre-allowing the read, web, and shell actions that come up
  all the time in real repo work.
- `dot_agents/skills/` turns recurring jobs into reusable
  workflows, so I do not need to keep re-explaining how to
  inspect CI, drive a browser, read PDFs, look up OpenAI
  docs, or transcribe media.
- Because all of this lives in `chezmoi`, the behavior is
  reproducible: the same instruction stack, permissions, and
  skills follow the environment instead of living as fragile
  local drift.

The result is not just "AI tools installed on my machine."
It is a versioned operating environment that makes agents
more autonomous, more consistent, and more useful for real
engineering work.

## Daily Workflow

The screenshot hero reflects the workflow this repo is set up
to support:

1. Open a repo in the terminal and let the active agent read
   the AGENTS chain before making changes.
2. Use Codex with the tracked `dot_codex` config and the
   repo-specific `dot_codex/AGENTS.md` instructions.
3. Run parallel agent work when needed: explore, document,
   implement, and validate in separate panes or sessions.
4. Use Claude with the tracked `dot_claude/settings.json`
   when that tool is part of the workflow.
5. Reuse skills from `dot_agents/skills/` for repetitive
   higher-level tasks such as commit planning, browser
   automation, docs lookup, CI repair, and media handling.
6. Record execution plans in `plans/` for non-trivial work so
   implementation and documentation stay aligned.

The point of this repo is not just "AI config files exist";
it is that the instruction stack, CLI settings, permissions,
and reusable workflows are all versioned together in a way
that makes the agents noticeably stronger day to day.

## Sync And Apply

This repo is still managed with `chezmoi`, so the normal
workflow is:

1. Edit tracked files here.
2. Run `chezmoi apply` to push changes into `$HOME`.
3. Use `chezmoi diff` when you want to inspect pending
   changes before applying them.

For the AI CLI surfaces above, that typically means tracking
changes to:

- `~/.codex/config.toml`
- `~/.claude/settings.json`
- `~/.agents/skills/` for installed local skills
- any AGENTS files or skill files you want versioned

## Rest Of Repo

The rest of the repository is still a full desktop-dotfiles
setup, not just an AI CLI config repo. The major non-AI
surfaces break down like this.

### Shells And Shared Shortcuts

- `dot_bashrc` and `dot_zshrc` keep the fallback shells in
  sync around shared aliases, `xset` repeat rate,
  `xmodmap`, `wal` colors, and the usual shell-framework
  hooks.
- `aliases/key_aliases.tmpl`, `aliases/key_dirs.tmpl`, and
  `aliases/key_files.tmpl` are the canonical shortcut layer.
  `scripts/executable_sync-shortcuts` regenerates shell
  aliases, fish abbreviations, and ranger mappings from
  those sources.
- `dot_config/fish/config.fish.tmpl` is the main interactive
  shell setup. It wires in prompt and path configuration,
  auto-syncs shortcuts, starts X on login when appropriate,
  and loads the large helper set under
  `dot_config/fish/functions/`.
- `dot_config/fish/completions/` adds project-specific and
  tool-specific completions for commands like `kubectl`,
  `minikube`, `pass`, `timetrace`, and `watson`.

### Editor, Terminal, And Media

- `dot_config/kitty/kitty.conf` and
  `dot_config/st/config.def.h.tmpl` share the themed
  terminal layer, including Nerd Font choices, `wal` color
  integration, opacity, and clipboard behavior.
- `dot_tmux.conf` is the multiplexing layer: custom prefix,
  mouse mode, TPM plugins, Powerline-style status, and
  copy-mode mappings that push selections to `xclip`.
- `dot_vimrc.tmpl` plus `dot_config/nvim/init.vim` define
  the main editing environment across Vim and Neovim, with
  the plugin list, language-specific autocommands, and the
  leader mappings for git, formatting, folds, and navigation.
- `dot_config/mpv/`, `dot_config/zathura/`, and
  `dot_config/neofetch/` round out the terminal-centric app
  stack for media playback, PDF reading, and system info.

### Window Manager And Desktop UI

- `dot_xinitrc.tmpl`, `dot_Xresources.tmpl`, and the
  `dot_Xmodmap*` variants control X startup, DPI and font
  choices, keyboard remaps, `wal` wallpaper theming, and the
  host-specific differences between desktop, laptop, and VM
  setups.
- `dot_config/i3/config.tmpl` is the main desktop control
  plane: workspace movement, app assignments, launcher
  bindings, display and audio shortcuts, layout control, and
  the external hands-free toggle binding on `Pause`.
- `dot_config/i3blocks/` and its script directory provide
  the status bars for primary and secondary displays, with
  blocks for things like battery, wifi, volume, Spotify,
  temperature, and crypto or ticker data.
- `dot_config/dunst/dunstrc` and `dot_config/picom/picom.conf`
  shape the notification and compositing layer, while other
  app-specific configs under `dot_config/` cover tools like
  `MangoHud`, `Vesktop`, `Code`, and `Cursor`.

### Productivity And File Management

- `dot_taskrc` and `dot_taskopenrc` set up Taskwarrior and
  Taskopen with contexts, urgency tuning, sync targets, and
  the preferred note or annotation workflow.
- `dot_config/ranger/` contains the file-manager workflow:
  custom commands, fzf helpers, preview logic, plugins, and
  the shared key-mapping layer generated from the aliases
  templates.
- `dot_config/neomutt/neomuttrc` and `dot_config/msmtp/config`
  cover terminal email, while `dot_config/zathura/zathurarc`
  keeps the reading stack aligned with the rest of the
  theme.
- `dot_config/mgba/` and `dot_minikube/config/config.json`
  show the broader pattern of app-specific config managed in
  the same repo, including emulator settings and local
  Kubernetes defaults.

### Scripts, Assets, And Machine-Specific State

- `scripts/` holds the automation layer behind the desktop:
  wallpaper shuffling, `dmenu` helpers, audio sink changes,
  pass integration, package installation, finance or status
  scripts, backup helpers, and small terminal utilities.
- `scripts/colors/` and `txt/` hold the supporting assets:
  terminal art, package lists, backup exclude files, TeX
  cleanup inputs, USB notes, and other small operational
  datasets.
- `dot_config/chezmoi/chezmoi-template.toml.tmpl` is the
  host-data entrypoint for machine-specific toggles such as
  `gui`, `ext_kb`, and `linux_os`, which then feed the
  template logic across the repo.
- `private_dot_calcurse/`, `private_dot_gnupg/`, and
  `dot_ssh/` cover the sensitive or machine-population side
  of the setup, alongside config files like `msmtp` or
  `taskrc` that should be treated carefully when syncing
  credentials.

That broader dotfiles surface is still substantial, but the
README stays centered on the AI CLI workflow because that is
the most distinctive and actively evolving part of the repo
right now.
