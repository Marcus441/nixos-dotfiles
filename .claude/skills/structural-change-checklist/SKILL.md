---
description: >-
  Use before committing a structural change — moving, renaming, or regrouping
  files; adding, splitting, or renaming aspects; changing a host's aspect list;
  editing the generator or aspects.nix. Runs the invariant self-check,
  anti-pattern scan, and verification steps. Triggers: move a file, rename an
  aspect, split an aspect, regroup modules, reorder a host's aspects, edit
  generator.nix, edit aspects.nix, prove nothing changed, diff-closures.
---

# Structural change checklist

**Structural** = moving/renaming/regrouping files, adding/splitting/renaming
aspects, changing a host's aspect list, editing `modules/hosts/generator.nix`
or `modules/aspects.nix`.

## 1. Self-check

Walk `AGENTS.md` §1 (invariants) and §9 (anti-pattern table). If the change
would violate one, **stop and say so** — do not silently bend a rule.

The directory test: a directory names one feature that outgrew one file.
Same-aspect contents are fine; class, host, magnitude, and grab-bag "type"
names are not. A directory holding one module file is flattened.

## 2. Ordering

Aspect order in a host's list reaches derivation hashes (§5). When splitting an
aspect, put the new names where the old one sat. Only the relative order of
files contributing to the *same* aspect matters.

**Measure; do not predict.** Measurements have produced results the model does
not explain — `windowTags` rendered in reverse of aspect-list order.

## 3. Verify

```bash
./scripts/verify.sh build        # all six targets build
./scripts/verify.sh <ref>        # no arg = HEAD~1; proves nothing moved but order
./scripts/docs-check.sh          # pointers, orphan anchors, budgets, inventory
./scripts/inventory.sh           # regenerate docs/inventory.md if aspects changed
nix flake check                  # cheap eval sweep
```

Predict the six-target signature **before** running it, and justify every FAIL.
An empty `diff-closures` with a differing path is `buildEnv` order; a version
change, an unintended package, or a diff on a host you predicted identical is
not. `swift5` takes neither Hyprland nor `apps` — a useful control.

Full recipe: `.claude/rules/structural-verification.md`.

## 4. Debugging

**Bisect eval errors** by renaming a file to `_name.nix` — `import-tree` skips
it. Halve the tree until the build recovers. Undo before committing.

**Inspect merged aspects:** `nix repl` → `:lf .` →
`config.flake.modules.homeManager.hyprland`.

## 5. Commit

- Did an aspect appear, vanish, or change hosts? Re-run `./scripts/inventory.sh`
  and commit `docs/inventory.md` with the change.
- Did a decision's code move or die? Its `docs/` entry moves or dies in the same
  commit (`AGENTS.md` §10). `docs-check.sh` enforces the second half.
- Small, single-concern commit; rationale and the predicted signature in the
  message.
- If the task touched a file under §8 *Known divergences*, migrate it in the
  same change or state why not.
