# NixOS Config

This is my personal NixOS configuration, featuring a Kanagawa Dragon themed
desktop environment.

## Inspiration and Attribution

This project is heavily derived from concepts and ideas found in
[nixos-config-reborn](https://github.com/Andrey0189/nixos-config-reborn) by
**@Andrey0189**. Their YouTube guides and repository were extremely helpful in
my own configuration.

As this configuration builds upon their foundational work, it is also licensed
under the **GNU General Public License v3.0 (GPL-3.0)**, in accordance with the
original project's licensing. You can find a copy of the license in the
`LICENSE` file within this repository.

## Features

- **Kanagawa Dragon Theme:** A consistent and eye-pleasing muted yet saturated
  theme across both profiles
- **Two desktop profiles**, selected per host in `flake.nix`:
  - **maximal:** Hyprland with walker, waybar, fish + starship, ghostty,
    tmux and stylix-driven (base16) theming
  - **suckless:** dwl (bar patch) with foot, wmenu, mako and bash, themed by a
    hand-carried base24 palette (`home-manager/profiles/suckless/colors.nix`)
    instead of stylix
- **Per-host `dev` toggle:** docker, qemu/quickemu, aarch64 binfmt emulation
  and ccache are gated behind a `dev` flag per host (`nixos/dev`); compilers
  come from project devshells, not the system
- **Flake templates registry:** `nix flake init -t templates#<name>` resolves
  to [nix-templates](https://github.com/Marcus441/nix-templates) on every host
- **Neovim** from a dedicated flake:
  [neovim.nix](https://github.com/Marcus441/neovim.nix)
- **Multiple Hosts:** Designed to be easily adaptable for various machines
- **Home Manager Integration:** Seamless management of user-specific
  configurations

## Layout

```
flake.nix              hosts (hostname/stateVersion/profile/dev) and wiring
hosts/<hostname>/      hardware config, host-local packages, monitor layout
nixos/
  core/                every host: boot, audio, net, nix settings, nh, ly, ...
  dev/                 dev tooling, self-gated by the per-host `dev` flag
  profiles/            maximal | suckless system-side profile modules
home-manager/
  core/                every host: neovim, git, firefox, cli tools, ...
  profiles/            maximal (hyprland stack) | suckless (dwl stack)
  pkgs/                small custom packages (ocr-copy)
```

## Installation

To get started with this NixOS setup, follow these steps:

1. **Install NixOS:** Refer to the official
   [NixOS Installation Guide](https://nixos.org/manual/nixos/stable/#sec-installation)
   for instructions on installing the base system.

2. **Clone this Repository:**

   ```bash
   git clone https://github.com/Marcus441/nixos-dotfiles.git ~/dotfiles/flake
   cd ~/dotfiles/flake
   ```

3. **Prepare Your Host Configuration:** Navigate to the `hosts` directory and
   copy one of the existing host configurations as a starting point for your
   machine. Replace `<hostname>` with your desired machine's name.

   ```bash
   cd hosts
   cp -r UM790pro <hostname> # Example: cp -r UM790pro my-laptop
   cd <hostname>
   ```

4. **Copy `hardware-configuration.nix`:** Place your system's
   `hardware-configuration.nix` file into your newly created host directory.

   ```bash
   cp /etc/nixos/hardware-configuration.nix ./
   ```

5. **Customize Packages:** Edit `local-packages.nix` in your host directory
   for host-only software, and the shared sets in
   `nixos/core/common-packages.nix` / `home-manager/core/packages.nix`.

6. **Update `flake.nix` for Your System:** Modify the `flake.nix` file at the
   root of the repository to reflect your `homeStateVersion`, `user`, and your
   host entry. Each host picks a `profile` (`maximal` or `suckless`) and
   whether it carries dev tooling (`dev`):

   ```nix
   homeStateVersion = "25.11";
   user = "<your_username>";
   hosts = [
     {
       hostname = "<hostname>";
       stateVersion = "<your_state_version>";
       profile = "maximal"; # or "suckless"
       dev = true;          # docker/qemu/binfmt/ccache on this host
     }
   ];
   ```

7. **Rebuild Your System:** After making the necessary changes, navigate back
   to the root of the repository and rebuild.

   ```bash
   git add . # flakes only see tracked files

   # First install:
   sudo nixos-rebuild switch --flake .#<hostname>
   home-manager switch --flake .#<user>@<hostname>

   # After that, nh (configured in nixos/core/nh.nix) is the daily driver:
   nh os switch
   nh home switch
   ```

## Contributions

You can make a pr if you really want, but I'll probably just ignore it because
these are my personal configs.
