# NixOS Config

My personal NixOS configuration, featuring a Kanagawa Dragon themed desktop.

It follows **the dendritic pattern**: every `.nix` file under `modules/` is a
flake-parts module, and NixOS / home-manager modules are stored as option values
under `flake.modules.<class>.<aspect>` rather than imported from paths. There are
no profile directories and no per-class trees — a host is a short list of aspect
names, and adding a feature means adding one file.

## Inspiration and Attribution

The pattern is not mine, and neither is most of the reasoning behind it. What
each source actually contributed:

**[mightyiam/dendritic](https://github.com/mightyiam/dendritic)**

**[The Dendritic Pattern — NixOS
Discourse](https://discourse.nixos.org/t/the-dendritic-pattern/61271)** —

**[Doc-Steve/dendritic-design-with-flake-parts](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)**

**[import-tree](https://github.com/vic/import-tree)** — the auto-import library,

**[Search for best dotfiles structure: Dendritic
edition](https://discourse.nixos.org/t/search-for-best-dotfiles-structure-dendritic-edition/75134)**

## Hosts and aspects

Every host is two build targets: its system —
`nixosConfigurations.<host>` or `darwinConfigurations.<host>` — and its home,
`homeConfigurations."marcus@<host>"`. Home Manager is **standalone**, activated
separately rather than as a NixOS or nix-darwin module.

## Installing

1. **Install NixOS** using the official
   [installation guide](https://nixos.org/manual/nixos/stable/#sec-installation),
   then clone this repository:

   ```bash
   git clone https://github.com/Marcus441/nixos-dotfiles.git ~/.dotfiles/flake
   cd ~/.dotfiles/flake
   ```

2. **Drop in the hardware config** — the one machine-generated file, never
   edited by hand:

   ```bash
   mkdir -p hosts/<hostname>
   cp /etc/nixos/hardware-configuration.nix hosts/<hostname>/
   ```

3. **Write `modules/hosts/<hostname>.nix`** — the aspect list plus this
   machine's facts. Copy an existing host file; the record is matched strictly,
   so a missing field is an evaluation error rather than a silently absent
   module.

4. **Activate.** Flakes only see tracked files, so stage first:

   ```bash
   git add -A
   ```

   Then switch

   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   home-manager switch --flake .#<user>@<hostname>
   ```

   After that it is `nh os` / `nh home` as the daily driver.
