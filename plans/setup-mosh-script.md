# Mosh Setup Script Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a reusable script that sets up this machine for `mosh` access with installation, firewall rules, and verification guidance.

**Architecture:** Add one Bash script under `scripts/` that follows the repo's existing privileged setup-script patterns. Verify it with a lightweight shell test that exercises `--help`, then run syntax checks and review whether the shared smoke-test checklist should mention the new manual validation flow.

**Tech Stack:** Bash, sudo, common Linux package managers, ufw/firewalld

---

### Task 1: Test-First Skeleton

**Files:**
- Create: `tests/scripts/executable_setup-mosh_test.sh`
- Create: `plans/setup-mosh-script.md`

- [x] **Step 1: Write the failing test**
- [x] **Step 2: Run the test and confirm it fails because the script does not exist yet**

### Task 2: Implement Script

**Files:**
- Create: `scripts/executable_setup-mosh.sh`

- [x] **Step 1: Implement argument parsing and usage output**
- [x] **Step 2: Implement distro-aware package installation and firewall opening**
- [x] **Step 3: Implement verification output for SSH and mosh server readiness**

### Task 3: Verify And Document

**Files:**
- Modify: `docs/smoke-tests.md` (only if the shared manual checklist needs a new or updated entry)

- [x] **Step 1: Run the shell test and syntax checks**
- [x] **Step 2: Update smoke-test documentation if this change introduces a durable manual check**
- [x] **Step 3: Add a short review note to this plan**

## Review

- Added `scripts/executable_setup-mosh.sh` as a sudo-aware Bash helper
  that installs `mosh`, opens a configurable UDP firewall port or range,
  and reports whether SSH bootstrap still needs attention.
- Added `tests/scripts/executable_setup-mosh_test.sh` and verified the
  expected red-to-green flow by running the test before and after the
  script existed.
- Updated `docs/smoke-tests.md` with the shared manual verification step
  for preparing a host to accept remote `mosh` sessions.
