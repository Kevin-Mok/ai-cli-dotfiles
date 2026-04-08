#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_path="${repo_root}/dot_vimrc.tmpl"
real_home="$HOME"
wal_plugin_path="${real_home}/.vim/plugged/wal.vim"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

rendered_vimrc="${tmpdir}/vimrc"
sample_path="${tmpdir}/sample.py"
result_path="${tmpdir}/result.txt"
script_path="${tmpdir}/test.vim"

chezmoi execute-template < "$config_path" > "$rendered_vimrc"

cat > "$sample_path" <<'EOF'
async def commit_order(user_id, cart_items, payment_details):
    cart = await db.fetch_one(
        "SELECT * FROM carts WHERE user_id = :user_id",
        {"user_id": user_id}
    )

    if not cart or len(cart["items"]) == 0:
        raise ValueError("Cart is empty or not found")

    total_amount = sum(
        item["price"] * item["quantity"] for item in cart["items"]
    )

    async with db.transaction():
        order = await db.fetch_one(
            "SELECT 1"
        )
EOF

cat > "$script_path" <<EOF
set runtimepath^=${real_home}/.vim runtimepath+=${real_home}/.vim/after runtimepath+=${wal_plugin_path}
source ${rendered_vimrc}
edit ${sample_path}
call cursor(1, 1)
call JumpToNextParagraphStart()
let header_next_line = line('.')
call cursor(2, 1)
call JumpToNextParagraphStart()
let next_line = line('.')
call cursor(7, 1)
call JumpToPrevParagraphStart()
let prev_line = line('.')
call writefile([
\ printf('header-next:%d', header_next_line),
\ printf('next:%d', next_line),
\ printf('prev:%d', prev_line),
\ ], '${result_path}')
qall!
EOF

HOME="$real_home" nvim --headless -u NONE \
  -S "$script_path" >/dev/null 2>&1

if ! rg -x 'header-next:2' "$result_path" >/dev/null; then
  printf 'expected scroll down from a block header to land on the first indented line\n' >&2
  cat "$result_path" >&2
  exit 1
fi

if ! rg -x 'next:5' "$result_path" >/dev/null; then
  printf 'expected scroll down from the assignment to land on the next same-or-lower-indent line\n' >&2
  cat "$result_path" >&2
  exit 1
fi

if ! rg -x 'prev:5' "$result_path" >/dev/null; then
  printf 'expected scroll up from the if statement to land on the previous same-or-lower-indent line\n' >&2
  cat "$result_path" >&2
  exit 1
fi
