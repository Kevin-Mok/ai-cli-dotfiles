#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
script_path="${repo_root}/scripts/executable_install-agent-surface"

assert_file() {
  local path="$1"

  if [[ ! -f "$path" ]]; then
    printf 'expected file to exist: %s\n' "$path" >&2
    exit 1
  fi
}

assert_dir() {
  local path="$1"

  if [[ ! -d "$path" ]]; then
    printf 'expected directory to exist: %s\n' "$path" >&2
    exit 1
  fi
}

assert_contains() {
  local needle="$1"
  local haystack="$2"

  if ! printf '%s\n' "$haystack" | grep -Fq -- "$needle"; then
    printf 'expected output to contain: %s\n' "$needle" >&2
    printf 'actual output:\n%s\n' "$haystack" >&2
    exit 1
  fi
}

if ! output="$("$script_path" --help 2>&1)"; then
  printf 'expected help command to succeed for %s\n' "$script_path" >&2
  exit 1
fi

assert_contains "Usage:" "$output"
assert_contains "executable_install-agent-surface" "$output"
assert_contains "--skill NAME" "$output"
assert_contains "--chezmoi" "$output"
assert_contains "--global" "$output"

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

fake_bin="$tmp_root/bin"
mkdir -p "$fake_bin"
cat > "$fake_bin/chezmoi" <<'EOF'
#!/usr/bin/env bash
printf 'chezmoi fake-test\n'
EOF
chmod +x "$fake_bin/chezmoi"

normal_repo="$tmp_root/normal-repo"
mkdir -p "$normal_repo"

"$script_path" --target "$normal_repo" --skill commit-plan >/tmp/install-agent-surface-normal.out

assert_file "$normal_repo/AGENTS.md"
assert_file "$normal_repo/AGENTS.repo.md"
assert_dir "$normal_repo/plans"
assert_dir "$normal_repo/.agents/skills"
assert_file "$normal_repo/.agents/skills/commit-plan/SKILL.md"

if ! grep -Fq '~/.codex/AGENTS.md' "$normal_repo/AGENTS.repo.md"; then
  printf 'expected generated AGENTS.repo.md to mention ~/.codex/AGENTS.md\n' >&2
  exit 1
fi

if [[ -e "$normal_repo/dot_agents" ]]; then
  printf 'normal repo install should not create dot_agents\n' >&2
  exit 1
fi

chezmoi_repo="$tmp_root/chezmoi-repo"
mkdir -p "$chezmoi_repo"

PATH="$fake_bin:$PATH" "$script_path" --target "$chezmoi_repo" --chezmoi --skill openai-docs >/tmp/install-agent-surface-chezmoi.out

assert_file "$chezmoi_repo/AGENTS.md"
assert_file "$chezmoi_repo/AGENTS.repo.md"
assert_dir "$chezmoi_repo/plans"
assert_dir "$chezmoi_repo/dot_agents/skills"
assert_file "$chezmoi_repo/dot_agents/skills/openai-docs/SKILL.md"

if [[ -e "$chezmoi_repo/.agents" ]]; then
  printf 'chezmoi install should not create .agents\n' >&2
  exit 1
fi

global_home="$tmp_root/global-home"
mkdir -p "$global_home"

AGENT_SURFACE_HOME="$global_home" "$script_path" --global --skill commit-plan >/tmp/install-agent-surface-global.out

assert_file "$global_home/.agents/AGENTS.md"
assert_dir "$global_home/.agents/skills"
assert_file "$global_home/.agents/skills/commit-plan/SKILL.md"
assert_file "$global_home/.codex/AGENTS.md"

if ! grep -Fq 'Canonical Codex instruction document' "$global_home/.codex/AGENTS.md"; then
  printf 'expected global ~/.codex/AGENTS.md to contain canonical Codex instructions\n' >&2
  exit 1
fi
