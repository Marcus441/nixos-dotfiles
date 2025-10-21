{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    ./autoCmds.nix
    ./autoComplete.nix
    ./debugger.nix
    ./extraPlugins.nix
    ./keymaps
    ./navigation.nix
    ./formatter.nix
    ./languages.nix
    ./lsp.nix
  ];

  programs.nvf = {
    enable = true;

    settings.vim = {
      vimAlias = true;
      undoFile.enable = true;
      lineNumberMode = "relNumber";
      enableLuaLoader = true;
      preventJunkFiles = true;
      telescope.enable = true;
      treesitter.context.enable = false;
      options = {
        tabstop = 4;
        shiftwidth = 2;
        wrap = false;
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers = {
          wl-copy.enable = true;
          xsel.enable = true;
        };
      };

      diagnostics = {
        enable = true;
        config = {
          virtual_lines.enable = true;
          underline = true;
          signs = true;
        };
      };

      spellcheck = {
        enable = true;
        languages = ["en"];
        programmingWordlist.enable = true;
      };

      visuals = {
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim = {
          enable = true;
          setupOpts = {
            notification.window.winblend = 0;
            progress = {
              display = {
                done_icon = "✓";
              };
            };
          };
        };
        highlight-undo.enable = true;
        indent-blankline.enable = true;
        indent-blankline.setupOpts = {
          exclude = {
            filetypes = ["dashboard" "lspinfo" "packer"];
          };
          scope = {
            enabled = false;
          };
        };
        rainbow-delimiters.enable = true;
      };

      autopairs.nvim-autopairs.enable = true;

      snippets.luasnip.enable = true;
      snippets.luasnip.loaders = "require('luasnip.loaders.from_vscode').lazy_load()";

      binds = {
        whichKey.enable = true;
        whichKey.register = {
          "<leader>c" = "[C]ode";
          "<leader>d" = "[D]ocument";
          "<leader>r" = "[R]ename";
          "<leader>s" = "[S]earch";
          "<leader>w" = "[W]orkspace";
          "<leader>t" = "[T]oggle";
          "<leader>h" = "Git [H]unk";
        };
        cheatsheet.enable = true;
      };

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false;
      };

      dashboard.dashboard-nvim = {
        enable = true;
        setupOpts = {
          theme = "hyper";
          shortcut_type = "letter";
          config = {
            week_header = {
              enable = true;
            };
            shortcut = [
              {
                icon = "󰍉  ";
                icon_hl = "Label";
                desc = "Find Files";
                group = "Label";
                key = "f";
                action = "Telescope find_files";
              }
              {
                icon = "󰈞 ";
                icon_hl = "Label";
                desc = "Live Grep";
                group = "Label";
                key = "s";
                action = "Telescope live_grep";
              }
            ];
            packages = {enable = false;};
            footer = {};
            vertical_center = true;
          };
        };
      };

      projects.project-nvim.enable = true;

      statusline.lualine.enable = true;
      mini = {
        icons.enable = true;
        ai.enable = true;
        surround.enable = true;
        indentscope = {
          enable = true;
          setupOpts = {
            extra = lib.mkLuaInline ''
              vim.api.nvim_create_autocmd("FileType", {
                pattern = "dashboard",
                callback = function()
                  vim.b.miniindentscope_disable = true
                end,
              })
            '';
            symbol = "┃";
            draw = {
              delay = 0;
              animation = lib.mkLuaInline ''require('mini.indentscope').gen_animation.none()'';
            };
          };
        };
        files.enable = true;
      };

      notify = {
        nvim-notify.enable = true;
      };

      utility = {
        ccc.enable = false;
        diffview-nvim.enable = true;
        icon-picker.enable = true;
        snacks-nvim = {
          enable = true;
          setupOpts = {
            image = {
              enabled = true;
            };
          };
        };
        motion = {precognition.enable = false;};
        surround.enable = true;
        vim-wakatime.enable = false;
      };

      ui = {
        borders.enable = true;
        noice.enable = true;
        noice.setupOpts.lsp.signature.enabled = true;
        colorizer = {
          enable = true;
          setupOpts = {
            filetypes = {
              "*" = {
                RGB = true;
                RRGGBB = true;
                always_update = true;
                css = true;
                mode = "background";
              };
            };
          };
        };

        illuminate.enable = true;
        breadcrumbs = {
          enable = false;
          navbuddy.enable = false;
        };
        smartcolumn = {
          enable = true;
          setupOpts.disabled_filetypes = [
            "help"
            "text"
            "markdown"
            "NvimTree"
            "dashboard"
          ];
        };
        fastaction.enable = true;
      };

      session = {
        nvim-session-manager = {
          enable = true;
          setupOpts = {
            autoload_mode = "GitSession";
          };
        };
      };

      notes.todo-comments.enable = true;
      comments = {
        comment-nvim.enable = true;
      };
    };
  };
}
