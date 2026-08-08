#!/usr/bin/env bash
# PreToolUse(Bash): flakes see only tracked files. Stage everything before any
# nix evaluation so a freshly written module is visible to the build.
set -uo pipefail

cmd=$(jq -r '.tool_input.command // empty')
[ -n "$cmd" ] || exit 0

# Only nix-evaluating commands.
grep -Eq '(^|[|;&(`[:space:]])(nix|nix-build|nix-instantiate|nix-shell|nixos-rebuild|darwin-rebuild|home-manager)([[:space:]]|$)|verify\.sh' <<<"$cmd" || exit 0

dir="${CLAUDE_PROJECT_DIR:-$PWD}"
git -C "$dir" rev-parse --git-dir >/dev/null 2>&1 || exit 0

# Nothing unstaged or untracked? Say nothing.
[ -n "$(git -C "$dir" status --porcelain)" ] || exit 0

if git -C "$dir" add -A; then
  echo "hook: staged working tree with 'git add -A' so the flake can see it."
fi

exit 0
