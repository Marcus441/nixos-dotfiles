# { lib, config, pkgs, ... }:
# let
#   inherit (lib.options) mkEnableOption;
#   inherit (lib.nvim.binds) mkMappingOption;
# in {
#   vim.lazy.plugins.telescope = {
#     package = pkgs.telescope;
#     setupModule = "telescope";
#     event = ["BufRead"];
#     cmd = ["Telescope"];
#
#     mappings = {
#       gotoDefinition = mkMappingOption "Goto Definition" "<leader>gd" ":lua require('telescope.builtin').lsp_definitions()<CR>";
#       gotoReferences = mkMappingOption "Goto References" "<leader>gr" ":lua require('telescope.builtin').lsp_references()<CR>";
#       gotoImplementation = mkMappingOption "Goto Implementation" "<leader>gI" ":lua require('telescope.builtin').lsp_implementations()<CR>";
#       gotoTypeDefinition = mkMappingOption "Goto Type Definition" "<leader>D" ":lua require('telescope.builtin').lsp_type_definitions()<CR>";
#       documentSymbols = mkMappingOption "Document Symbols" "<leader>ds" ":lua require('telescope.builtin').lsp_document_symbols()<CR>";
#       workspaceSymbols = mkMappingOption "Workspace Symbols" "<leader>ws" ":lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>";
#       renameSymbol = mkMappingOption "Rename Symbol" "<leader>rn" ":lua vim.lsp.buf.rename()<CR>";
#       codeAction = mkMappingOption "Code Action" "<leader>ca" ":lua vim.lsp.buf.code_action()<CR>";
#       gotoDeclaration = mkMappingOption "Goto Declaration" "gD" ":lua vim.lsp.buf.declaration()<CR>";
#     };
#   };
# }
{
  programs.nvf.settings = {
    vim.keymaps = [
      {
        key = "<Esc>";
        mode = "n";
        action = "<cmd>nohlsearch<CR>";
        desc = "Clear highlights on search";
      }
      {
        key = "jk";
        mode = "i";
        action = "<Esc>";
        desc = "Bind jk to escape in insert mode";
      }
      {
        key = "J";
        mode = "n";
        action = "mzJ`z";
        desc = "Keep cursor to the left when appending lines";
      }
      {
        key = "<C-d>";
        mode = "n";
        action = "<C-d>zz";
        desc = "Keep cursor in center when scrolling down";
      }
      {
        key = "<C-u>";
        mode = "n";
        action = "<C-u>zz";
        desc = "Keep cursor in center when scrolling up";
      }
      {
        key = "n";
        mode = "n";
        action = "nzzzv";
        desc = "Keep cursor centered when finding next";
      }
      {
        key = "N";
        mode = "n";
        action = "Nzzzv";
        desc = "Keep cursor centered when finding previous";
      }
      {
        key = "<leader>rlsp";
        mode = "n";
        action = "<cmd>LspRestart<cr>";
        desc = "Reset LSP config";
      }
      {
        key = "<leader>q";
        mode = "n";
        action = "vim.diagnostic.setloclist";
        desc = "Open diagnostic [Q]uickfix list";
      }
      {
        key = "<Esc><Esc>";
        mode = "t";
        action = "<C-\\><C-n>";
        desc = "Exit terminal mode";
      }
      {
        key = "<C-h>";
        mode = "n";
        action = "<C-w><C-h>";
        desc = "Move focus to the left window";
      }
      {
        key = "<C-l>";
        mode = "n";
        action = "<C-w><C-l>";
        desc = "Move focus to the right window";
      }
      {
        key = "<C-j>";
        mode = "n";
        action = "<C-w><C-j>";
        desc = "Move focus to the lower window";
      }
      {
        key = "<C-k>";
        mode = "n";
        action = "<C-w><C-k>";
        desc = "Move focus to the upper window";
      }
      {
        key = "J";
        mode = "v";
        action = ":m '>+1<CR>gv=gv";
        desc = "Move highlighted section down";
      }
      {
        key = "K";
        mode = "v";
        action = ":m '<-2<CR>gv=gv";
        desc = "Move highlighted section up";
      }
      {
        key = "<leader>p";
        mode = "x";
        action = ''"_dP'';
        desc = "Paste from clipboard, override void register";
      }
      {
        key = "<leader>y";
        mode = ["n" "v"];
        action = ''"+y'';
        desc = "Yank to system clipboard";
      }
      {
        key = "<leader>Y";
        mode = "n";
        action = ''"+Y'';
        desc = "Yank whole line to system clipboard";
      }
      {
        key = "<leader>d";
        mode = ["n" "v"];
        action = ''"_d'';
        desc = "Delete to void register";
      }
    ];
  };
}
