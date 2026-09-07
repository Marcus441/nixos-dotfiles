---
paths: "flake.nix,modules/hosts/*.nix,modules/aspects.nix"
---

# `perSystem` and platform breakage

**`perSystem` is where platform breakage bites early.** `systems` carries
`aarch64-darwin` beside `x86_64-linux`, so a Linux-only `perSystem.packages`
fails at once. Exclude by attribute, not by value — `mkIf` gates the value but
still evaluates it:

```nix
packages = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux { foo = …; };  # right
packages.foo = lib.mkIf pkgs.stdenv.hostPlatform.isLinux …;                  # wrong
```
