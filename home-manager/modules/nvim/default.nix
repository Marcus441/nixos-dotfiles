{ pkgs, inputs, ... }:

{
  imports = [
    ./plugins.nix
    ./lsp.nix
    ./keymaps.nix
  ];

  programs.nvf.enable = true;
}

