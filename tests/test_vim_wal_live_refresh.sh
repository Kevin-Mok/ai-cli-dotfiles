#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_path="${repo_root}/dot_vimrc.tmpl"
real_home="$HOME"
wal_plugin_path="${real_home}/.vim/plugged/wal.vim"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

home_dir="${tmpdir}/home"
cache_dir="${home_dir}/.cache/wal"
rendered_vimrc="${tmpdir}/vimrc"
mkdir -p "$cache_dir"

chezmoi execute-template < "$config_path" > "$rendered_vimrc"

cat > "${cache_dir}/colors-wal.vim" <<'EOF'
" Special
let wallpaper  = "/tmp/a.jpg"
let background = "#101820"
let foreground = "#d8dee9"
let cursor     = "#d8dee9"

" Colors
let color0  = "#101820"
let color1  = "#d65d0e"
let color2  = "#8ec07c"
let color3  = "#d79921"
let color4  = "#2A4B78"
let color5  = "#35608E"
let color6  = "#C14F2A"
let color7  = "#d8dee9"
let color8  = "#928374"
EOF

HOME="$home_dir" nvim --headless -u NONE \
  +"set runtimepath^=${real_home}/.vim runtimepath+=${real_home}/.vim/after runtimepath+=${wal_plugin_path}" \
  +"source ${rendered_vimrc}" \
  +"set ft=python" \
  +"call writefile([execute('hi Function'), execute('hi Keyword'), execute('hi PreProc')], '${tmpdir}/before.txt')" \
  +"sleep 1" \
  +"call writefile(['\" Special', 'let wallpaper  = \"/tmp/b.jpg\"', 'let background = \"#091c26\"', 'let foreground = \"#d5d7dc\"', 'let cursor     = \"#d5d7dc\"', '', '\" Colors', 'let color0  = \"#091c26\"', 'let color1  = \"#4212ab\"', 'let color2  = \"#e23819\"', 'let color3  = \"#e65823\"', 'let color4  = \"#145abc\"', 'let color5  = \"#ed9460\"', 'let color6  = \"#e98d39\"', 'let color7  = \"#d5d7dc\"', 'let color8  = \"#778289\"'], expand('~/.cache/wal/colors-wal.vim'))" \
  +"sleep 1500m" \
  +"call writefile([execute('hi Function'), execute('hi Keyword'), execute('hi PreProc')], '${tmpdir}/after.txt')" \
  +qall! >/dev/null 2>&1

tr -d '\000' < "${tmpdir}/before.txt" > "${tmpdir}/before-clean.txt"
tr -d '\000' < "${tmpdir}/after.txt" > "${tmpdir}/after-clean.txt"

if cmp -s "${tmpdir}/before-clean.txt" "${tmpdir}/after-clean.txt"; then
  printf 'expected wal live refresh to change active highlight groups\n' >&2
  exit 1
fi

if ! rg -F "guifg=#ed9460" "${tmpdir}/after-clean.txt" >/dev/null; then
  printf 'expected refreshed wal highlights to promote a strong readable accent lane\n' >&2
  exit 1
fi

if ! rg -F "guifg=#e98d39" "${tmpdir}/after-clean.txt" >/dev/null; then
  printf 'expected refreshed wal highlights to keep a second distinct readable accent lane\n' >&2
  exit 1
fi

if ! rg -F "guifg=#e65823" "${tmpdir}/after-clean.txt" >/dev/null; then
  printf 'expected refreshed wal highlights to keep a third distinct readable accent lane\n' >&2
  exit 1
fi

if rg -F "guifg=#145abc" "${tmpdir}/after-clean.txt" >/dev/null; then
  printf 'expected weak blue accent to be rejected under translucent background\n' >&2
  exit 1
fi
