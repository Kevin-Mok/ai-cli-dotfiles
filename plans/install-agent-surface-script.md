# Agent Surface Installer Script Plan

> **For agentic workers:** Follow the repo AGENTS chain. Keep this change small, testable, and limited to installing AGENTS files, local skill folders, and the plan directory.

**Goal:** Add a reusable script that bootstraps AGENTS files and local skill folders into another repo using this dotfiles repo as the source.

**Architecture:** Add one Bash script under `scripts/` plus a focused shell test. The script should support normal repos that use `.agents/skills/` and chezmoi source repos that use `dot_agents/skills/`. It should avoid overwriting existing files unless `--force` is provided.

**Tech Stack:** Bash, coreutils, shell tests

---

### Task 1: Test Installer Contract

**Files:**
- Create: `tests/scripts/executable_install-agent-surface_test.sh`

- [x] **Step 1:** Verify `--help` prints usage and key options.
- [x] **Step 2:** Verify a temp normal repo gets `AGENTS.md`, `AGENTS.repo.md`, `.agents/skills/`, and `plans/`.
- [x] **Step 3:** Verify selected skills are copied.
- [x] **Step 4:** Verify `--chezmoi` writes `dot_agents/skills/`.

### Task 2: Implement Installer

**Files:**
- Create: `scripts/executable_install-agent-surface`

- [x] **Step 1:** Implement argument parsing.
- [x] **Step 2:** Resolve repo root and source files.
- [x] **Step 3:** Create AGENTS files and folders safely.
- [x] **Step 4:** Copy selected or all skills.
- [x] **Step 5:** Print next-step commands for normal and chezmoi repos.

### Task 3: Docs And Verification

**Files:**
- Modify: `README.md`
- Modify: `docs/smoke-tests.md`
- Create: `dot_config/fish/completions/install-agent-surface.fish`
- Modify: `dot_bashrc`

- [x] **Step 1:** Document the new command in the command reference.
- [x] **Step 2:** Add a durable smoke-test checklist entry.
- [x] **Step 3:** Run the shell test and `bash -n`.

## Review

- Added `scripts/executable_install-agent-surface` to bootstrap another
  repo with AGENTS files, `plans/`, and either `.agents/skills/` or
  `dot_agents/skills/`.
- Added `--global` mode to install the home-level Codex surface:
  `~/.codex/AGENTS.md`, `~/.agents/AGENTS.md`, `~/.agents/skills/`,
  and `~/.agents/system-design/`.
- Changed generated repo-local `AGENTS.repo.md` files so they point to
  global `~/.codex/AGENTS.md` as the Codex policy layer before local
  repo additions.
- Added `tests/scripts/executable_install-agent-surface_test.sh` to
  verify help output, normal repo setup, selected skill copying,
  generated AGENTS precedence text, chezmoi-style setup, and global
  home-level setup.
- Updated the root README command reference and shared smoke-test
  checklist with the new installer workflow.
- Added fish completions for `install-agent-surface` and added
  `~/scripts` to the Bash PATH so bash can resolve the same
  chezmoi-installed command as a fallback shell.
- Updated `--chezmoi` mode to auto-install `chezmoi` into
  `$HOME/.local/bin` when the command is missing, using the official
  `get.chezmoi.io` installer via `curl` or `wget`.
- Verified with
  `tests/scripts/executable_install-agent-surface_test.sh`,
  `bash -n scripts/executable_install-agent-surface tests/scripts/executable_install-agent-surface_test.sh`,
  `fish -n dot_config/fish/completions/install-agent-surface.fish`, and
  `./scripts/executable_readme-recruiter-sync .`.
- `refresh-config` still was not run here because this execution
  environment does not have `chezmoi`, so the repo-local apply step
  cannot complete in-session.
