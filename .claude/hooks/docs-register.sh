#!/usr/bin/env bash
# PostToolUse(Write|Edit): keep the decision register honest as it is edited,
# rather than at commit time when the reasoning has been paged out.
#
# Only fires for files that can break it -- a module carrying pointers, a doc
# holding anchors, or the scripts themselves.
set -uo pipefail

file=$(jq -r '.tool_input.file_path // empty')
[ -n "$file" ] || exit 0

case $file in
*/modules/*.nix | */docs/*.md | */scripts/*.sh) ;;
*) exit 0 ;;
esac

dir="${CLAUDE_PROJECT_DIR:-$PWD}"
check="$dir/scripts/docs-check.sh"
[ -x "$check" ] || exit 0

out=$("$check" 2>&1) || {
  {
    echo "$out"
    echo
    echo "AGENTS.md §10. A pointer must resolve and an anchor must have a"
    echo "referrer -- an entry that outlives its code is a lie the next reader"
    echo "has to disprove. If an aspect moved, run ./scripts/inventory.sh."
  } >&2
  exit 2
}

exit 0
