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
# A target for another platform cannot be built here, so it is compared by
# evaluation: the output path of an input-addressed derivation is fixed by
# evaluation alone, so `nix eval .outPath` is the same signature `nix build`
# would print, minus the build. Those rows say EVAL OK / PASS (eval).
#
# The baseline used to be a fixed `../dotfiles-old` path. That tree is retired,
# and a fixed baseline answers the wrong question anyway: on a long-lived branch
# it reports every commit's differences at once, so a change that moved nothing
# still reads as FAIL. A ref-based baseline compares the change under test.

set -uo pipefail

REPO=$(git rev-parse --show-toplevel) || exit 2

fail=0
pass=0
new=0

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
  # $1 = flake ref, $2 = output
  nix eval --raw "$1#$2" \
    --apply 'o: builtins.concatStringsSep "\n" (builtins.attrNames o)' 2>/dev/null
}

declare -A CLASS
HOSTS=()
for h in $(attrnames . nixosConfigurations); do
  CLASS[$h]=nixos
  HOSTS+=("$h")
done
for h in $(attrnames . darwinConfigurations); do
  CLASS[$h]=darwin
  HOSTS+=("$h")
done
mapfile -t HOME_NAMES < <(attrnames . homeConfigurations)
USER_NAME=${HOME_NAMES[0]:-}
USER_NAME=${USER_NAME%@*}

if ((${#HOSTS[@]} == 0)) || [[ -z $USER_NAME ]]; then
  echo "error: the flake produced no targets; 'nix flake check' will say why"
  exit 2
fi

system_attr() {
  local h=$1
  case ${CLASS[$h]} in
  nixos) echo "nixosConfigurations.\"$h\".config.system.build.toplevel" ;;
  darwin) echo "darwinConfigurations.\"$h\".system" ;;
  esac
}

targets() {
  local h=$1
  system_attr "$h"
  echo "homeConfigurations.\"$USER_NAME@$h\".activationPackage"
}

# The platform is read from the host's own config, so the list of what can be
# built here is measured too. The home shares its host's platform by
# construction in the generator.
LOCAL_SYSTEM=$(nix config show system 2>/dev/null) ||
  LOCAL_SYSTEM=$(nix eval --impure --raw --expr builtins.currentSystem)

platform() {
  local h=$1
  nix eval --raw ".#${CLASS[$h]}Configurations.\"$h\".config.nixpkgs.hostPlatform.system" 2>/dev/null
}

# An unreadable platform must not pass as a foreign one: a host whose platform
# is unknown would be evaluated rather than built, and reported as passing
# without a build ever being attempted.
declare -A NATIVE
for h in "${HOSTS[@]}"; do
  p=$(platform "$h")
  if [[ -z $p ]]; then
    echo "error: could not read the platform of $h; 'nix eval .#${CLASS[$h]}Configurations.\"$h\".config.nixpkgs.hostPlatform.system' will say why"
    exit 2
  fi
  if [[ $p == "$LOCAL_SYSTEM" ]]; then NATIVE[$h]=1; else NATIVE[$h]=0; fi
done

build() {
  # $1 = flake ref, $2 = attr
  nix build --no-link --print-out-paths "$1#$2" 2>/dev/null
}

evaluate() {
  # $1 = flake ref, $2 = attr
  nix eval --raw "$1#$2.outPath" 2>/dev/null
}

signature() {
  # $1 = flake ref, $2 = host, $3 = attr
  if ((NATIVE[$2])); then build "$1" "$3"; else evaluate "$1" "$3"; fi
}

if [[ ${1:-} == build ]]; then
  for h in "${HOSTS[@]}"; do
    while read -r attr; do
      printf '%-70s ' "$h :: ${attr%%.*}"
      if out=$(signature . "$h" "$attr") && [[ -n $out ]]; then
        if ((NATIVE[$h])); then echo "OK"; else echo "EVAL OK"; fi
        pass=$((pass + 1))
      elif ((NATIVE[$h])); then
        echo "BUILD FAILED"
        echo "  retry verbosely:  nix build .#$attr"
        fail=$((fail + 1))
      else
        echo "EVAL FAILED"
        echo "  retry verbosely:  nix eval --raw .#$attr.outPath"
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

# A host the baseline does not produce is new, not broken: the old tree has
# nothing to compare it against, so it is reported and counted apart.
declare -A OLD_HAS
for h in $(attrnames "$baseline" nixosConfigurations) $(attrnames "$baseline" darwinConfigurations); do
  OLD_HAS[$h]=1
done

for h in "${HOSTS[@]}"; do
  while read -r attr; do
    printf '%-50s ' "$h :: ${attr%%.*}"

    if [[ -z ${OLD_HAS[$h]:-} ]]; then
      echo "NEW (not in baseline)"
      new=$((new + 1))
      continue
    fi

    old=$(signature "$baseline" "$h" "$attr")
    if [[ -z $old ]]; then
      if ((NATIVE[$h])); then
        echo "BASELINE BUILD FAILED"
        echo "  nix build $baseline#$attr"
      else
        echo "BASELINE EVAL FAILED"
        echo "  nix eval --raw $baseline#$attr.outPath"
      fi
      fail=$((fail + 1))
      continue
    fi

    new_out=$(signature . "$h" "$attr")
    if [[ -z $new_out ]]; then
      if ((NATIVE[$h])); then
        echo "NEW BUILD FAILED"
        echo "  nix build .#$attr"
      else
        echo "NEW EVAL FAILED"
        echo "  nix eval --raw .#$attr.outPath"
      fi
      fail=$((fail + 1))
      continue
    fi

    if [[ $old == "$new_out" ]]; then
      if ((NATIVE[$h])); then echo "PASS"; else echo "PASS (eval)"; fi
      pass=$((pass + 1))
    else
      echo "FAIL"
      fail=$((fail + 1))
      echo "  old: $old"
      echo "  new: $new_out"
      if ((NATIVE[$h])) && command -v nvd >/dev/null; then
        nvd diff "$old" "$new_out" | sed 's/^/    /'
      fi
      echo "  innocent: an empty diff-closures with a differing path is buildEnv"
      echo "  order, from a file changing rank within its aspect (AGENTS.md §5)."
      echo "  Not innocent: a version change, an unintended package, or a diff"
      echo "  on a host the change predicted would be identical."
    fi
  done < <(targets "$h")
done

echo
if ((new > 0)); then
  echo "$pass passed, $fail failed, $new new"
else
  echo "$pass passed, $fail failed"
fi
[[ $fail -eq 0 ]] || echo "DO NOT COMMIT until all $((pass + fail)) targets PASS or the difference is understood."
exit $((fail > 0))
