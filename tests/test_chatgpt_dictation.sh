#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="${repo_root}/scripts/executable_chatgpt-dictation"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mockbin="${tmpdir}/mockbin"
runtime_dir="${tmpdir}/runtime"
state_dir="${runtime_dir}/chatgpt-dictation"
debug_log_file="${state_dir}/debug.log"
log_file="${tmpdir}/commands.log"
clipboard_file="${tmpdir}/clipboard.txt"

mkdir -p "$mockbin" "$runtime_dir"
: > "$log_file"

cat > "${mockbin}/google-chrome" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'google-chrome %s\n' "$*" >> "$TEST_LOG"
cat > "$TEST_RUNTIME/window_state.json" <<JSON
{"id":"424242","name":"ChatGPT","class":"Google-chrome","marked":false}
JSON
EOF

cat > "${mockbin}/i3-msg" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

window_json="$TEST_RUNTIME/window_state.json"

window_id=""
window_name=""
window_class=""
window_marked="false"
if [ -f "$window_json" ]; then
  window_id="$(jq -r '.id' "$window_json")"
  window_name="$(jq -r '.name' "$window_json")"
  window_class="$(jq -r '.class' "$window_json")"
  window_marked="$(jq -r '.marked' "$window_json")"
fi

if [ "${1:-}" = "-t" ] && [ "${2:-}" = "get_tree" ]; then
  if [ -n "$window_id" ]; then
    if [ "$window_marked" = "true" ]; then
      marks='["chatgpt_dictation"]'
    else
      marks='[]'
    fi
    cat <<JSON
{"nodes":[{"nodes":[],"floating_nodes":[{"id":${window_id},"name":"${window_name}","marks":${marks},"window_properties":{"class":"${window_class}"}}]}],"floating_nodes":[]}
JSON
  else
    printf '{"nodes":[],"floating_nodes":[]}\n'
  fi
  exit 0
fi

printf 'i3-msg %s\n' "$*" >> "$TEST_LOG"
case "$*" in
  *"mark --add chatgpt_dictation"*)
    [ -f "$window_json" ] || exit 0
    tmp_json="${window_json}.tmp"
    jq '.marked = true' "$window_json" > "$tmp_json"
    mv "$tmp_json" "$window_json"
    ;;
  *"kill"*)
    rm -f "$window_json"
    ;;
esac
EOF

cat > "${mockbin}/xdotool" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

window_json="$TEST_RUNTIME/window_state.json"
window_id=""
if [ -f "$window_json" ]; then
  window_id="$(jq -r '.id' "$window_json")"
fi

case "${1:-}" in
  search)
    if [ -n "$window_id" ]; then
      printf '%s\n' "$window_id"
      exit 0
    fi
    exit 1
    ;;
  getwindowgeometry)
    cat <<'GEOM'
X=100
Y=100
WIDTH=1100
HEIGHT=720
SCREEN=0
GEOM
    ;;
  *)
    printf 'xdotool %s\n' "$*" >> "$TEST_LOG"
    ;;
esac
EOF

cat > "${mockbin}/xclip" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'xclip %s\n' "$*" >> "$TEST_LOG"
EOF

cat > "${mockbin}/notify-send" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'notify-send %s\n' "$*" >> "$TEST_LOG"
EOF

chmod +x "${mockbin}/google-chrome" "${mockbin}/i3-msg" "${mockbin}/xdotool" "${mockbin}/xclip" "${mockbin}/notify-send"

run_script() {
  PATH="${mockbin}:$PATH" \
  TEST_LOG="$log_file" \
  TEST_RUNTIME="$runtime_dir" \
  TEST_CLIPBOARD="$clipboard_file" \
  XDG_RUNTIME_DIR="$runtime_dir" \
  bash "$script_path"
}

reset_state() {
  rm -rf "$state_dir"
  rm -f "${runtime_dir}/window_state.json"
  : > "$log_file"
  : > "$clipboard_file"
}

assert_contains() {
  local needle="$1"
  local haystack_file="$2"
  if ! rg -F "$needle" "$haystack_file" >/dev/null; then
    printf 'expected to find %s in %s\n' "$needle" "$haystack_file" >&2
    return 1
  fi
}

assert_mode() {
  local expected="$1"
  local mode_file="${state_dir}/mode"
  if [ ! -f "$mode_file" ]; then
    printf 'expected mode file at %s\n' "$mode_file" >&2
    return 1
  fi
  if [ "$(cat "$mode_file")" != "$expected" ]; then
    printf 'expected mode %s, got %s\n' "$expected" "$(cat "$mode_file")" >&2
    return 1
  fi
}

assert_debug_contains() {
  local needle="$1"
  if [ ! -f "$debug_log_file" ]; then
    printf 'expected debug log at %s\n' "$debug_log_file" >&2
    return 1
  fi
  assert_contains "$needle" "$debug_log_file"
}

reset_state
run_script
assert_contains "google-chrome --profile-directory=Default --app=https://chatgpt.com/" "$log_file"
assert_contains "xdotool key --clearmodifiers ctrl+r" "$log_file"
assert_contains "xdotool key --clearmodifiers ctrl+a BackSpace" "$log_file"
assert_mode "ready"
assert_debug_contains "set_mode: ready"
assert_debug_contains "main: action=prepare_window"

run_script
assert_contains "xdotool key --clearmodifiers ctrl+a" "$log_file"
assert_contains "xdotool key --clearmodifiers ctrl+x" "$log_file"
assert_contains "i3-msg [con_id=424242] kill" "$log_file"
assert_mode "idle"
assert_debug_contains "cut_transcript: window_id=424242"
assert_debug_contains "cut_transcript: waited_after_select=0.12"
assert_debug_contains "cut_transcript: waited_after_cut=0.18"
assert_debug_contains "set_mode: idle"

reset_state
mkdir -p "$state_dir"
printf 'ready\n' > "${state_dir}/mode"
run_script
assert_contains "google-chrome --profile-directory=Default --app=https://chatgpt.com/" "$log_file"
assert_mode "ready"
