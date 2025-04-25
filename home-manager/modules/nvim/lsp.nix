{ pkgs, ... }:

{
  programs.nvf.settings.vim.languages = {
    nix = {
      lsp.enable = true;
      lsp.extraPackages = [ pkgs.nil ];
    };

    lua = {
      lsp.enable = true;
    };

    java = {
      lsp.enable = true;
      lsp.extraPackages = [ pkgs.jdt-language-server ];
    };
  };
}

