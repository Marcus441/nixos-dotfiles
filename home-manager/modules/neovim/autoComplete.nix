{
  programs.nvf.settings.vim = {
    autocomplete.nvim-cmp = {
      enable = true;
      mappings = {
        next = "<C-n>";
        previous = "<C-p>";
        confirm = "<C-y>";
      };
      setupOpts = {
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder";
          };
          documentation = {
            border = "rounded";
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder";
          };
        };
        completion = {
          completeopt = "menu,menuone,noinsert";
        };
      };
    };
  };
}
