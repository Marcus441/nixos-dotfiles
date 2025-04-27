{ lib, ... }:
{
  programs.nvf.settings = {
    
vim.autocmds = [
  {
    enable = true;
    event = ["TextYankPost"];
    pattern = [];
    callback = lib.generators.mkLuaInline ''
      function()
        vim.highlight.on_yank()
      end
    '';
    desc = "Highlight when yanking (copying) text";
  }
];
  };
}
