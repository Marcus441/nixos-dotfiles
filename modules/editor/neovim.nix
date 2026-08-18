{inputs, ...}: {
  flake.modules.homeManager.core = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        inherit (pkgs.stdenv.hostPlatform) system;
        neovim = inputs.neovim-config.packages.${system};
      in {
        options.editor.package = lib.mkOption {
          type = lib.types.package;
          default = neovim.min;
          description = "Neovim build every host installs; `dev` raises it to the LSP-complete one.";
        };

        config.home = {
          packages = [config.editor.package];
          sessionVariables = {
            EDITOR = "nvim";
            VISUAL = "nvim";
          };
        };
      }
    )
  ];

  flake.modules.homeManager.dev = [
    (
      {pkgs, ...}: let
        inherit (pkgs.stdenv.hostPlatform) system;
        neovim = inputs.neovim-config.packages.${system};
      in {
        editor.package = neovim.full;

        home.packages = with pkgs; [
          ghostscript
          tectonic
        ];
      }
    )
  ];
}
