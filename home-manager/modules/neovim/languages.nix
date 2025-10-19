{
  programs.nvf.settings.vim = {
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
      nix.enable = true;
      clang.enable = true;
      clang.dap.enable = true;
      zig.enable = true;
      python.enable = true;
      markdown = {
        enable = true;
        extensions.markview-nvim.enable = true;
      };
      terraform.enable = true;
      ts = {
        enable = true;
        lsp.enable = true;
        format.type = "prettierd";
        extensions.ts-error-translator.enable = true;
      };
      html.enable = true;
      lua.enable = true;
      css.enable = false;
      typst.enable = true;
      rust = {
        enable = true;
        crates.enable = true;
      };
    };
  };
}
