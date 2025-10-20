let
  general = import ./general.nix;
  telescope = import ./telescope.nix;
  lsp = import ./lsp.nix;
  trouble = import ./trouble.nix;
  mini-files = import ./mini-files.nix;
in {
  programs.nvf.settings.vim.keymaps = general ++ telescope ++ lsp ++ trouble ++ mini-files;
}
