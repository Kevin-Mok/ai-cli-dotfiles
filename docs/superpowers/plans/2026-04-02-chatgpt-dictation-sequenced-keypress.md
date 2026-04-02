# ChatGPT Dictation Sequenced Keypress Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the Menu-key ChatGPT shortcut use a two-press workflow: open/refresh/clear on the first press, then select/cut/close on the second press.

**Architecture:** Keep the original shell helper intact, add a sibling sequenced helper plus i3 binding target, and use a simple `idle`/`ready` shell state machine there instead of coordinate-driven mic automation. The first press prepares a clean ChatGPT window, and the second press uses keyboard shortcuts with short delays before closing the window.

**Tech Stack:** Bash, i3, xdotool, jq, repo shell tests

---

### Task 1: Model The Two-Press Flow In Tests

**Files:**
- Create: `tests/test_chatgpt_dictation_sequenced.sh`
- Test: `tests/test_chatgpt_dictation_sequenced.sh`

- [x] **Step 1: Write the failing tests**

Add assertions for the two-step sequence:
- first run ends in `ready` after refresh and clear
- second run ends in `idle` after select, cut, delays, and window close

- [x] **Step 2: Run test to verify it fails**

Run: `bash tests/test_chatgpt_dictation_sequenced.sh`
Expected: FAIL because the older helper still followed the previous multi-step behavior and did not include the new preparation or timing expectations

- [ ] **Step 3: Commit**

```bash
git add tests/test_chatgpt_dictation_sequenced.sh
git commit -m "test: define sequenced chatgpt dictation flow"
```

### Task 2: Implement The Two-Press State Machine

**Files:**
- Create: `scripts/executable_chatgpt-dictation-sequenced`
- Test: `tests/test_chatgpt_dictation_sequenced.sh`

- [x] **Step 1: Write minimal implementation**

Update the helper to:
- use `idle` and `ready`
- refresh and clear stale composer text on the first press
- split the second press into select, cut, delay, and close
- advance one step per invocation
- close the ChatGPT window after a successful cut

- [x] **Step 2: Run tests to verify the new flow**

Run: `bash tests/test_chatgpt_dictation_sequenced.sh`
Expected: PASS

- [x] **Step 3: Keep the Menu binding regression green**

Run: `bash tests/test_i3_chatgpt_dictation_binding.sh`
Expected: PASS

- [ ] **Step 4: Commit**

```bash
git add scripts/executable_chatgpt-dictation-sequenced tests/test_chatgpt_dictation_sequenced.sh dot_config/i3/config.tmpl
git commit -m "feat: sequence chatgpt dictation keypress flow"
```

### Task 3: Final Verification

**Files:**
- Review: `scripts/executable_chatgpt-dictation-sequenced`
- Review: `dot_config/i3/config.tmpl`

- [x] **Step 1: Run both shell tests**

Run:

```bash
bash tests/test_chatgpt_dictation_sequenced.sh
bash tests/test_i3_chatgpt_dictation_binding.sh
```

Expected: both PASS

- [ ] **Step 2: Manual verification**

1. Reload i3 config.
2. Press Menu once and confirm the floating ChatGPT window opens, refreshes, and clears stale composer text.
3. Click into the ChatGPT composer.
4. Press Menu again and confirm the text is selected, cut, and the window closes.

- [ ] **Step 3: Commit any follow-up doc or smoke-test updates if needed**

Only if implementation reveals a durable manual verification change that should be documented.
