{
  pkgs,
  inputs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  neovim = inputs.neovim-config.packages.${system};
in {
  # Neovide is the GUI front-end for neovim -- maximal only. The core
  # neovim.nix provides the headless `nvim` shared by both profiles.
  programs.neovide = {
    enable = true;
    settings = {
      neovim-bin = "${neovim.gui}/bin/nvim";
      fork = false;
      frame = "full";
      idle = true;
      maximized = false;
      no-multigrid = false;
      srgb = false;
      tabs = true;
      theme = "dark";
      title-hidden = true;
      vsync = true;
      wsl = false;

      font = {
        normal = ["IosevkaTerm Nerd Font Mono"];
        size = 20.0;
      };
    };
  };
}
