#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="${repo_root}/scripts/executable_speechnotes-dictation"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mockbin="${tmpdir}/mockbin"
runtime_dir="${tmpdir}/runtime"
log_file="${tmpdir}/commands.log"
profile_dir="${runtime_dir}/state/speechnotes-dictation/profile"

mkdir -p "$mockbin" "$runtime_dir"
: > "$log_file"

cat > "${mockbin}/google-chrome" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'google-chrome %s\n' "$*" >> "$TEST_LOG"
cat > "$TEST_RUNTIME/window_state.json" <<JSON
{"id":"31337","name":"Speechnotes","class":"Google-chrome","marked":false,"focused":true,"scratchpad_state":"none","x":0,"y":0}
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
window_focused="false"
window_scratchpad_state="none"
window_x="0"
window_y="0"
if [ -f "$window_json" ]; then
  window_id="$(jq -r '.id' "$window_json")"
  window_name="$(jq -r '.name' "$window_json")"
  window_class="$(jq -r '.class' "$window_json")"
  window_marked="$(jq -r '.marked' "$window_json")"
  window_focused="$(jq -r '.focused // false' "$window_json")"
  window_scratchpad_state="$(jq -r '.scratchpad_state // "none"' "$window_json")"
  window_x="$(jq -r '.x // 0' "$window_json")"
  window_y="$(jq -r '.y // 0' "$window_json")"
fi

if [ "${1:-}" = "-t" ] && [ "${2:-}" = "get_tree" ]; then
  if [ -n "$window_id" ]; then
    if [ "$window_marked" = "true" ]; then
      marks='["speechnotes_dictation"]'
    else
      marks='[]'
    fi
    cat <<JSON
{"nodes":[{"nodes":[],"floating_nodes":[{"id":${window_id},"name":"${window_name}","marks":${marks},"focused":${window_focused},"scratchpad_state":"${window_scratchpad_state}","rect":{"x":${window_x},"y":${window_y},"width":1180,"height":820},"window_properties":{"class":"${window_class}"}}]}],"floating_nodes":[]}
JSON
  else
    printf '{"nodes":[],"floating_nodes":[]}\n'
  fi
  exit 0
fi

if [ "${1:-}" = "-t" ] && [ "${2:-}" = "get_outputs" ]; then
  cat <<'JSON'
[{"name":"DVI-D-0","active":true,"primary":true,"rect":{"x":0,"y":0,"width":2048,"height":1152},"current_workspace":"2 term"},{"name":"xroot-0","active":false,"primary":false,"rect":{"x":0,"y":0,"width":3968,"height":1152},"current_workspace":null},{"name":"HDMI-0","active":true,"primary":false,"rect":{"x":2048,"y":0,"width":1920,"height":1080},"current_workspace":"1 web"}]
JSON
  exit 0
fi

if [ "${1:-}" = "-t" ] && [ "${2:-}" = "get_workspaces" ]; then
  cat <<'JSON'
[{"name":"1 web","focused":true,"output":"HDMI-0"},{"name":"2 term","focused":false,"output":"DVI-D-0"}]
JSON
  exit 0
fi

printf 'i3-msg %s\n' "$*" >> "$TEST_LOG"
case "$*" in
  *"move window to output current"*)
    printf 'ERROR: No output matched\n' >&2
    exit 2
    ;;
  *"mark --add speechnotes_dictation"*)
    [ -f "$window_json" ] || exit 0
    tmp_json="${window_json}.tmp"
    jq '.marked = true' "$window_json" > "$tmp_json"
    mv "$tmp_json" "$window_json"
    ;;
  *"move scratchpad"*)
    [ -f "$window_json" ] || exit 0
    tmp_json="${window_json}.tmp"
    jq '.scratchpad_state = "changed" | .focused = false | .x = -511 | .y = -361' "$window_json" > "$tmp_json"
    mv "$tmp_json" "$window_json"
    ;;
  *"scratchpad show"*)
    [ -f "$window_json" ] || exit 0
    tmp_json="${window_json}.tmp"
    jq '.scratchpad_state = "none" | .focused = true' "$window_json" > "$tmp_json"
    mv "$tmp_json" "$window_json"
    ;;
  *"move position 2518 px 280 px"*)
    [ -f "$window_json" ] || exit 0
    tmp_json="${window_json}.tmp"
    jq '.x = 2518 | .y = 280' "$window_json" > "$tmp_json"
    mv "$tmp_json" "$window_json"
    ;;
  *"] kill"*)
    rm -f "$window_json"
    ;;
  *"] focus"*)
    [ -f "$window_json" ] || exit 0
    tmp_json="${window_json}.tmp"
    jq '.focused = true' "$window_json" > "$tmp_json"
    mv "$tmp_json" "$window_json"
    ;;
