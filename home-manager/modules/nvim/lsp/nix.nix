{
  programs.nvf.settings = {
   vim.languages.nix = {
       enable = true;
       extraDiagnostics = {
          enable = true;
          types = [
                "statix"
                "deadnix"
          ];
       };
       format = {
          enable = true;
          type = "alejandra";
       };
       treesitter.enable = true;
   };
   vim.languages.nix.lsp = {
       enable = true;
       server = "nil";
       };
 };
}
