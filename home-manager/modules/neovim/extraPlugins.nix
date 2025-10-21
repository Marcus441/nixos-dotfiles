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
              -- Dark Completion Menu
              -------------------
              Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },  -- add `blend = vim.o.pumblend` to enable transparency
              PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
              PmenuSbar = { bg = theme.ui.bg_m1 },
              PmenuThumb = { bg = theme.ui.bg_p2 },

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
  };
}
