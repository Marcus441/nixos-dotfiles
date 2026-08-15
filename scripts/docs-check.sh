#!/usr/bin/env bash
# Keep the decision register honest. Every check here is a rot the tree has
# actually suffered, so each failure names the file and what to do.
#
#   ./scripts/docs-check.sh

set -uo pipefail

cd "$(git rev-parse --show-toplevel)"

bad=0
fail() {
  echo "$1" >&2
  bad=1
}

# 1. Pointer form. The prefix is what makes the register greppable; prose that
#    merely mentions a docs path is invisible to every check below.
while IFS= read -r hit; do
  file=${hit%%:*}
  rest=${hit#*:}
  line=${rest%%:*}
  text=${rest#*:}
  case $text in
  *'# load-bearing: docs/'*)
    echo "$text" | grep -qE '# load-bearing: docs/(decisions|conventions)/[a-z0-9-]+\.md#[a-z0-9-]+$' ||
      fail "$file:$line: malformed pointer; want '# load-bearing: docs/<area>/<file>.md#<anchor>'"
    ;;
  *)
    fail "$file:$line: mentions docs/ outside the pointer form; use '# load-bearing: …'"
    ;;
  esac
done < <(grep -rn 'docs/decisions\|docs/conventions' modules --include='*.nix')

# 2. Every pointer resolves to a real anchor in a real file.
while IFS= read -r ref; do
  f=${ref%%#*}
  a=${ref#*#}
  if [ ! -f "$f" ]; then
    fail "pointer target missing: $f"
  elif ! grep -q "<a id=\"$a\"></a>" "$f"; then
    fail "pointer anchor missing: $f#$a"
  fi
done < <(grep -rhoE '# load-bearing: docs/\S+' modules --include='*.nix' |
  sed 's/# load-bearing: //' | sort -u)

# 3. No orphan anchors. This is the growth brake: docs/ has only ever grown
#    because an entry outlives the code it explains. An anchor nothing points
#    at is either a missing pointer or a dead entry.
while IFS= read -r anchor; do
  f=${anchor%%#*}
  a=${anchor#*#}
  if ! grep -rq "$f#$a" modules --include='*.nix' &&
    ! grep -rq "$f#$a" docs .claude --include='*.md'; then
    fail "orphan anchor: $f#$a — add the pointer, or retire the entry with the code it explained"
  fi
done < <(grep -rn '<a id=' docs --include='*.md' |
  sed 's/:[0-9]*:<a id="/#/; s/"><\/a>//' | sort -u)

# 4. The generated inventory is the only place a host/aspect fact may live.
./scripts/inventory.sh --check || bad=1

# 5. Budgets. The entry cap is the real discipline — it bounds what an agent
#    reads to resolve one pointer, and it is what a measurement narrative
#    overruns. The file cap only catches a file that has become a grab-bag.
while IFS= read -r f; do
  n=$(wc -l <"$f")
  if [ "$n" -gt 350 ]; then
    fail "$f: $n lines (cap 350) — split it by subject"
  fi
  while IFS= read -r over; do fail "$over"; done < <(awk -v F="$f" '
    function check() {
      if (n > 22) printf "%s:%d: entry is %d lines (cap 22 prose lines) — Why and Breaks, not a narrative\n", F, start, n
    }
    {
      isAnchor = ($0 ~ /^<a id=/); isHead = ($0 ~ /^## /)
      if (isAnchor || (isHead && !prevWasAnchor)) {
        if (started) check()
        start = NR; n = 0; started = 1
      }
      if (started && $0 !~ /^\|/) n++
      prevWasAnchor = isAnchor
    }
    END { if (started) check() }' "$f")
done < <(find docs -name '*.md' ! -name inventory.md)

# 6. inventory.sh reads aspect names with grep, which is only sound while every
#    name is a literal.
if grep -rn 'flake\.modules\.\${' modules --include='*.nix' |
  grep -qv 'hosts/generator.nix'; then
  fail "computed aspect name outside the generator — inventory.sh can no longer read the tree with grep"
fi

if [ "$bad" -eq 0 ]; then echo "docs-check: OK"; fi
exit "$bad"
