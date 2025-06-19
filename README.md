# ❄️ NixOS Config ❄️

This is my personal NixOS configuration, featuring a Gruvbox Material themed
desktop environment.

## Inspiration and Attribution

This project is heavily derived from concepts and ideas found in
[nixos-config-reborn](https://github.com/Andrey0189/nixos-config-reborn) by
**@Andrey0189**. Their exceptional YouTube guides and well-structured repository
were instrumental in my journey learning NixOS. I highly recommend checking out
their work for anyone interested in advanced NixOS setups.

As this configuration builds upon their foundational work, it is also licensed
under the **GNU General Public License v3.0 (GPL-3.0)**, in accordance with the
original project's licensing. You can find a copy of the license in the
`LICENSE` file within this repository.

## ✨ Features

- 🎨 **Gruvbox Material Hard Dark Theme:** A consistent and eye-pleasing dark
  theme.
- 🪟 **Hyprland + Waybar:** A modern and efficient Wayland compositor setup with
  a customizable bar.
- 🧇 **Tmux + Neovim Setup (via nvf):** A powerful terminal multiplexer combined
  with a highly customized Neovim environment for efficient coding.
- 🌟 **Zsh + Starship:** A delightful and feature-rich shell with a cross-shell
  prompt.
- 🖥️ **Multiple Hosts:** Designed to be easily adaptable for various machines.
- 🏠 **Home Manager Integration:** Seamless management of user-specific
  configurations.

## 🚀 Installation

To get started with this NixOS setup, follow these steps:

1. **Install NixOS:** Refer to the official
   [NixOS Installation Guide](https://nixos.org/manual/nixos/stable/#sec-installation)
   for instructions on installing the base system.

2. **Clone this Repository:**

   ```bash
   git clone [https://github.com/Marcus441/nixos-dotfiles.git](https://github.com/Marcus441/nixos-dotfiles.git)
   cd nixos-dotfiles
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

5. **Customize Local Packages and System-wide Packages:** Edit the
   `local-packages.nix` file within your host directory and `nixos/packages.nix`
   in the parent directory to include your preferred software.

   ```bash
   nvim local-packages.nix
   nvim ../../nixos/packages.nix
   ```

6. **Update `flake.nix` for Your System:** Modify the `flake.nix` file at the
   root of the repository to reflect your specific `homeStateVersion`, `user`,
   and `<hostname>`.

   ```diff
   --- a/flake.nix
   +++ b/flake.nix
   @@ -5,17 +5,17 @@
        outputs = { self, nixpkgs, home-manager, ... }@inputs: let
            system = "x86_64-linux";
   -        homeStateVersion = "24.11"; # <--- Update this to your Home Manager state version
   -        user = "marcus";            # <--- Update this to your username
   +        homeStateVersion = "<your_home_manager_state_version>";
   +        user = "<your_username>";
            hosts = [
   -            { hostname = "swift5"; stateVersion = "24.11"; }
   -            { hostname = "gpc"; stateVersion = "24.11"; }
   -            { hostname = "UM790pro"; stateVersion = "24.11"; }
   +            # { hostname = "swift5"; stateVersion = "24.11"; } # Uncomment or add your hosts here
   +            # { hostname = "gpc"; stateVersion = "24.11"; }
   +            # { hostname = "UM790pro"; stateVersion = "24.11"; }
   +            { hostname = "<hostname>"; stateVersion = "<your_state_version>"; } # Add your specific host
            ];
            lib = nixpkgs.lib;
        in {
   ```

7. **Rebuild Your System:** After making the necessary changes, navigate back to
   the root of your cloned repository and rebuild your NixOS system.

   ```bash
   # Ensure you are in the root of your 'nixos-dotfiles' repository
   # Example: cd ~/nixos-dotfiles

   git add . # Stage your changes
   sudo nixos-rebuild switch --flake .#<hostname> # Use '.' for the current directory
   # OR: sudo nixos-install --flake .#<hostname> # for a fresh install 

   home-manager switch --flake .#<hostname>
   ```

## 🤝 Contributions

Contributions are welcome! Feel free to open pull requests or issues if you have
suggestions, improvements, or encounter problems. Please ensure any
contributions align with the project's GPL-3.0 license.
