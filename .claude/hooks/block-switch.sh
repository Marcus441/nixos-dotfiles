#!/usr/bin/env bash
# PreToolUse(Bash): build only — the human switches.
set -uo pipefail

cmd=$(jq -r '.tool_input.command // empty')
[ -n "$cmd" ] || exit 0

if grep -Eq '(nixos-rebuild|darwin-rebuild|home-manager|nh[[:space:]]+(os|home|darwin))[^|;&]*[[:space:]]switch([[:space:]]|$)' <<<"$cmd" \
   || grep -Eq 'switch-to-configuration' <<<"$cmd"; then
  echo "Blocked: build only. The human switches." >&2
  exit 2
fi

exit 0
