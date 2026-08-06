{inputs, ...}: {
  flake.modules.homeManager.core = [
    (
      {
        pkgs,
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
      }
    )
  ];

  # Snacks renders documents and images inline; these are what it shells out to.
  flake.modules.homeManager.apps = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          ghostscript
          tectonic
        ];
      }
    )
  ];
}
