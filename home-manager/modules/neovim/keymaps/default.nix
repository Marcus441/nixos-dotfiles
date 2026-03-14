let
  general = import ./general.nix;
  lsp = import ./lsp.nix;
  mini-files = import ./mini-files.nix;
  neogen = import ./neogen.nix;
  telescope = import ./telescope.nix;
  trouble = import ./trouble.nix;
in {
  programs.nvf.settings.vim.keymaps =
    lsp
    ++ mini-files
    ++ neogen
    ++ telescope
    ++ trouble
    ++ general;
}