esac
EOF

cat > "${mockbin}/xdotool" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'xdotool %s\n' "$*" >> "$TEST_LOG"
EOF

chmod +x "${mockbin}/google-chrome" "${mockbin}/i3-msg" "${mockbin}/xdotool"

run_script() {
  PATH="${mockbin}:$PATH" \
  TEST_LOG="$log_file" \
  TEST_RUNTIME="$runtime_dir" \
  XDG_STATE_HOME="${runtime_dir}/state" \
  bash "$script_path" "$@"
}

assert_contains() {
  local needle="$1"
  local haystack_file="$2"
  if ! rg -F "$needle" "$haystack_file" >/dev/null; then
    printf 'expected to find %s in %s\n' "$needle" "$haystack_file" >&2
    return 1
  fi
}

run_script
assert_contains "google-chrome --user-data-dir=${profile_dir} --app=https://speechnotes.co/dictate/ --no-first-run --no-default-browser-check --disable-sync" "$log_file"
assert_contains "i3-msg [con_id=31337] mark --add speechnotes_dictation" "$log_file"
assert_contains "i3-msg [con_id=31337] move position 2518 px 280 px" "$log_file"
if rg -F "i3-msg [con_id=31337] move scratchpad" "$log_file" >/dev/null; then
  printf 'did not expect fresh toggle launch to hide the new Speechnotes window\n' >&2
  exit 1
fi

: > "$log_file"
rm -f "${runtime_dir}/window_state.json"
run_script --prewarm
assert_contains "google-chrome --user-data-dir=${profile_dir} --app=https://speechnotes.co/dictate/ --no-first-run --no-default-browser-check --disable-sync" "$log_file"
assert_contains "i3-msg [con_id=31337] mark --add speechnotes_dictation" "$log_file"
assert_contains "i3-msg [con_id=31337] floating enable" "$log_file"
assert_contains "i3-msg [con_id=31337] resize set 980 px 520 px" "$log_file"
assert_contains "i3-msg [con_id=31337] move position 2518 px 280 px" "$log_file"
assert_contains "i3-msg [con_id=31337] focus" "$log_file"
assert_contains "i3-msg [con_id=31337] move scratchpad" "$log_file"

: > "$log_file"
run_script
assert_contains "i3-msg [con_id=31337] kill" "$log_file"
assert_contains "google-chrome --user-data-dir=${profile_dir} --app=https://speechnotes.co/dictate/ --no-first-run --no-default-browser-check --disable-sync" "$log_file"
assert_contains "i3-msg [con_id=31337] move position 2518 px 280 px" "$log_file"

cat > "${runtime_dir}/window_state.json" <<'JSON'
{"id":"42424","name":"free speech to text - Google Search","class":"Google-chrome","marked":false,"focused":false,"scratchpad_state":"none","x":0,"y":0}
JSON
: > "$log_file"
run_script
assert_contains "google-chrome --user-data-dir=${profile_dir} --app=https://speechnotes.co/dictate/ --no-first-run --no-default-browser-check --disable-sync" "$log_file"

cat > "${runtime_dir}/window_state.json" <<'JSON'
{"id":"31337","name":"Speechnotes","class":"Google-chrome","marked":true,"focused":true,"scratchpad_state":"none","x":2418,"y":130}
JSON
: > "$log_file"
run_script
assert_contains "i3-msg [con_id=31337] move scratchpad" "$log_file"

: > "$log_file"
run_script --prewarm
assert_contains "i3-msg [con_id=31337] move scratchpad" "$log_file"

cat > "${runtime_dir}/window_state.json" <<'JSON'
{"id":"31337","name":"Speechnotes","class":"Google-chrome","marked":true,"focused":false,"scratchpad_state":"none","x":-511,"y":-361}
JSON
: > "$log_file"
run_script
assert_contains "google-chrome --user-data-dir=${profile_dir} --app=https://speechnotes.co/dictate/ --no-first-run --no-default-browser-check --disable-sync" "$log_file"
