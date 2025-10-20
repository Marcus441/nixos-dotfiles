{
  config,
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
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        indent-blankline.enable = true;
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

      dashboard.alpha = {
        enable = true;
        theme = "theta";
      };

      projects.project-nvim.enable = true;

      statusline.lualine.enable = true;
      mini = {
        ai.enable = true;
        surround.enable = true;
        indentscope = {
          enable = true;
          setupOpts = {
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
        nvim-notify.setupOpts.background_colour = "#${config.lib.stylix.colors.base01}";
      };

      utility = {
        ccc.enable = false;
        diffview-nvim.enable = true;
        icon-picker.enable = true;
        images = {image-nvim.enable = false;};
        motion = {precognition.enable = false;};
        oil-nvim.enable = true;
        surround.enable = true;
        vim-wakatime.enable = false;
      };

      ui = {
        borders.enable = true;
        noice.enable = true;
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
