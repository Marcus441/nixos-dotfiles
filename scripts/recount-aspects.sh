#!/usr/bin/env bash
# Recount how many files declare more than one aspect (AGENTS.md §2).
# The two numbers go stale silently. Files declaring no aspect are not counted.
set -euo pipefail

total=0
multi=0
while IFS= read -r f; do
  count=$({ grep -ohE 'flake\.modules\.[a-zA-Z]+\.[a-zA-Z0-9_-]+' "$f" || true; } | sort -u | wc -l)
  if [ "$count" -ge 1 ]; then
    total=$((total + 1))
  fi
  if [ "$count" -ge 2 ]; then
    multi=$((multi + 1))
  fi
done < <(find modules -name '*.nix' ! -path '*/_*')

echo "$multi of $total files declare more than one aspect or class"
