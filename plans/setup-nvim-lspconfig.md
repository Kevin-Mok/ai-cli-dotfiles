# Setup `nvim-lspconfig` For Python

- [x] Inspect the existing Neovim Python completion stack and confirm where `nvim-lspconfig` needs to replace the newer built-in LSP API usage.
- [x] Update the Lua config to initialize `basedpyright` through `require('lspconfig')` while preserving the existing Blink and helper commands.
- [x] Update regression coverage and docs so the repo describes the `nvim-lspconfig`-backed Python setup accurately.
- [x] Verify with the focused shell test and a headless Neovim startup check.

## Review

- Switched the Python LSP setup from the Neovim 0.11 `vim.lsp.config` / `vim.lsp.enable` API to `require('lspconfig').basedpyright.setup(...)`, which matches the repo's installed `vim-plug` plugin surface.
- Updated the regression test to assert the `nvim-lspconfig` code path and adjusted the README wording so the documented Neovim stack matches the implementation.
- Verification:
  - `bash tests/test_nvim_python_completion.sh`
  - `XDG_CONFIG_HOME=/home/kevin/linux-config XDG_DATA_HOME=/tmp/codex-nvim-data XDG_STATE_HOME=/tmp/codex-nvim-state XDG_CACHE_HOME=/tmp/codex-nvim-cache HOME=/tmp/codex-nvim-config nvim --headless '+qa'`
