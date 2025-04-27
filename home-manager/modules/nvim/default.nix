{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    #    ./plugins
    ./lsp
    ./autocmds.nix
    ./keymaps.nix
    ./options.nix
  ];

  programs.nvf.enable = true;
}
