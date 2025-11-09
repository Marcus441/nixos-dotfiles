[
  {
    mode = ["n"];
    key = "<leader>e";
    desc = "Toggle MiniFiles in CWD";
    action = "<CMD>lua local mf = require('mini.files'); if not mf.close() then mf.open(vim.api.nvim_buf_get_name(0), false) end; vim.schedule(function() mf.reveal_cwd() end)<CR>";
  }
  {
    mode = ["n"];
    key = "<leader>E";
    desc = "Toggle MiniFiles";
    action = "<CMD>lua if not MiniFiles.close() then MiniFiles.open() end <CR>";
  }
]
