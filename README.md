# NixOS Config

My personal NixOS configuration, featuring a Kanagawa Dragon themed desktop.

It follows **the dendritic pattern**: every `.nix` file under `modules/` is a
flake-parts module, and NixOS / home-manager modules are stored as option values
under `flake.modules.<class>.<aspect>` rather than imported from paths. There are
no profile directories and no per-class trees — a host is a short list of aspect
names, and adding a feature means adding one file.

`CLAUDE.md` is the authority on the pattern and its invariants. This file only
covers getting a machine running. [`docs/`](docs/) holds the reasoning:
[`conventions/`](docs/conventions) for the patterns that recur across files,
[`decisions/`](docs/decisions) for why an individual file made the call it made.

## Inspiration and Attribution

The pattern is not mine, and neither is most of the reasoning behind it. What
each source actually contributed:

**[mightyiam/dendritic](https://github.com/mightyiam/dendritic)** — the
canonical specification, by **mightyiam** (Rodrigo Morales). Invariants 1–4 in
`CLAUDE.md` are its rules restated: one file per feature across every
configuration that feature touches, lower-level modules held as
`deferredModule` *option values* rather than imported from paths, and file paths
that name a feature without encoding a class or a host. Its own caveat — the
pattern is "not a religion, law or a mandate" — is why `CLAUDE.md` §8 tracks
where this repo diverges instead of pretending it doesn't.

**[The Dendritic Pattern — NixOS
Discourse](https://discourse.nixos.org/t/the-dendritic-pattern/61271)** —
mightyiam's announcement thread. The point taken from it is that every file is a
*flake-parts* module, not merely a NixOS one; that is what lets a single file
declare both a `nixos` and a `homeManager` membership, which is the shape of
nearly every file under `modules/`. vic's `rdesk.nix` in that thread is the
example those files follow. The thread's recurring complaint — that lazy
evaluation makes this read as black magic — is why `CLAUDE.md` opens with a
mental model rather than a file tour.

**[Doc-Steve/dendritic-design-with-flake-parts](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)**
— a guide by **Doc-Steve** that extends the pattern with a catalog of reusable
*Aspect* shapes. This is where the vocabulary of aspects comes from, and its
Collector and Constants shapes are what `windowTags` and the `desktop.colors`
palette turned into here: many files writing one value, one file reading it.

**[import-tree](https://github.com/vic/import-tree)** — the auto-import library,
by **vic** (pinned in `flake.nix` from its `denful/import-tree` location).
`flake.nix` is a manifest only because this exists. Its rule that paths
containing `/_` are skipped — `hasInfix "/_"` against the full path — is the
only way anything under `modules/` escapes auto-discovery, which is what
`modules/_pkgs`, `modules/_walker` and `modules/_dormant` all depend on.

**[Search for best dotfiles structure: Dendritic
edition](https://discourse.nixos.org/t/search-for-best-dotfiles-structure-dendritic-edition/75134)**
— the counterweight thread, where people report living with the pattern:
complexity outgrowing the configuration it serves, fuzzy-finding by filename
getting worse, and NixOS and home-manager configurations becoming hard to
decouple. That last one shaped two choices here — Home Manager stays
**standalone**, and `verify.sh` builds all six targets rather than trusting
`nixos-rebuild` to cover them. The alternatives raised there (`flake-aspects`,
`den`, `flake-fhs`, `unify`) are deliberately not used; this repo stays on
flake-parts and import-tree.

**[nixos-config-reborn](https://github.com/Andrey0189/nixos-config-reborn)** by
**@Andrey0189** — where this configuration began, and how I learned most of what
it does. Very little of that structure survived the dendritic refactor, but the
code is descended from it, so this repository remains licensed under the **GNU
General Public License v3.0 (GPL-3.0)** in accordance with the original. A copy
is in `LICENSE`.

## Hosts

| Host | Machine | Session | Aspects |
| --- | --- | --- | --- |
| `swift5` | laptop | dwl (Wayland) | `dev core laptop dwl dwl-bar` |
| `gpc` | gaming rig | Hyprland | `core gaming nvidia hyprland waybar wleave thunar apps` |
| `UM790pro` | dev machine | Hyprland | `dev core hyprland waybar thunar apps` |

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
| `hyprland` | Hyprland session: hypridle, hyprlock, hyprpaper |
| `dwl` | dwl session: a patched dwl, wmenu |
| `dwl-bar` | dwl's bar: the patch that draws it and the status pipe that feeds it |
| `waybar` | Hyprland's bar — it reads Hyprland's IPC |
| `wleave` | The power menu |
| `thunar` | Thunar as the file manager |
| `yazi` | yazi as the file manager instead — the program itself is in `apps` |
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

`hyprland` and `dwl` are mutually exclusive, and each pairs with its own bar.
Theming is not an aspect: colours, fonts and the cursor live in `core`, so every
host is themed the same way — `modules/theme/` is navigation, and every file in
it declares `core`. The palette is base24 Kanagawa Dragon, rendered
twice — `desktop.colors` for anything taking hex, and `desktop.colors16`, its
`base00`–`base0F` subset, for anything that reaches a terminal. ANSI has sixteen
slots and cannot carry the extension, so a program asking for *the base16 theme*
gets exactly what it assumes.

Portable intents — `launcher`, `terminal`, `screenshot`, `clipboard`, `lock`,
`logout`, `bar`, `fileManager`, `powerMenu` — are option namespaces in `core`,
set by whichever aspect provides the thing, so nothing binds a session-specific
command directly. A bind whose intent no aspect supplies is omitted rather than
rendered dead. `windowTags` runs the same idea backwards: every file that
installs a window appends its own class regexes, and the Hyprland rules are the
only reader, so a dwl host carries the value inertly.

Three aspects require another, declared in the file that creates the dependency
rather than in a central table: `waybar` needs `hyprland`, `dwl-bar` needs `dwl`,
and `yazi` needs `apps` — the role without the program resolves to a real but
unconfigured binary, which is worse than an error. The generator refuses the
host by name instead.

## Layout

```text
flake.nix                    inputs + mkFlake + import-tree. Rarely touched.
statix.toml                  lint config; see .claude/rules/settled-decisions.md
modules/
  aspects.nix                declares the flake.modules and aspectRequires options
  hosts/generator.nix        builds both output sets from each host record
  hosts/record.nix           the typed host record the generator consumes
  hosts/<hostname>.nix       what the machine IS: aspects + machine facts
  bar/                       waybar and dwl-bar
  cli/                       terminal tools, across core and apps
  display/                   monitor geometry and the renderers that consume it
  filemanager/               thunar and yazi
  media/                     players, viewers and editors
  theme/                     colours, fonts, cursor, GTK and Qt
  <concern>.nix              one concern; declares its own aspect membership
  <intent>/                  implementations of one intent, in different aspects
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
   git clone https://github.com/Marcus441/nixos-dotfiles.git ~/.dotfiles/flake
   cd ~/.dotfiles/flake
   ```

   The location is load-bearing: `modules/nh.nix` points `programs.nh.flake` at
   `/home/<user>/.dotfiles/flake`, so `nh os switch` finds nothing if the tree
   lives anywhere else.

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
       aspects = ["core" "hyprland" "apps"];

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
   cannot drift apart. It rejects a `hostname` that disagrees with its attribute,
   an aspect name that resolves in no class, and an aspect list that leaves an
   `aspectRequires` entry unmet (the three above).

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
than the change. `.claude/rules/structural-verification.md` carries the full
recipe.

## Contributions

You can make a pr if you really want, but I'll probably just ignore it because
these are my personal configs.
