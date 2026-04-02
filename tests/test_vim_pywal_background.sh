#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_path="${repo_root}/dot_vimrc.tmpl"

assert_contains() {
  local needle="$1"
  if ! rg -F "$needle" "$config_path" >/dev/null; then
    printf 'expected %s to contain: %s\n' "$config_path" "$needle" >&2
    exit 1
  fi
}

assert_contains "function! ApplyWalBackground() abort"
assert_contains "if exists('g:colors_name') && g:colors_name ==# 'wal'"
assert_contains "let l:wal_colors_path = expand('~/.cache/wal/colors-wal.vim')"
assert_contains "let l:wal_lines = readfile(l:wal_colors_path)"
assert_contains "let l:bg = matchstr(join(l:wal_lines, \"\\n\"), 'let color0  = \"\\zs#[0-9A-Fa-f]\\{6}\\ze\"')"
assert_contains "let l:fg = matchstr(join(l:wal_lines, \"\\n\"), 'let color7  = \"\\zs#[0-9A-Fa-f]\\{6}\\ze\"')"
assert_contains "let l:const = matchstr(join(l:wal_lines, \"\\n\"), 'let color1  = \"\\zs#[0-9A-Fa-f]\\{6}\\ze\"')"
assert_contains "let l:string = matchstr(join(l:wal_lines, \"\\n\"), 'let color2  = \"\\zs#[0-9A-Fa-f]\\{6}\\ze\"')"
assert_contains "let l:type = matchstr(join(l:wal_lines, \"\\n\"), 'let color3  = \"\\zs#[0-9A-Fa-f]\\{6}\\ze\"')"
assert_contains "let l:func = matchstr(join(l:wal_lines, \"\\n\"), 'let color4  = \"\\zs#[0-9A-Fa-f]\\{6}\\ze\"')"
assert_contains "let l:keyword = matchstr(join(l:wal_lines, \"\\n\"), 'let color5  = \"\\zs#[0-9A-Fa-f]\\{6}\\ze\"')"
assert_contains "let l:special = matchstr(join(l:wal_lines, \"\\n\"), 'let color6  = \"\\zs#[0-9A-Fa-f]\\{6}\\ze\"')"
assert_contains "highlight Normal ctermbg=0 ctermfg=7"
assert_contains "highlight NormalNC ctermbg=0 ctermfg=7"
assert_contains "highlight EndOfBuffer ctermbg=0 ctermfg=0"
assert_contains "highlight NonText ctermbg=0 ctermfg=0"
assert_contains "highlight LineNr ctermbg=0 ctermfg=8"
assert_contains "highlight CursorLineNr ctermbg=0 ctermfg=8"
assert_contains "highlight FoldColumn ctermbg=0 ctermfg=7"
assert_contains "highlight SignColumn ctermbg=0 ctermfg=4"
assert_contains "highlight Folded ctermbg=0 ctermfg=8"
assert_contains "highlight Comment ctermbg=0 ctermfg=8"
assert_contains "highlight String ctermbg=0 ctermfg=2"
assert_contains "highlight Type ctermbg=0 ctermfg=3"
assert_contains "highlight Function ctermbg=0 ctermfg=4"
assert_contains "highlight Statement ctermbg=0 ctermfg=5"
assert_contains "highlight Special ctermbg=0 ctermfg=6"
assert_contains "guibg=' . l:bg"
assert_contains "guifg=' . l:fg"
assert_contains "autocmd ColorScheme wal call ApplyWalBackground()"
assert_contains "set termguicolors"
