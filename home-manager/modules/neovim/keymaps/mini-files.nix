[
  {
    mode = ["n"];
    key = "<leader>e";
    desc = "Toggle MiniFiles";
    action = "<CMD>lua if not MiniFiles.close() then MiniFiles.open() end <CR>";
  }
]
