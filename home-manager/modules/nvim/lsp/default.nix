{pkgs, ...}: {
  programs.nvf.settings.vim.lsp.lspconfig.enable = true;
  programs.nvf.settings.vim.languages = {
    nix = {
      enable = true; # Enable Nix language support
      extraDiagnostics.enable = true; # Enable extra diagnostics (statix, deadnix)
      format.enable = true; # Enable Nix code formatting
      lsp.enable = true; # Enable Nix LSP
      treesitter.enable = true; # Enable Treesitter for syntax highlighting
      treesitter.package = pkgs.vimPlugins.nvim-treesitter.builtGrammars.nix; # Use Nix Treesitter grammar
    };
    lua = {
      lsp.enable = true;
    };

    java = {
      lsp.enable = true;
    };
  };
}
