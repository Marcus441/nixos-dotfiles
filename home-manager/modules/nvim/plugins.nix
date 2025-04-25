{ pkgs, ... }:

{
  programs.nvf.settings.vim.lazy.plugins = [
    {
      repo = "tpope/vim-surround";
    }
    {
      repo = "nvim-telescope/telescope.nvim";
      dependencies = [ "nvim-lua/plenary.nvim" ];
      config = ''
        require('telescope').setup()
      '';
    }
  ];
}

