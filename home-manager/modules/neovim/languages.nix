{
  programs.nvf.settings.vim = {
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
      nix = { 
        enable = true;
        lsp.enable = true;
      };
      clang = {
        enable = true;
        lsp.enable = true;
        dap.enable = true;
      };
      python = {
        enable = true;
        lsp.enable = true;
      };
      markdown = {
        enable = true;
        lsp.enable = true;
        extensions.markview-nvim.enable = true;
      };
      terraform = { 
        enable = true;
        lsp.enable= true;
      };
      ts = {
        enable = true;
        lsp.enable = true;
        format.type = ["prettierd"];
        extensions.ts-error-translator.enable = true;
      };
      html.enable = true;
      lua.enable = true;
      typst = {
        enable = true;
        lsp.enable = true; 
      };
      rust = {
        enable = true;
        lsp.enable = true;
        extensions = {
          crates-nvim.enable = true;
        };
      };
    };
  };
}
