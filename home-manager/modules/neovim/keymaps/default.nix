let
  general = import ./general.nix;
  telescope = import ./telescope.nix;
  lsp = import ./lsp.nix;
  trouble = import ./trouble.nix;
  oil = import ./oil.nix;
in {
  programs.nvf.settings.vim.keymaps = general ++ telescope ++ lsp ++ trouble ++ oil;
}
