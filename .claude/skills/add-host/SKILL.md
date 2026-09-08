---
description: >-
  Use when adding a new host to the Nix flake, or editing an existing host's
  aspect list or machine facts. Covers creating the host file, what the
  generator rejects, aspectRequires, class placement, and darwin hosts.
  Triggers: add a host, new machine, host record, aspect list, monitors,
  stateVersion, hardware-configuration, aspectRequires, mbp, darwin, aarch64.
---

# Adding or editing a host

Class placement is `AGENTS.md` §6; the generator's mechanics and the Home
Manager overlay trap are `.claude/rules/host-wiring.md`. This is the procedure.

## Steps

1. **Copy the hardware config** to `hosts/<hostname>/hardware-configuration.nix`.
   It is machine-generated and never edited by hand. A Mac has none: write
   `hardware = null` in the record.
2. **Write `modules/hosts/<hostname>.nix`** — the aspect list plus machine
   facts. `modules/hosts/record.nix` is the typed record; the argument pattern
   is strict, so a missing field is an evaluation error rather than a silently
   absent module. Copy an existing host file for the shape.
3. **Order the aspect list deliberately.** It sets merge order, which reaches
   derivation hashes (§5).
4. **Verify:** `./scripts/verify.sh build`, then `./scripts/inventory.sh` —
   the host and its aspects are generated into `docs/inventory.md`, not written
   into prose anywhere.

## What the generator rejects

- a `hostname` that disagrees with its attribute name;
- aspect names that resolve in no class;
- an unmet `aspectRequires`;
- a `hardware` that disagrees with the platform: `null` on a NixOS host, a
  path on a darwin host.

**When an aspect depends on another, declare `aspectRequires` in the file that
creates the dependency** — a central table would not know when a file stops
reading. Current dependencies are in `docs/inventory.md`.

## Host-varying values

They reach aspects as `_module.args`, injected by the generator. Never
`specialArgs`. An aspect is one value shared by every host that takes it, so it
cannot specialise on a host fact (Inv. 7) — if config must depend on one, that
is a *decision*, and decisions belong in the aspect list.

## The Mac

A host whose `system` ends in `-darwin` is built by nix-darwin; the class is
derived from the platform, never written down. Its `stateVersion` is
nix-darwin's integer, its `machine` block sets `networking.hostName`,
`computerName` and `localHostName`, and its aspects are the ones with a
`darwin` half — `docs/inventory.md` lists the classes each aspect declares.
Every line put in `nixos` that could have lived in `homeManager` is a line the
Mac does not get. Nothing here can build or switch a darwin target: the Mac
does that itself (README, "Installing").

## Build where it hurts least

Build on `UM790pro`. Hyprland closures on `swift5` drag the whole chain onto
the laptop.
