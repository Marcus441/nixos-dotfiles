{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    #    ./plugins
    # ./lsp
    ./keymaps.nix
    ./options.nix
  ];

  programs.nvf.enable = true;
}
