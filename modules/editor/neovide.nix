{inputs, ...}: {
  flake.modules.homeManager.dev = [
    (
      {
        config,
        pkgs,
        ...
      }: let
        inherit (pkgs.stdenv.hostPlatform) system;
        neovim = inputs.neovim-config.packages.${system};
      in {
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
              normal = [config.desktop.font.name];
              # load-bearing: docs/decisions/theming.md#neovide-font-size
              size = 0.0 + config.desktop.font.terminalSize;
            };
          };
        };
      }
    )
  ];
}
