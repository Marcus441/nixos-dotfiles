---
paths: "modules/hosts/**,modules/aspects.nix"
---

# Host wiring

`modules/hosts/generator.nix` is **the ONE permitted central wiring point** —
the only place a manual import list is allowed (Inv. 6).
`modules/hosts/record.nix` is the typed host record it consumes.
`modules/hosts/<hostname>.nix` says what a machine *is*: aspects plus machine
facts (hostname, `hostPlatform`, `stateVersion`, disk layout, monitors).

## What the generator rejects

- a `hostname` that disagrees with its attribute name;
- aspect names that resolve in no class;
- an unmet `aspectRequires`.

**When an aspect depends on another, declare `aspectRequires` in the file that
creates the dependency** — a central table would not know when a file stops
reading. Example: `bar/dwl-bar.nix` declares `aspectRequires.dwl-bar =
["dwl"]`; `quickshell.nix` declares `aspectRequires.quickshell = ["hyprland"]`.

## Aspect order is load-bearing

A host's aspect list determines merge order, which determines `buildEnv` order,
which reaches derivation hashes. When splitting an aspect, put the new names
where the old one sat. Measure with the diff-closures recipe
(`structural-verification.md`); do not predict.

## Home Manager is standalone

`homeConfigurations."marcus@<host>"`, activated separately. **Do not convert it
to `home-manager.nixosModules.home-manager`.**

> **Overlay trap:** home configs are built on `nixpkgs.legacyPackages.${system}`,
> so an overlay declared in the flake reaches NixOS and **silently does not
> exist for Home Manager.** `callPackage` directly, or change the generator
> deliberately.

## Cross-platform intents

`launcher`, `screenshot`, `clipboard`, and `lock` are option namespaces in
`core`, set by `hyprland` and `dwl`. `notifications` is deliberately **not**
one — mako serves dwl from the `dwl` aspect, quickshell claims the D-Bus name
on Hyprland hosts, and nothing invokes either by command.

## The Mac

`mbp` does not exist yet and `systems` is `["x86_64-linux"]`. Every line put in
`nixos` that could have lived in `homeManager` is a line to be ported later.
Default to `homeManager`; justify the exception.

`perSystem` is where platform breakage bites first — see
`perSystem-platform.md`.
