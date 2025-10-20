{
  programs.nvf.settings.vim = {
    autocomplete.nvim-cmp = {
      enable = true;
      mappings = {
        next = "<C-n>";
        previous = "<C-p>";
        confirm = "<CR>";
      };
      setupOpts = {
        window = {
          completion = {border = "rounded";};
          documentation = {border = "rounded";};
        };
        completion = {
          completeopt = "menu,menuone,noinsert,noselect";
        };
        snippet = {
          expand = "luasnip#anonymous";
        };
      };
    };
  };
}
