---
description: >-
  Use when adding a new host to the Nix flake, or editing an existing host's
  aspect list or machine facts. Covers creating the host file, what the
  generator rejects, aspectRequires, class placement, and the planned darwin
  host.
---

# Adding a host

1. **Add `modules/hosts/<hostname>.nix`.** It declares what the machine *is*:
   its aspect list plus machine facts — hostname, `hostPlatform`,
   `stateVersion`, disk layout, monitor geometry. Aspects are host-agnostic
   (Inv. 7); everything machine-specific lives here.
2. **Aspect order matters.** The list determines merge order → `buildEnv`
   order → derivation hashes. When splitting an aspect, put the new names where
   the old one sat.
3. **Host-varying values reach aspects as `_module.args`,** injected by the
   generator. Never `specialArgs`. See `.claude/rules/sharing-values.md`.
4. **Verify:** `./scripts/verify.sh build`.

## What the generator rejects

- a `hostname` that disagrees with its attribute name;
- aspect names that resolve in no class;
- an unmet `aspectRequires`.

**When an aspect depends on another, declare `aspectRequires` in the file that
creates the dependency** — a central table would not know when a file stops
reading.

## Class placement

Home Manager is **standalone** — `homeConfigurations."marcus@<host>"`,
activated separately. Do not convert it to
`home-manager.nixosModules.home-manager`. Six build targets per repo: three
`nixosConfigurations.<host>.config.system.build.toplevel` and three
`homeConfigurations."marcus@<host>".activationPackage`.

| Goes in `homeManager` | Goes in `nixos` / `darwin` |
| --- | --- |
| shell, prompt, editor, git, terminal | services, daemons, systemd/launchd units |
| user packages, dotfiles, keybindings | users, boot, filesystems, networking |
| theming, fonts config, cursor | compositor/session registration, PAM |

**Default to `homeManager`. Justify the exception.**

## The Mac

`mbp` (`aarch64-darwin`) is planned, not present — `systems` is
`["x86_64-linux"]`. Every line put in `nixos` that could have lived in
`homeManager` is a line to be ported later.

Adding `aarch64-darwin` to `systems` will immediately fail any Linux-only
`perSystem.packages`. Exclude by attribute, not by value — see
`.claude/rules/perSystem-platform.md`.

Cross-platform intents (`launcher`, `screenshot`, `clipboard`, `lock`) are
option namespaces in `core`, set by `hyprland` and `dwl`. `notifications` is
deliberately **not** one — mako serves both sessions from one file and nothing
invokes it by command.

## Build where it hurts least

Build on `UM790pro`. Building Hyprland closures on `swift5` drags the whole
chain onto the laptop.
