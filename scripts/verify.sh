#!/usr/bin/env bash
# Verify that the flake produces byte-identical build outputs.
#
#   ./scripts/verify.sh build         build current tree only (smoke test)
#   ./scripts/verify.sh               compare current tree against HEAD~1
#   ./scripts/verify.sh <ref>         compare current tree against any git ref
#   OLD=../tree ./scripts/verify.sh   compare against an existing worktree
#
# PASS means the output store paths are identical, which is a proof of
# equivalence, not an eyeball judgement. Any FAIL must be explained before
# committing.
#
# The baseline used to be a fixed `../dotfiles-old` path. That tree is retired,
# and a fixed baseline answers the wrong question anyway: on a long-lived branch
# it reports every commit's differences at once, so a change that moved nothing
# still reads as FAIL. A ref-based baseline compares the change under test.

set -uo pipefail

REPO=$(git rev-parse --show-toplevel) || exit 2

fail=0
pass=0

# A machine that has never switched to this config has flakes off: enabling
# them is part of the config being installed (modules/nix.nix), so the first
# build predates its own prerequisite. nixos-rebuild passes these itself; a
# bare `nix build` does not.
nl=$'\n'
export NIX_CONFIG="${NIX_CONFIG:+$NIX_CONFIG$nl}extra-experimental-features = nix-command flakes"

# Flakes only see tracked files. This is the single most common cause of
# spurious "path does not exist" errors.
git add -A >/dev/null 2>&1 || true

# The target list is measured, not written down: a host is verified the moment
# the flake produces it, and the username lives in the generator, not here. A
# hardcoded list silently builds three other machines and reports OK.
attrnames() {
  nix eval --raw ".#$1" \
    --apply 'o: builtins.concatStringsSep "\n" (builtins.attrNames o)' 2>/dev/null
}

mapfile -t HOSTS < <(attrnames nixosConfigurations)
mapfile -t HOME_NAMES < <(attrnames homeConfigurations)
USER_NAME=${HOME_NAMES[0]:-}
USER_NAME=${USER_NAME%@*}

if ((${#HOSTS[@]} == 0)) || [[ -z $USER_NAME ]]; then
  echo "error: the flake produced no targets; 'nix flake check' will say why"
  exit 2
fi

targets() {
  local h=$1
  echo "nixosConfigurations.\"$h\".config.system.build.toplevel"
  echo "homeConfigurations.\"$USER_NAME@$h\".activationPackage"
}

build() {
  # $1 = flake ref, $2 = attr
  nix build --no-link --print-out-paths "$1#$2" 2>/dev/null
}

if [[ ${1:-} == build ]]; then
  for h in "${HOSTS[@]}"; do
    while read -r attr; do
      printf '%-70s ' "$h :: ${attr%%.*}"
      if out=$(build . "$attr") && [[ -n $out ]]; then
        echo "OK"
        pass=$((pass + 1))
      else
        echo "BUILD FAILED"
        echo "  retry verbosely:  nix build .#$attr"
        fail=$((fail + 1))
      fi
    done < <(targets "$h")
  done
  echo
  echo "built $pass, failed $fail"
  exit $((fail > 0))
fi

# An explicit OLD points at a tree that already exists and is not ours to
# manage. Otherwise check out the ref ourselves and clean up after.
if [[ -n ${OLD:-} ]]; then
  if [[ ! -d $OLD ]]; then
    echo "error: OLD=$OLD is not a directory"
    exit 2
  fi
  # A hand-managed tree may carry uncommitted edits; a ref worktree cannot.
  git -C "$OLD" add -A >/dev/null 2>&1 || true
  baseline=$OLD
  label_ref=$OLD
else
  ref=${1:-HEAD~1}
  if ! rev=$(git rev-parse --verify --quiet "$ref^{commit}"); then
    echo "error: '$ref' is not a commit"
    exit 2
  fi
  baseline=$(mktemp -d -t verify-baseline-XXXXXX)
  trap 'git -C "$REPO" worktree remove --force "$baseline" >/dev/null 2>&1' EXIT
  if ! git -C "$REPO" worktree add --detach "$baseline" "$rev" >/dev/null 2>&1; then
    echo "error: could not create a worktree at $ref"
    exit 2
  fi
  label_ref="$ref ($(git log -1 --format=%h "$rev"))"
fi

echo "baseline: $label_ref"
echo

command -v nvd >/dev/null || echo "note: nvd not on PATH; diffs will not be explained"

for h in "${HOSTS[@]}"; do
  while read -r attr; do
    printf '%-50s ' "$h :: ${attr%%.*}"

    old=$(build "$baseline" "$attr")
    if [[ -z $old ]]; then
      echo "BASELINE BUILD FAILED"
      echo "  nix build $baseline#$attr"
      fail=$((fail + 1))
      continue
    fi

    new=$(build . "$attr")
    if [[ -z $new ]]; then
      echo "NEW BUILD FAILED"
      echo "  nix build .#$attr"
      fail=$((fail + 1))
      continue
    fi

    if [[ $old == "$new" ]]; then
      echo "PASS"
      pass=$((pass + 1))
    else
      echo "FAIL"
      fail=$((fail + 1))
      echo "  old: $old"
      echo "  new: $new"
      if command -v nvd >/dev/null; then
        nvd diff "$old" "$new" | sed 's/^/    /'
      fi
      echo "  innocent: an empty diff-closures with a differing path is buildEnv"
      echo "  order, from a file changing rank within its aspect (AGENTS.md §5)."
      echo "  Not innocent: a version change, an unintended package, or a diff"
      echo "  on a host the change predicted would be identical."
    fi
  done < <(targets "$h")
done

echo
echo "$pass passed, $fail failed"
[[ $fail -eq 0 ]] || echo "DO NOT COMMIT until this is 6 PASS or the difference is understood."
exit $((fail > 0))
