
{
  programs.nvf.settings = {
    vim = {
      autocomplete.nvim-cmp = {
        enable = true;

        sourcePlugins = [
          "cmp-nvim-lsp"
          "cmp-buffer"
          "cmp-path"
          "cmp-luasnip"
          "luasnip"
        ];

        sources = {
          nvim_lsp = "[LSP]";
          buffer = "[Buffer]";
          path = "[Path]";
          luasnip = "[Snippet]";
        };
        mappings = { 
            close = "<C-e>";
            complete = "<C-Space>";
            confirm = "<CR>";
            next = "<Tab>";
            previous = "<S-Tab>";
            scrollDocsDown = "<C-f>";
            scrollDocsUp = "<C-d>";
        };

        setupOpts.completion.completeopt = "menu,menuone,noinsert";
      };
      ui.borders.plugins.nvim-cmp = {
        enable = true;
        style = "rounded";
      };
    };
  };
}

