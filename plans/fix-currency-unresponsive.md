# Fix Currency Unresponsive Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the `currency` helper fail fast with a readable error instead of appearing unresponsive when the exchange-rate API is unreachable, and move it to a maintained free rates provider.

**Architecture:** Keep the existing standalone Python script, but add explicit request timeouts and exception handling around the outbound HTTP call. Query a maintained free endpoint and calculate the converted amount from the returned rate table. Cover the regression with a small script-level unit test that loads the executable directly and patches `requests.get`.

**Tech Stack:** Python 3, `requests`, `unittest`

---

### Task 1: Capture the failing behavior

**Files:**
- Modify: `plans/fix-currency-unresponsive.md`
- Test: `tests/scripts/test_executable_currency.py`

- [x] **Step 1: Reproduce the current failure**

Run: `timeout 8s python3 scripts/executable_currency USD CAD 1`
Expected: currently raises a `requests` connection traceback instead of handling the failure gracefully.

- [x] **Step 2: Write the failing regression test**

Create a test that patches `requests.get` to raise a timeout-related exception and asserts the script returns a non-zero exit code with a concise error message.

- [x] **Step 3: Run the targeted test to confirm RED**

Run: `python3 -m unittest tests.scripts.test_executable_currency -v`
Expected: FAIL because the current implementation does not catch the request exception or enforce a timeout.

### Task 2: Implement the minimal fix

**Files:**
- Modify: `scripts/executable_currency`
- Test: `tests/scripts/test_executable_currency.py`

- [x] **Step 1: Add bounded network behavior**

Pass a timeout to `requests.get` and return an explicit exit code from the script's main path.

- [x] **Step 2: Handle request failures cleanly**

Catch `requests.RequestException` subclasses, print a short error to `stderr`, and avoid tracebacks for expected network problems.

- [x] **Step 3: Re-run the targeted test to confirm GREEN**

Run: `python3 -m unittest tests.scripts.test_executable_currency -v`
Expected: PASS.

### Task 3: Verify the command behavior

**Files:**
- Modify: `plans/fix-currency-unresponsive.md`

- [x] **Step 1: Re-run the original reproducer**

Run: `timeout 8s python3 scripts/executable_currency USD CAD 1`
Expected: exits quickly with a readable error instead of hanging or dumping a traceback.

- [x] **Step 2: Review the final diff**

### Follow-up: Provider maintenance

**Files:**
- Modify: `scripts/executable_currency`
- Test: `tests/scripts/test_executable_currency.py`

- [x] **Step 1: Swap the provider**

Change `scripts/executable_currency` from the timed-out `api.frankfurter.app` endpoint to the free `open.er-api.com` latest-rates endpoint, while preserving the existing CLI shape.

- [x] **Step 2: Update the regression coverage**

Assert the script calls the new endpoint and multiplies the returned rate by the requested amount.

## Review

- Root cause: the script had already been hardened to fail fast, but it still targeted `api.frankfurter.app`, which was timing out in real use. The helper needed a maintained free provider and a rate-calculation path that matched that provider's response format.
- Verification:
  - `python3 -m unittest tests.scripts.test_executable_currency -v`
  - `chezmoi apply`

Run: `git diff -- scripts/executable_currency tests/scripts/test_executable_currency.py plans/fix-currency-unresponsive.md`
Expected: only the planned bugfix and regression coverage are included.
