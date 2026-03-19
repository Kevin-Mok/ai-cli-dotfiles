# KM's Four-Codex Operating Environment

<p align="center">
  <img src="media/ai-cli-workflow-samurai.png"
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
- [Graphiti Memory Layer](#graphiti-memory-layer)
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

- **[`AGENTS.md`][agents-baseline]:** the reusable cross-repo baseline for AI assistants.
- **[`AGENTS.repo.md`][agents-repo-pointer]:** the repo-local pointer that says [`dot_codex/AGENTS.md`][codex-agents] is authoritative for Codex here.
- **[`dot_codex/AGENTS.md`][codex-agents]:** the canonical merged instruction document for this repository, which pushes Codex toward plan-first, verification-heavy engineering behavior.
- **[`dot_codex/config.toml`][codex-config]:** the tracked runtime config for model defaults, reasoning level, trust boundaries, MCP servers, and session behavior.
- **[`dot_agents/skills/`][skills-dir]:** the reusable workflow layer for higher-level jobs like frontend design generation, redesign, premium visual polish, output enforcement, minimalist/editorial UI design, CI repair, browser automation, screenshots, docs lookup, PDF work, image generation, transcription, commit planning with bottom-line message summaries, and direct verified git shipping.
- **[`plans/`][plans-dir]:** the place where non-trivial work becomes explicit, checklisted, reviewable, and easier to validate.

The screenshot still reflects a broader terminal-agent environment, but the main story here is the **Codex operating layer** that makes the workflow reproducible.

## AI Layer Highlights

The repo now treats the AI operating layer as documentation-worthy
surface area, not hidden implementation detail. Repo-local guidance in
[`AGENTS.repo.md`][agents-repo-readme-sync]
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

- **Instruction chain upgrades:** changes in [`AGENTS.md`][agents-baseline],
  [`AGENTS.repo.md`][agents-repo-pointer], or [`dot_codex/AGENTS.md`][codex-agents] can tighten planning,
  verification, bug-fix discipline, and repo-specific behavior.
- **Runtime default upgrades:** [`dot_codex/config.toml`][codex-config] versions the
  model, reasoning, trust, MCP, and session defaults that every new
  Codex pane inherits.
- **Persistent memory via Graphiti:** the MCP layer can launch a local
  Graphiti memory service over `stdio`; the repo-local setup, validation,
  and troubleshooting live in [`docs/graphiti-mcp-codex.md`][graphiti-codex-doc].
- **Skill surface growth:** [`dot_agents/skills/`][skills-dir] packages recurring
  jobs into reusable local capabilities instead of one-off prompts.
- **Execution discipline:** [`plans/`][plans-dir] makes non-trivial tasks
  explicit, reviewable, and easier to validate after the fact.

Keeping the README tied to those changes makes the repo easier to
evaluate: the high-leverage additions stay visible instead of
disappearing into internal docs and folder trees.

## Graphiti Memory Layer

Graphiti is the memory and retrieval layer that sits beside the repo's
instruction chain, local skills, and ExecPlans. In this setup it is not
just a theoretical fit. It is a local MCP service that helps Codex keep
longer-running work coherent across sessions.

The practical use case is straightforward:

- preserve evolving facts about tasks, services, files, branches, and
  verification state instead of leaving them buried in chat scrollback
- keep provenance back to the source episodes that produced those facts,
  which matters when review or verification needs to check where a claim
  came from
- support multi-session Codex work where exploration, implementation,
  review, and docs may all need the same durable context

The local setup is intentionally repo-specific. Instead of relying on
Graphiti's default HTTP transport, the working config launches Graphiti
over `stdio` from `/home/kevin/coding/graphiti/mcp_server`, keeps
runtime settings in that checkout's `.env`, and expects Neo4j on
`localhost:7687`. That keeps the Codex-side config small and avoids the
host-port `8000` collision that already exists on this machine.

The detailed setup, validation steps, and troubleshooting notes live in
[`docs/graphiti-mcp-codex.md`][graphiti-codex-doc]. The short version is:

1. Keep Neo4j running on `localhost:7687`.
2. Let Codex launch Graphiti through the `graphiti` MCP entry in
   [`dot_codex/config.toml`][codex-config].
3. Use Graphiti as the temporal memory layer that complements AGENTS
   files, skills, and ExecPlans instead of replacing them.

That ordering matters for the four-Codex workflow because the difficult
part of parallel agent work is not just generating code. It is keeping
working state coherent across exploration, implementation, review, and
verification. Graphiti helps by making evolving context retrievable,
inspectable, and historically aware.

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
2. **[`dot_codex/config.toml`][codex-config]** defines startup defaults, trust boundaries, and session behavior.
3. **[`dot_agents/skills/`][skills-dir]** packages recurring work into reusable local skills.
4. **[`plans/`][plans-dir]** keeps larger tasks explicit, checklisted, and reviewable.
5. **`chezmoi`** makes the whole setup reproducible instead of trapping it in one machine's local state.

Mechanically, this matters because Codex CLI is designed to read AGENTS-style instruction files into context and inherit defaults from `~/.codex/config.toml`. That means the repo is not merely documenting the workflow; it is **actively shaping how each session starts and behaves**.

## Core Components

### 1. Instruction chain

[`AGENTS.md`][agents-baseline], [`AGENTS.repo.md`][agents-repo-pointer], and [`dot_codex/AGENTS.md`][codex-agents] are the behavioral backbone.

- **[`AGENTS.md`][agents-baseline]** holds the shared baseline.
- **[`AGENTS.repo.md`][agents-repo-pointer]** tells Codex to treat [`dot_codex/AGENTS.md`][codex-agents] as authoritative for this repo.
- **[`dot_codex/AGENTS.md`][codex-agents]** is the canonical working document for this codebase.

That canonical document is not generic philosophy. It encodes concrete engineering behavior:

- **Plan mode for non-trivial work:** larger tasks should be broken into explicit steps, assumptions, risks, and verification, instead of being handled as one long improvisation. In practice, that means work should move through an ExecPlan in [`plans/`][plans-dir] when the task is big enough that sequencing and review matter.
- **Failing reproducers before bug fixes:** bug work should start with a test or other executable proof of failure, so the fix is grounded in observed behavior instead of guesswork. The target is to make the problem fail for the right reason first, then fix it, then keep that reproducer as a regression check.
- **Explicit verification before done:** work is not considered complete until the result is demonstrated through tests, diffs, logs, or a clear manual check. A change is not "done" because the code looks right; it is done when there is evidence that behavior matches the claim.
- **Docs updates with behavior changes:** when the workflow or behavior changes, the related documentation and plans should change with it so the repo stays truthful. If a README, plan, setup step, or operator workflow is now different, the documentation should be updated in the same change rather than deferred.
- **Small reversible diffs:** changes should be narrow, reviewable, and easy to back out, rather than broad refactors that mix multiple concerns. That pushes the work toward focused commits and away from drive-by cleanup that makes failures harder to isolate.
- **Conventional Commits:** commit history should communicate intent clearly and consistently, not leave future readers to infer what happened. A subject like `docs: expand README instruction-chain examples` is part of the system's operating discipline, not just a stylistic preference.
- **A clear definition of done:** the system defines completion as working implementation, updated supporting docs or types where needed, and enough context for another engineer to verify the result. The goal is that someone else can read the diff, run the checks, and understand why the task is actually complete.

This is where agent behavior stops being prompt folklore and becomes **versioned repo policy**.

### 2. Tracked Codex defaults

[`dot_codex/config.toml`][codex-config] makes each Codex session start strong instead of neutral.

It tracks the default model and reasoning effort, trusted local project paths, MCP servers, notification and status-line preferences, and extra developer instructions for commit and plan hygiene. In the current config, even commit discipline is codified: plan updates should ship with related work, and commit messages should use concise Conventional Commit subjects with detailed bullet summaries in the body.

That matters because a new Codex pane inherits the same defaults immediately. **No re-briefing. No guesswork.**

One concrete example is the repo-local Graphiti MCP entry: Codex can launch the
local Graphiti checkout over `stdio`, while the detailed setup and validation
workflow lives in [`docs/graphiti-mcp-codex.md`][graphiti-codex-doc].

### 3. Reusable local skills

[`dot_agents/skills/`][skills-dir] turns repeated prompting into reusable capabilities.

The current skill tree includes workflows for frontend design generation, UI redesign, premium visual polish, output enforcement, minimalist/editorial interface design, GitHub CI repair, OpenAI docs lookup, browser automation with Playwright, screenshots, PDFs, image generation, transcription, commit planning with a bottom-of-response commit-subject summary, and direct commit-and-push execution for ready changes. Several skills are packaged with `SKILL.md`, agent metadata, helper scripts, reference material, or explicit `SOURCE.md` provenance notes, which makes them closer to local tools than to one-off prompts. The frontend design skill cluster was imported from [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) with permission, and each imported skill directory includes a `SOURCE.md` file that records the upstream path and commit.

That is one of the clearest differences from a normal dotfiles repo. Instead of re-explaining recurring work every week, the workflow is already **packaged and versioned**.

### 4. ExecPlans

[`plans/`][plans-dir] is where non-trivial work stays explicit.

A representative plan like [`plans/commit-all-dirty.md`][plan-commit-all-dirty] does not just say "commit the changes." It inventories the dirty worktree, groups changes into coherent commit boundaries, notes where partial staging is required inside a single file, defines verification after each step, and calls out concrete risks.

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

## License

This repository is licensed under the [MIT License](LICENSE).

You may use, modify, and redistribute it, including for commercial work, as
long as the copyright and license notice stay with copies or substantial
portions of the material. If a file or subdirectory carries its own license
notice, that specific notice controls for that material.

## Rest Of Repo

The rest of the repository is still a full desktop-dotfiles setup, not just an AI CLI config repo. The major non-AI surfaces break down like this.

### Shells And Shared Shortcuts

- **[`dot_bashrc`][dot-bashrc] and [`dot_zshrc`][dot-zshrc]:** keep the fallback shells in sync around shared aliases, `xset` repeat rate, `xmodmap`, `wal` colors, and the usual shell-framework hooks.
- **[`aliases/key_aliases.tmpl`][aliases-key-aliases], [`aliases/key_dirs.tmpl`][aliases-key-dirs], and [`aliases/key_files.tmpl`][aliases-key-files]:** form the canonical shortcut layer. [`scripts/executable_sync-shortcuts`][sync-shortcuts] regenerates shell aliases, fish abbreviations, and ranger mappings from those sources.
- **[`dot_config/fish/config.fish.tmpl`][fish-config]:** is the main interactive shell setup. It wires in prompt and path configuration, auto-syncs shortcuts, starts X on login when appropriate, and loads the large helper set under [`dot_config/fish/functions/`][fish-functions].
- **[`dot_config/fish/completions/`][fish-completions]:** adds project-specific and tool-specific completions for commands like `kubectl`, `minikube`, `pass`, `timetrace`, and `watson`.

### Editor, Terminal, And Media

- **[`dot_config/kitty/kitty.conf`][kitty-conf] and [`dot_config/st/config.def.h.tmpl`][st-config]:** share the themed terminal layer, including Nerd Font choices, `wal` color integration, opacity, and clipboard behavior.
- **[`dot_tmux.conf`][tmux-conf]:** is the multiplexing layer with a custom prefix, mouse mode, TPM plugins, Powerline-style status, and copy-mode mappings that push selections to `xclip`.
- **[`dot_vimrc.tmpl`][vimrc] plus [`dot_config/nvim/init.vim`][nvim-init]:** define the main editing environment across Vim and Neovim, with the plugin list, language-specific autocommands, and leader mappings for git, formatting, folds, and navigation.
- **[`dot_config/mpv/`][mpv-dir], [`dot_config/zathura/`][zathura-dir], and [`dot_config/neofetch/`][neofetch-dir]:** round out the terminal-centric app stack for media playback, PDF reading, and system info.

### Window Manager And Desktop UI

- **[`dot_xinitrc.tmpl`][xinitrc], [`dot_Xresources.tmpl`][xresources], and the [`dot_Xmodmap` variants][xmodmap-family]:** control X startup, DPI and font choices, keyboard remaps, `wal` wallpaper theming, and host-specific differences between desktop, laptop, and VM setups.
- **[`dot_config/i3/config.tmpl`][i3-config]:** is the main desktop control plane for workspace movement, app assignments, launcher bindings, display and audio shortcuts, layout control, and the external hands-free toggle binding on `Pause`.
- **[`dot_config/i3blocks/`][i3blocks-dir] and its script directory:** provide the status bars for primary and secondary displays, with blocks for things like battery, wifi, volume, Spotify, temperature, and crypto or ticker data.
- **[`dot_config/dunst/dunstrc`][dunst-conf] and [`dot_config/picom/picom.conf`][picom-conf]:** shape the notification and compositing layer, while other app-specific configs under [`dot_config/`][dot-config-dir] cover tools like `MangoHud`, `Vesktop`, `Code`, and `Cursor`.

### Productivity And File Management

- **[`dot_taskrc`][taskrc] and [`dot_taskopenrc`][taskopenrc]:** set up Taskwarrior and Taskopen with contexts, urgency tuning, sync targets, and the preferred note or annotation workflow.
- **[`dot_config/ranger/`][ranger-dir]:** contains the file-manager workflow, including custom commands, fzf helpers, preview logic, plugins, and the shared key-mapping layer generated from the aliases templates.
- **[`dot_config/neomutt/neomuttrc`][neomutt-conf] and [`dot_config/msmtp/config`][msmtp-config]:** cover terminal email, while [`dot_config/zathura/zathurarc`][zathura-conf] keeps the reading stack aligned with the rest of the theme.
- **[`dot_config/mgba/`][mgba-dir] and [`dot_minikube/config/config.json`][minikube-config]:** show the broader pattern of app-specific config managed in the same repo, including emulator settings and local Kubernetes defaults.

### Scripts, Assets, And Machine-Specific State

- **[`scripts/`][scripts-dir]:** holds the automation layer behind the desktop, including wallpaper shuffling, `dmenu` helpers, audio sink changes, pass integration, package installation, finance or status scripts, backup helpers, and small terminal utilities.
- **[`scripts/colors/`][scripts-colors-dir] and [`txt/`][txt-dir]:** hold supporting assets such as terminal art, package lists, backup exclude files, TeX cleanup inputs, USB notes, and other small operational datasets.
- **[`dot_config/chezmoi/chezmoi-template.toml.tmpl`][chezmoi-template]:** is the host-data entrypoint for machine-specific toggles such as `gui`, `ext_kb`, and `linux_os`, which then feed template logic across the repo.
- **[`private_dot_calcurse/`][calcurse-dir], [`private_dot_gnupg/`][gnupg-dir], and [`dot_ssh/`][ssh-dir]:** cover the sensitive or machine-population side of the setup, alongside config files like `msmtp` or `taskrc` that should be treated carefully when syncing credentials.

That broader dotfiles surface is still substantial, but the README stays centered on the **four-Codex operating environment** because that is the most distinctive and actively evolving part of the repo right now.

[agents-baseline]: https://github.com/Kevin-Mok/linux-config/blob/master/AGENTS.md?plain=1#L9
[agents-repo-pointer]: https://github.com/Kevin-Mok/linux-config/blob/master/AGENTS.repo.md?plain=1#L5
[agents-repo-readme-sync]: https://github.com/Kevin-Mok/linux-config/blob/master/AGENTS.repo.md?plain=1#L9
[codex-agents]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_codex/AGENTS.md?plain=1#L11
[codex-config]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_codex/config.toml?plain=1#L1
[graphiti-codex-doc]: https://github.com/Kevin-Mok/linux-config/blob/master/docs/graphiti-mcp-codex.md?plain=1#L1
[skills-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/dot_agents/skills/
[plans-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/plans/
[plan-commit-all-dirty]: https://github.com/Kevin-Mok/linux-config/blob/master/plans/commit-all-dirty.md?plain=1#L1
[dot-bashrc]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_bashrc?plain=1#L1
[dot-zshrc]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_zshrc?plain=1#L1
[aliases-key-aliases]: https://github.com/Kevin-Mok/linux-config/blob/master/aliases/key_aliases.tmpl?plain=1#L1
[aliases-key-dirs]: https://github.com/Kevin-Mok/linux-config/blob/master/aliases/key_dirs.tmpl?plain=1#L1
[aliases-key-files]: https://github.com/Kevin-Mok/linux-config/blob/master/aliases/key_files.tmpl?plain=1#L1
[sync-shortcuts]: https://github.com/Kevin-Mok/linux-config/blob/master/scripts/executable_sync-shortcuts?plain=1#L1
[fish-config]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_config/fish/config.fish.tmpl?plain=1#L1
[fish-functions]: https://github.com/Kevin-Mok/linux-config/tree/master/dot_config/fish/functions/
[fish-completions]: https://github.com/Kevin-Mok/linux-config/tree/master/dot_config/fish/completions/
[kitty-conf]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_config/kitty/kitty.conf?plain=1#L1
[st-config]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_config/st/config.def.h.tmpl?plain=1#L1
[tmux-conf]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_tmux.conf?plain=1#L1
[vimrc]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_vimrc.tmpl?plain=1#L1
[nvim-init]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_config/nvim/init.vim?plain=1#L1
[mpv-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/dot_config/mpv/
[zathura-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/dot_config/zathura/
[neofetch-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/dot_config/neofetch/
[xinitrc]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_xinitrc.tmpl?plain=1#L1
[xresources]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_Xresources.tmpl?plain=1#L1
[xmodmap-family]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_Xmodmap?plain=1#L1
[i3-config]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_config/i3/config.tmpl?plain=1#L1
[i3blocks-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/dot_config/i3blocks/
[dunst-conf]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_config/dunst/dunstrc?plain=1#L1
[picom-conf]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_config/picom/picom.conf?plain=1#L1
[dot-config-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/dot_config/
[taskrc]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_taskrc?plain=1#L1
[taskopenrc]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_taskopenrc?plain=1#L1
[ranger-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/dot_config/ranger/
[neomutt-conf]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_config/neomutt/neomuttrc?plain=1#L1
[msmtp-config]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_config/msmtp/config?plain=1#L1
[zathura-conf]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_config/zathura/zathurarc?plain=1#L1
[mgba-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/dot_config/mgba/
[minikube-config]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_minikube/config/config.json?plain=1#L1
[scripts-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/scripts/
[scripts-colors-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/scripts/colors/
[txt-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/txt/
[chezmoi-template]: https://github.com/Kevin-Mok/linux-config/blob/master/dot_config/chezmoi/chezmoi-template.toml.tmpl?plain=1#L1
[calcurse-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/private_dot_calcurse/
[gnupg-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/private_dot_gnupg/
[ssh-dir]: https://github.com/Kevin-Mok/linux-config/tree/master/dot_ssh/

## License

This repository is licensed under the [MIT License](LICENSE).

You may use, modify, and redistribute it, including for commercial work, as long as the copyright and license notice stay with copies or substantial portions of the material. If a file or subdirectory carries its own license notice, that specific notice controls for that material.
