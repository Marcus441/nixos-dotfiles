{
  inputs,
  lib,
  ...
}: {
  imports = [
    ./assistant.nix
    ./autoCmds.nix
    ./autoComplete.nix
    ./debugger.nix
    ./extraPlugins.nix
    ./formatter.nix
    ./keymaps
    ./languages.nix
    ./lsp.nix
    inputs.nvf.homeManagerModules.default
  ];

  programs.nvf = {
    enable = true;

    settings.vim = {
      vimAlias = true;
      undoFile.enable = true;
      lineNumberMode = "relNumber";
      enableLuaLoader = true;
      preventJunkFiles = true;
      telescope = {
        enable = true;
        setupOpts.defaults.color_devicons = true;
      };
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
          signs = true;
          underline = true;
          virtual_lines.enable = true;
          # virtual_text.enable = true;
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
        indent-blankline = {
          enable = true;
          setupOpts = {
            exclude = {
              filetypes = ["snacks_dashboard"];
            };
            scope = {
              enabled = false;
            };
          };
        };
        rainbow-delimiters.enable = true;
      };

      autopairs.nvim-autopairs.enable = true;

      snippets = {
        luasnip.enable = true;
        luasnip.loaders = "require('luasnip.loaders.from_vscode').lazy_load()";
      };

      binds = {
        whichKey = {
          enable = true;
          register = {
            "<leader>c" = "[C]ode";
            "<leader>d" = "[D]ocument";
            "<leader>r" = "[R]ename";
            "<leader>s" = "[S]earch";
            "<leader>w" = "[W]orkspace";
            "<leader>t" = "[T]oggle";
            "<leader>h" = "Git [H]unk";
          };
        };
        cheatsheet.enable = true;
      };

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false;
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
            ignore_filetypes = [
              "NvimTree"
              "TelescopePrompt"
              "help"
              "neo-tree"
              "notify"
              "snacks_dashboard"
            ];
            symbol = "┃";
            draw = {
              delay = 0;
              animation = lib.mkLuaInline ''require('mini.indentscope').gen_animation.none()'';
            };
          };
        };
        files = {
          enable = true;
          setupOpts = {
            mappings = {
              close = "q";
              go_in = "l";
              go_in_plus = "<CR>";
              go_out = "h";
              go_out_plus = "H";
              mark_goto = "\"";
              mark_set = "m";
              reset = "<BS>";
              reveal_cwd = "@";
              show_help = "g?";
              synchronize = "<C-y>";
              trim_left = "<";
              trim_right = ">";
            };
          };
        };
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
            dashboard = {
              enabled = true;
              preset = lib.mkLuaInline ''
                {
                  header = [[
                   ███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄
                   ███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄
                   ███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███
                   ███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███
                   ███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███
                   ███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███
                   ███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███
                    ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀
                  ]]
                }
              '';
              sections = lib.mkLuaInline ''
                {
                  { section = "header" },
                  { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
                  { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                  { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                },
              '';
            };
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
        noice = {
          enable = true;
          setupOpts.lsp.signature.enabled = true;
        };
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
            "snacks_dashboard"
          ];
        };
        fastaction.enable = true;
      };

      notes.todo-comments.enable = true;
      comments = {
        comment-nvim.enable = true;
      };
    };
  };
}
