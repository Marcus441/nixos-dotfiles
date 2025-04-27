{pkgs, ...}: {
    vim.lsp.lspconfig.enable = true;

    vim.lsp.lspconfig.sources = {
      # python = "pyright"; 
      # typescript = "tsserver";
    };

}
