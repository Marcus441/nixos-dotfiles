{
  pkgs,
  inputs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  neovim = inputs.neovim-config.packages.${system};
in {
  home = {
    packages = [
      neovim.min
    ];
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
  };

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
