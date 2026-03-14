{pkgs, ...}: {
  programs.nvf.settings.vim.extraPlugins = {
    theme-plugin = {
      package = pkgs.vimPlugins.kanagawa-nvim;
      setup = "
        require('kanagawa').setup({
          transparent = true,
          colors = {
            theme = {
              all = {
                ui = {
                  bg_gutter = 'none',
                  float = {
                    bg = 'none',
                  }
                }
              }
            }
          },
          overrides = function(colors)
            local theme = colors.theme
            local makeDiagnosticColor = function(color)
              local c = require('kanagawa.lib.color')
              return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
            end
            return {
              -------------------
              -- Floating windows
              -------------------
              NormalFloat = { bg = 'none' },
              FloatBorder = { bg = 'none' },
              FloatTitle = { bg = 'none' },

              -------------------
              -- Mini.Files
              -------------------
              MiniFilesTitle = { fg = theme.ui.special, bg = 'none', bold = true },
              MiniFilesTitleFocused = { fg = theme.ui.special, bg = 'none', bold = true },

              -------------------
              -- LSP Progress
              -------------------
              LspProgressStatus  = { bg = 'none' },
              LspProgressClient  = { bg = 'none' },
              LspProgressTitle   = { bg = 'none' },
              LspProgressSpinner = { bg = 'none' },
              LspProgressMsg     = { bg = 'none' },
              LspProgressDone    = { bg = 'none' },

              -------------------
              -- Telescope
              -------------------
              TelescopeTitle = { fg = theme.ui.special, bold = true },
              TelescopePromptNormal = { bg = theme.ui.bg_p1 },
              TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
              TelescopeResultsNormal = { fg = theme.ui.fg, bg = theme.ui.bg_m1 },
              TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
              TelescopePreviewNormal = { bg = theme.ui.bg_dim },
              TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

              -------------------
              -- Diagnostics time
              -------------------
              DiagnosticVirtualTextHint  = makeDiagnosticColor(theme.diag.hint),
              DiagnosticVirtualTextInfo  = makeDiagnosticColor(theme.diag.info),
              DiagnosticVirtualTextWarn  = makeDiagnosticColor(theme.diag.warning),
              DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),

            }
          end
        })
        vim.cmd[[colorscheme kanagawa-dragon]]
      ";
    };
    vim-tmux-navigator = {
      package = pkgs.vimPlugins.vim-tmux-navigator;
      setup = "
          vim.g.tmux_navigator_no_mappings = 1
          vim.g.tmux_navigator_no_wrap = 1
          ";
    };
    undotree = {
      package = pkgs.vimPlugins.undotree;
      setup = "";
      after = ["vim-tmux-navigator"];
    };
    neogen = {
      package = pkgs.vimPlugins.neogen;
      setup = ''
        require('neogen').setup({
          enabled = true,
          snippet_engine = "luasnip",
          languages = {
            cs = {
              template = {
                annotation_convention = "xmldoc" -- This forces the XML style
              }
            }
          }
        })

        -- Keybindings for triggering the annotation
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<Leader>nf", function()
            require('neogen').generate()
        end, opts)
      '';
    };
    #
    # roslyn-nvim = {
    #   package = pkgs.vimPlugins.roslyn-nvim;
    #   setup = ''
    #     -- 1. Register the server settings via the standard Neovim LSP config
    #     -- This follows the documentation's advice to use vim.lsp.config
    #     vim.lsp.config("roslyn", {
    #       cmd = {
    #         "${pkgs.roslyn-ls}/bin/Microsoft.CodeAnalysis.LanguageServer",
    #         "--stdio",
    #         "--logLevel=Information",
    #         "--extensionLogDirectory=" .. vim.fs.joinpath(vim.fn.stdpath("state"), "roslyn-logs"),
    #       },
    #       settings = {
    #         ["csharp|background_analysis"] = {
    #           dotnet_analyzer_diagnostics_scope = "fullSolution",
    #           dotnet_compiler_diagnostics_scope = "fullSolution",
    #         },
    #         ["csharp|inlay_hints"] = {
    #           csharp_enable_inlay_hints_for_implicit_object_creation = true,
    #           csharp_enable_inlay_hints_for_implicit_variable_types = true,
    #           csharp_enable_inlay_hints_for_lambda_parameter_types = true,
    #           csharp_enable_inlay_hints_for_types = true,
    #         },
    #       },
    #       on_attach = function(client, bufnr)
    #         local opts = { buffer = bufnr }
    #         vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    #         vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    #         vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    #         vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    #         vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    #       end,
    #       capabilities = require('blink.cmp').get_lsp_capabilities(),
    #     })
    #
    #     -- 2. Initialize the plugin orchestration
    #     require("roslyn").setup({
    #       -- Recommended for Nix/Linux to avoid LSP file watching warnings
    #       filewatching = "roslyn",
    #       broad_search = true,
    #       lock_target = true,
    #     })
    #   '';
    #   after = ["blink.cmp" "fidget-nvim"];
    # };
  };
}
