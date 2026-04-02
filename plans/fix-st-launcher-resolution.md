# Fix st Launcher Resolution

- [x] Add a regression test for the terminal launcher wrapper so the repo can resolve `st` or `stterm` at runtime.
- [x] Create a repo-owned launcher script that prefers `st`, falls back to `stterm`, and prints a clear install hint when neither exists.
- [x] Point the i3 terminal bindings and Codex launcher path at the wrapper instead of bare `st`.
- [x] Update docs and smoke tests to mention the runtime resolution and install expectation.
- [x] Run the targeted tests and review the focused diff.
