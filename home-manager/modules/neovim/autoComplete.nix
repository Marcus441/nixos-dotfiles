{lib, ...}: {
  programs.nvf.settings.vim = {
    autocomplete.nvim-cmp = {
      enable = true;
      sourcePlugins = ["avante-nvim"];
      mappings = {
        next = "<C-n>";
        previous = "<C-p>";
        confirm = "<CR>";
      };
      setupOpts = {
        window = {
          completion = {
            border = lib.mkForce [
              "🭽"
              "▔"
              "🭾"
              "▕"
              "🭿"
              "▁"
              "🭼"
              "▏"
            ];
          };
          documentation = {
            border = lib.mkForce [
              "🭽"
              "▔"
              "🭾"
              "▕"
              "🭿"
              "▁"
              "🭼"
              "▏"
            ];
          };
        };
        completion = {
          completeopt = "menu,menuone,noinsert,noselect";
        };
      };
    };
  };
}
