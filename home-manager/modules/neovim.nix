{
  pkgs,
  inputs,
  ...
}: {
  home = {
    packages = [
      inputs.neovim-config.packages.${pkgs.stdenv.hostPlatform.system}.default
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
