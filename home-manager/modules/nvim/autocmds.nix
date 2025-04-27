{
  programs.nvf.settings = {
    
vim.autocmds = [
  {
    enable = true;
    event = ["TextYankPost"];
    pattern = [];
    callback = mkLuaInline ''
      function()
        vim.highlight.on_yank()
      end
    '';
    desc = "Highlight when yanking (copying) text";
    group = "kickstart-highlight-yank";
  }
];
  };
}
