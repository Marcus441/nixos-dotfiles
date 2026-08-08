---
paths: "scripts/*"
---

# Structural verification — the diff-closures recipe

**The ordering model is a working model, not a mechanism.** Measurements have
produced results it does not predict (e.g. `windowTags` rendered in reverse of
aspect list order). A position-preserving move is free even though it changes
`_file`. Measure with the recipe below; do not predict.

For structural changes, prove nothing changed but order:

```bash
git worktree add ../dotfiles-prev <previous-commit>

for h in swift5 gpc UM790pro; do
  echo "=== $h ==="
  old=$(nix build --no-link --print-out-paths \
        "../dotfiles-prev#homeConfigurations.\"marcus@$h\".activationPackage")
  new=$(nix build --no-link --print-out-paths \
        ".#homeConfigurations.\"marcus@$h\".activationPackage")
  nix store diff-closures "$old" "$new"          # must be EMPTY
  diff -rq "$old/home-files" "$new/home-files"   # only intended files

  oldt=$(nix build --no-link --print-out-paths \
         "../dotfiles-prev#nixosConfigurations.$h.config.system.build.toplevel")
  newt=$(nix build --no-link --print-out-paths \
         ".#nixosConfigurations.$h.config.system.build.toplevel")
  diff -rq "$oldt/etc" "$newt/etc" 2>&1 | grep -v "^diff:.*No such file"
done

git worktree remove ../dotfiles-prev
```

`swift5` takes neither Hyprland nor `apps` — a useful control for work on those.

`scripts/verify.sh <ref>` automates this comparison against any git ref
(`verify.sh` with no argument compares against `HEAD~1`; `verify.sh build`
builds the current tree only).
