---
description: >-
  Use when adding a package, an overlay, or a flake input. Covers
  perSystem.packages placement, the Home Manager overlay trap, platform
  exclusion, and the rules around flake.lock.
---

# Adding a package, overlay, or flake input

## Add a package or overlay

`perSystem.packages.<name>` **in the file that uses it.** Never in a `pkgs/`
or `overlays/` directory — those break feature closure (Inv. 4, Inv. 1).

> **Trap:** home configs are built on `nixpkgs.legacyPackages.${system}`, so an
> overlay declared in the flake reaches NixOS and **silently does not exist for
> Home Manager.** `callPackage` directly, or change the generator deliberately.

Platform-gate by attribute, not by value — `mkIf` gates the value but still
evaluates it:

```nix
packages = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux { foo = …; };  # right
packages.foo = lib.mkIf pkgs.stdenv.hostPlatform.isLinux …;                  # wrong
```

Derivations consumed by `callPackage` are non-modules and belong under a `/_`
path, which `import-tree` skips. `/_` is not a grouping mechanism.

## Add a flake input

Edit `flake.nix` — it is a manifest (inputs + `mkFlake` + `import-tree`), and
adding an input is the only routine reason to touch it.

**Never run `nix flake update`.** It moves existing pins. Adding an input and
running `nix flake lock` is fine. A PreToolUse hook blocks the bare update
command; do not work around it — if the human wants pins moved, they will say so.

## Unresolved — ask rather than inventing

Whether custom packages should be flake outputs, overlay entries, or both is
still undecided. So is secrets management (sops-nix vs agenix). Ask.

## Do not introduce a framework

`den`, `snowfall`, `flake-file`, `easy-hosts` — not without being asked. This
repo depends on `flake-parts` and `import-tree` only.

## Verify

`./scripts/verify.sh build` — all six targets. `nix flake check` is a cheap
eval sweep, not a substitute.
