# Screenshot All Monitors Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a repo-managed helper that saves one combined screenshot of the full multi-monitor desktop.

**Architecture:** Use the existing desktop screenshot convention: a Bash helper under `scripts/` that runs `scrot` once against the X virtual desktop. The script creates `/home/kevin/Pictures/screenshots/desktop/unsorted` when needed and saves `screenshot-YYYY-MM-DD_HH:MM:SS.png`.

**Tech Stack:** Bash, `scrot`, shell tests, README and smoke-test docs.

---

### Task 1: Combined Desktop Screenshot Helper

**Files:**
- Create: `scripts/executable_screenshot-all-monitors`
- Create: `tests/test_screenshot_all_monitors.sh`
- Modify: `README.md`
- Modify: `docs/smoke-tests.md`

- [x] **Step 1: Write the failing test**

Add a shell test that runs the helper with fake `date` and `scrot`, then asserts the helper prints and passes one path matching `screenshot-YYYY-MM-DD_HH:MM:SS.png`.

- [x] **Step 2: Run the test to verify it fails**

Run: `bash tests/test_screenshot_all_monitors.sh`

Expected: FAIL because `scripts/executable_screenshot-all-monitors` does not exist yet.

- [x] **Step 3: Implement the minimal helper**

Create `scripts/executable_screenshot-all-monitors` with `set -euo pipefail`, dependency checks, destination directory creation, one `scrot "$output"` call, and printed output path.

- [x] **Step 4: Document and smoke-test the command**

Add the command to the README command reference and add a reusable manual smoke test for the full-desktop screenshot workflow.

- [x] **Step 5: Verify**

Run:

```bash
bash tests/test_screenshot_all_monitors.sh
bash -n scripts/executable_screenshot-all-monitors
./scripts/executable_readme-recruiter-sync
```

Expected: all commands pass.
