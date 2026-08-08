---
paths: "flake.nix,modules/hosts/*.nix,modules/aspects.nix"
---

# `perSystem` and platform breakage

**`perSystem` is where platform breakage bites early.** Adding `aarch64-darwin`
to `systems` will immediately fail any Linux-only `perSystem.packages`. Exclude
by attribute, not by value — `mkIf` gates the value but still evaluates it:

```nix
packages = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux { foo = …; };  # right
packages.foo = lib.mkIf pkgs.stdenv.hostPlatform.isLinux …;                  # wrong
```
