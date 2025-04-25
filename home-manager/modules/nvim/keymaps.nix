{
  programs.nvf.settings.keymaps = [
    {
      mode = "n";
      key = "<leader>w";
      action = ":w<CR>";
      options.desc = "Save file";
    }
    {
      mode = "i";
      key = "jk";
      action = "<Esc>";
      options.desc = "Exit insert mode";
    }
  ];
}

