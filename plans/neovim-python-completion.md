# Neovim Python Completion Migration

- [x] Add a failing regression test that defines the tracked Neovim completion shape and install script expectations.
- [x] Replace YCM-era Python completion config with a Neovim-only Blink + basedpyright setup while preserving the shared Vim defaults that are still useful outside completion.
- [x] Add a repo script for upgrading Neovim from the official stable release and installing the Python language server.
- [x] Update smoke tests and README to describe the new Neovim-first editor workflow.
- [x] Verify with the targeted test, shell syntax checks, headless Neovim startup, and `refresh-config`.
