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
              return {
                -------------------
                -- Floating windows
                -------------------
                NormalFloat = { bg = 'none' },
                FloatBorder = { bg = 'none' },
                FloatTitle = { bg = 'none' },

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
                -- nvim-cmp / popup menu
                -------------------
                Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },  
                PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
                PmenuSbar = { bg = theme.ui.bg_m1 },
                PmenuThumb = { bg = theme.ui.bg_p2 },

                -------------------
                -- Noice
                -------------------
                -- Base popup
                NoiceCmdlinePopup       = { fg = 'NONE', bg = 'NONE'},
                NoiceCmdlinePopupBorder = { fg = 'NONE', bg = 'NONE' },
                NoiceCmdlinePrompt                 = { fg = theme.ui.special, bg = 'NONE' },
                NoiceCmdlineIcon                   = { fg = theme.ui.special, bg = 'NONE' },
                NoicePopupmenu                     = { fg = theme.ui.shade0, bg = theme.ui.bg_m1 },
                NoicePopupmenuBorder               = { fg = theme.ui.fg, bg = theme.ui.bg },

                -------------------
                -- Misc
                -------------------
                NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_3 },
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
