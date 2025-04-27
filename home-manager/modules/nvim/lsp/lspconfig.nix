{pkgs, ...}: {
  programs.nvf.settings = {
    vim.lsp.lspconfig.enable = true;
  };
}
