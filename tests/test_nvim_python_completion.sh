#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
vimrc_path="${repo_root}/dot_vimrc.tmpl"
init_path="${repo_root}/dot_config/nvim/init.vim"
lua_path="${repo_root}/dot_config/nvim/lua/km/python_completion.lua"
script_path="${repo_root}/scripts/executable_setup-neovim-python-completion.sh"
smoke_path="${repo_root}/docs/smoke-tests.md"

assert_contains() {
  local needle="$1"
  local path="$2"
  if ! rg -F "$needle" "$path" >/dev/null; then
    printf 'expected %s to contain: %s\n' "$path" "$needle" >&2
    exit 1
  fi
}

assert_not_contains() {
  local needle="$1"
  local path="$2"
  if rg -F "$needle" "$path" >/dev/null; then
    printf 'expected %s to not contain: %s\n' "$path" "$needle" >&2
    exit 1
  fi
}

test -f "$script_path"
test -f "$lua_path"

assert_contains "augroup km_python_completion" "$init_path"
assert_contains "autocmd VimEnter * lua vim.schedule(function() require('km.python_completion').setup() end)" "$init_path"
assert_contains "autocmd FileType python lua require('km.python_completion').setup(); if vim.lsp.config and vim.lsp.config.basedpyright then vim.lsp.enable('basedpyright'); vim.schedule(function() vim.cmd('LspStart basedpyright') end) end" "$init_path"

assert_contains "Plug 'Saghen/blink.cmp', { 'tag': 'v1.*' }" "$vimrc_path"
assert_contains "Plug 'neovim/nvim-lspconfig'" "$vimrc_path"
assert_contains "nnoremap <leader>do :KMHover<CR>" "$vimrc_path"
assert_contains "nnoremap <leader>g :KMDefinitionSplit<CR>" "$vimrc_path"
assert_contains "nnoremap <leader>rn :KMRename<CR>" "$vimrc_path"
assert_contains "nnoremap <leader>fi :KMCodeAction<CR>" "$vimrc_path"
assert_not_contains "Plug 'Valloric/YouCompleteMe'" "$vimrc_path"
assert_not_contains "Plug 'ervandew/supertab'" "$vimrc_path"
assert_not_contains ":YcmCompleter" "$vimrc_path"

assert_contains "blink.setup({" "$lua_path"
assert_contains "signature = { enabled = true }" "$lua_path"
assert_contains "['<Down>'] = { 'select_next', 'fallback' }" "$lua_path"
assert_contains "['<Up>'] = { 'select_prev', 'fallback' }" "$lua_path"
assert_contains "['<Tab>'] = { 'accept', 'fallback' }" "$lua_path"
assert_contains "['<S-Tab>'] = { 'select_prev', 'fallback' }" "$lua_path"
assert_contains "basedpyright" "$lua_path"
assert_contains "basedpyright-langserver" "$lua_path"
assert_contains "filetypes = { 'python' }" "$lua_path"
assert_contains "single_file_support = true" "$lua_path"
assert_contains "pythonPath" "$lua_path"
assert_contains "KMHover" "$lua_path"
assert_contains "KMDefinitionSplit" "$lua_path"
assert_contains "vim.lsp.config('basedpyright'" "$lua_path"
assert_contains "vim.lsp.enable('basedpyright')" "$lua_path"
assert_not_contains "require, 'lspconfig'" "$lua_path"

assert_contains "setup-neovim-python-completion" "$script_path"
assert_contains "0.11.5" "$script_path"
assert_contains "basedpyright" "$script_path"
assert_contains "uv tool install --upgrade basedpyright" "$script_path"
assert_contains "resolve_user_command" "$script_path"
assert_contains "uv_bin" "$script_path"
assert_contains 'if [ "${skip_lsp}" -eq 0 ]; then' "$script_path"
assert_contains "run_as_user" "$script_path"
assert_contains "chown -R" "$script_path"

assert_contains "Open Neovim in a Python project" "$smoke_path"
assert_contains "signature help" "$smoke_path"
