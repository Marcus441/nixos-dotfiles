# NixOS Config

My personal NixOS configuration, featuring a Kanagawa Dragon themed desktop.

It follows **the dendritic pattern**: every `.nix` file under `modules/` is a
flake-parts module, and NixOS / home-manager modules are stored as option values
under `flake.modules.<class>.<aspect>` rather than imported from paths. There are
no profile directories and no per-class trees — a host is a short list of aspect
names, and adding a feature means adding one file.

`CLAUDE.md` is the authority on the pattern and its invariants. This file only
covers getting a machine running.

## Inspiration and Attribution

This project is heavily derived from concepts and ideas found in
[nixos-config-reborn](https://github.com/Andrey0189/nixos-config-reborn) by
**@Andrey0189**. Their YouTube guides and repository were extremely helpful in
my own configuration.

As this configuration builds upon their foundational work, it is also licensed
under the **GNU General Public License v3.0 (GPL-3.0)**, in accordance with the
original project's licensing. You can find a copy of the license in the
`LICENSE` file within this repository.

## Hosts

| Host | Machine | Session | Aspects |
| --- | --- | --- | --- |
| `swift5` | laptop | dwl (Wayland) | `dev core laptop dwl palette` |
| `gpc` | gaming rig | Hyprland | `core gaming nvidia hyprland stylix apps` |
| `UM790pro` | dev machine | Hyprland | `dev core hyprland stylix apps` |

Six build targets: three `nixosConfigurations.<host>` and three
`homeConfigurations."marcus@<host>"`. Home Manager is **standalone**, activated
separately rather than as a NixOS module.

## Aspects

An aspect is a decision or a capability that some host declines. It is not a
magnitude and not a host archetype — the archetype is the *list*, not an entry
in it.

| Aspect | Meaning |
| --- | --- |
| `core` | Everything no host opts out of |
| `hyprland` | Hyprland session: waybar, hypridle, hyprlock, hyprpaper |
| `dwl` | dwl session: a patched dwl, wmenu |
| `stylix` | Theming driven by stylix from a base16 scheme |
| `palette` | Theming from a hand-carried base24 palette, no stylix |
| `apps` | The heavy app set: thunderbird, discord, obs, kdenlive, yazi |
| `dev` | Docker, qemu, aarch64 binfmt, ccache |
| `gaming` | Steam and gamemode |
| `nvidia` | NVIDIA drivers |
| `laptop` | Wifi powersave, backlight, a longer battery-notification timeout |

`laptop` is deliberately small: `power-profiles-daemon` and `upower` stay in
`core`, because waybar runs a battery module on the desktops too and a too-small
aspect is recoverable where a broken power path is not. The terminal (`foot`),
the editor and the shell are `core` — every host gets them regardless of
session.

`hyprland` and `dwl` are mutually exclusive, as are `stylix` and `palette`.
Portable intents — `launcher`, `screenshot`, `clipboard`, `lock` — are option
namespaces set by whichever session aspect a host takes, so nothing binds a
session-specific command directly.

## Layout

```
flake.nix                    inputs + mkFlake + import-tree. Rarely touched.
statix.toml                  lint config; see CLAUDE.md §13 for the one refusal
modules/
  aspects.nix                declares the flake.modules option
  hosts/generator.nix        builds both output sets from each host record
  hosts/record.nix           the typed host record the generator consumes
  hosts/<hostname>.nix       what the machine IS: aspects + machine facts
  display/                   monitor renderers
  <concern>.nix              one concern; declares its own aspect membership
hosts/<hostname>/            hardware-configuration.nix only (machine-generated)
scripts/verify.sh            builds or compares all six targets
```

File paths carry no meaning — a path never encodes a class, a host or an
aspect. Membership is declared inside each file, so files move freely.

## Adding a host

Everything a machine needs lives in one file. There is no central list to edit
and no profile to pick.

1. **Install NixOS** using the official
   [installation guide](https://nixos.org/manual/nixos/stable/#sec-installation),
   then clone this repository:

   ```bash
   git clone https://github.com/Marcus441/nixos-dotfiles.git ~/dotfiles/flake
   cd ~/dotfiles/flake
   ```

2. **Drop in the hardware config.** This is the one machine-generated file, and
   it is never edited by hand:

   ```bash
   mkdir -p hosts/<hostname>
   cp /etc/nixos/hardware-configuration.nix hosts/<hostname>/
   ```

3. **Write `modules/hosts/<hostname>.nix`.** The record is matched strictly, so
   every field below must be present — a typo is an evaluation error rather than
   a silently missing module:

   ```nix
   _: {
     hosts.<hostname> = {
       hostname = "<hostname>";          # must equal the attribute name
       system = "x86_64-linux";
       stateVersion = "25.11";

       # What this machine is. Order is load-bearing: it sets module merge
       # order, which reaches derivation hashes.
       aspects = ["core" "hyprland" "stylix" "apps"];

       fontSize = 12;
       hardware = ../../hosts/<hostname>/hardware-configuration.nix;

       # name, width and height are required; description defaults to null and
       # refresh to 60. A description is an EDID string from `hyprctl monitors
       # -j`, which survives replugging where a connector does not.
       monitors = [
         {
           name = "DP-1";
           width = 2560;
           height = 1440;
           refresh = 144;
         }
       ];
       input.sensitivity = 0;

       packages = {pkgs, ...}: {
         environment.systemPackages = with pkgs; [];
       };

       nixos = {
         pkgs,
         stateVersion,
         hostname,
         ...
       }: {
         networking.hostName = hostname;
         system.stateVersion = stateVersion;
       };
     };
   }
   ```

   The generator derives both `nixosConfigurations.<hostname>` and
   `homeConfigurations."marcus@<hostname>"` from the attribute name, so they
   cannot drift apart. It rejects a `hostname` that disagrees with its attribute
   and an aspect name that resolves in no class.

4. **Build before switching.** Flakes only see tracked files, so stage first:

   ```bash
   git add -A
   ./scripts/verify.sh build          # all six targets
   ```

5. **Switch.**

   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   home-manager switch --flake .#marcus@<hostname>

   # after the first install, nh is the daily driver
   nh os switch
   nh home switch
   ```

## Adding a feature

Create `modules/<concern>.nix` and declare which aspects it contributes to. One
file may serve several aspects and both classes at once — that is the pattern
working, not duplication:

```nix
_: {
  flake.modules.homeManager.core = [ {programs.foo.enable = true;} ];
  flake.modules.nixos.hyprland   = [ {services.foo.enable = true;} ];
}
```

Nothing imports it: `import-tree` discovers every file under `modules/`. To
extend an existing feature, add another file targeting the same aspect rather
than growing one file or adding an enable flag.

Custom packages go in `perSystem.packages` in the file that uses them — there is
no `pkgs/` or `overlays/` directory, because a derivation belongs beside the
config that consumes it.

## Verifying

```bash
./scripts/verify.sh build                    # build all six targets
./scripts/verify.sh                          # compare six targets against HEAD~1
./scripts/verify.sh <ref>                    # compare against any git ref
OLD=../previous ./scripts/verify.sh          # compare against an existing worktree
nix flake check                              # cheap eval sweep
```

For structural changes, prove nothing moved but order. Compare-mode checks out
the baseline ref itself and cleans up after; `./scripts/verify.sh HEAD` on a
clean tree is a no-op that must report 6 PASS, which tests the harness rather
than the change. `CLAUDE.md` §10 carries the full recipe.

## Contributions

You can make a pr if you really want, but I'll probably just ignore it because
these are my personal configs.
