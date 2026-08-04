# Repo context for Claude Code

Personal NixOS config, three hosts, Kanagawa Dragon theming. Currently being
refactored — read `REFACTOR.md` for the plan and follow it step by step. Do not
skip ahead.

## Hard rules

- **`git add -A` before every `nix` command.** Flakes only see git-tracked
  files. Skipping this produces "path does not exist" errors for files that
  are visibly present on disk.
- **Never run `nix flake update`.** Adding a new input and running
  `nix flake lock` is fine. Updating existing pins destroys the verification
  baseline.
- **Never switch.** No `nixos-rebuild switch`, no `nh os switch`, no
  `home-manager switch`. Build only. The human switches.
- **Never edit `hosts/*/hardware-configuration.nix`.** Not regenerable without
  physical access to the machine.
- **No unrequested changes.** No package bumps, no deprecation fixes, no
  reformatting files the current step does not touch. During Phase 2 this
  invalidates the proof that the refactor is behaviour-neutral.
- **Run `./scripts/verify.sh` before every commit.** During Phase 2 it must
  report 6 PASS. If it does not, fix or revert — do not commit and continue.

## Architecture facts

- **Home Manager is standalone**, not a NixOS module. Outputs are
  `homeConfigurations."marcus@<hostname>"`, activated separately. Do not
  convert it to `home-manager.nixosModules.home-manager`.
- **Six build targets:** three `nixosConfigurations.<h>.config.system.build.toplevel`
  and three `homeConfigurations."marcus@<h>".activationPackage`.
- **Hosts:** `swift5` (suckless profile, dev=true, laptop, dwl), `gpc` (maximal,
  dev=false), `UM790pro` (maximal, dev=true, primary machine).
- **User** is `marcus`. **System** is `x86_64-linux` for all hosts.
- Run builds on `UM790pro`. Building maximal closures on `swift5` pulls
  Hyprland and the stylix chain onto the laptop.

## Traps specific to this repo

**The `monitors` shape asymmetry.** The NixOS side receives the entire attrset
returned by `hosts/<h>/monitors.nix`; the home side receives only its
`.monitors` attribute, plus `sensitivity` separately. The two `specialArgs`
therefore carry different shapes under the same name. This is probably a latent
bug, but the legacy modules depend on it. **Reproduce it exactly during Phase 2.
Do not fix it** — the fix is Phase 3 of `REFACTOR.md`, which replaces the whole
passthrough with a typed `options.hosts.<name>.monitors` declaration and
per-consumer renderers. Fixing it early breaks the neutral-diff proof.

**Stylix target auto-enabling.** Stylix enables targets for programs it detects.
Moving a program into a shared/core module means stylix starts theming it on the
maximal hosts, which can silently override an explicit palette. When promoting a
themed program to core, set the stylix target explicitly (`enable = false` if the
program carries its own colours).

**Home configs use `nixpkgs.legacyPackages.${system}`** — no overlays applied.
An overlay declared in the flake will work for NixOS and silently not exist for
Home Manager. Do not change this during Phase 2; it affects every home store
path.

## flake-parts / Dendritic traps (Phase 2)

- The aspect option paths are `flake.modules.nixos.<name>` and
  `flake.modules.homeManager.<name>`. **`flake.homeModules` and
  `flake.homeManagerModules` are not the same thing** and will fail with
  confusing type errors. Do not guess — check flake-parts docs.
- Inside `flake.modules.nixos.foo = { config, ... }: ...`, `config` is the
  **NixOS** config, not flake-parts'. To reference other aspects, capture the
  flake-parts `config` in an outer `let` under a different name:

  ```nix
  { config, ... }:
  let top = config; in {
    flake.modules.nixos.foo = { config, ... }: {
      # `config` here is NixOS; `top.flake.modules...` is flake-parts
    };
  }
  ```
  Getting this wrong produces infinite recursion, not a clear error.
- `import-tree` skips any path containing `/_`. Use `_`-prefixed directories
  for shims and dormant modules that must not be auto-discovered.
- Once import-tree is in place, **every** module file is evaluated for **every**
  host. A syntax error in a maximal-only file breaks the `swift5` build too.
  This is expected, not a regression to work around.

## Working style

- One aspect or one concern per commit. Small diffs, verified individually.
- If a step's verification fails and the cause is not obvious within a couple of
  attempts, stop and report rather than trying progressively larger changes.
- When a step says "audit" or "report", produce the report and stop. Do not
  begin implementing.
