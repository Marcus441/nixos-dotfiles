{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  programs.nvf = {
    enable = true;

    settings.vim = {
      debugger.nvim-dap.enable = true;
      debugger.nvim-dap.ui.enable = true;
      lsp.enable = true;
      augroups = [
        {
          name = "UserSetup";
        }
        {
          name = "MacroRecordingNotificationGroup";
        }
      ];
      autocmds = [
        {
          event = ["TextYankPost"];
          desc = "Highlight when yanking (copying) text";
          group = "UserSetup";
          callback = lib.mkLuaInline ''
            function()
              vim.highlight.on_yank()
            end
          '';
        }
        {
          event = ["RecordingEnter"];
          desc = "Notify when macro recording starts";
          group = "MacroRecordingNotificationGroup";
          callback = lib.mkLuaInline ''
            function()
              local msg = string.format("Register: %s", vim.fn.reg_recording())
              _MACRO_RECORDING_STATUS = true
              vim.notify(msg, vim.log.levels.INFO, {
                title = "Macro Recording",
                -- The `keep` function is embedded directly within the Lua string
                keep = function() return _MACRO_RECORDING_STATUS end,
              })
            end
          '';
        }
        {
          event = ["RecordingLeave"];
          desc = "Notify when macro recording ends";
          group = "MacroRecordingNotificationGroup";
          callback = lib.mkLuaInline ''
            function()
              _MACRO_RECORDING_STATUS = false
              vim.notify("Success!", vim.log.levels.INFO, {
                title = "Macro Recording End",
                timeout = 2000,
              })
            end
          '';
        }
      ];
      extraPlugins = {
        vim-tmux-navigator = {
          package = pkgs.vimPlugins.vim-tmux-navigator;
          setup = "
          vim.g.tmux_navigator_no_mappings = 1
          vim.g.tmux_navigator_no_wrap = 1
          ";
        };
        gruvbox-material = {
          package = pkgs.vimPlugins.gruvbox-flat-nvim;
          setup = "
          vim.g.gruvbox_flat_style = 'dark'
          vim.g.gruvbox_colors = { 
              bg = 'black',
              bg2 ='black'
          }
          vim.cmd[[colorscheme gruvbox-flat]]
          ";
          after = ["vim-tmux-navigator"];
        };
        undotree = {
          package = pkgs.vimPlugins.undotree;
          setup = "";
          after = ["vim-tmux-navigator"];
        };
      };

      vimAlias = true;
      undoFile.enable = true;
      lineNumberMode = "relNumber";
      enableLuaLoader = true;
      preventJunkFiles = true;
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
          virtual_text.enable = true;
          underline = true;
          signs = true;
        };
      };

      keymaps = [
        {
          mode = ["n"];
          key = "<C-n>";
          action = "<CMD>NvimTreeFindFileToggle<CR>";
          desc = "Toggle file explorer";
        }
        # Clear highlights on search when pressing <Esc> in normal mode
        # See `:help hlsearch`
        {
          mode = ["n"];
          key = "<Esc>";
          action = "<cmd>nohlsearch<CR>";
          desc = "Clear search highlights";
        }
        # bind jk to esc in insert mode
        {
          mode = ["i"];
          key = "jk";
          action = "<Esc>";
          desc = "Exit insert mode";
        }
        # Git status
        {
          mode = ["n"];
          key = "<leader>gs";
          action = "<CMD>Git<CR>";
          desc = "Show Git status";
        }
        # Keep cursor to the left when appending lines
        {
          mode = ["n"];
          key = "J";
          action = "mzJ`z";
          desc = "Join line and keep cursor position";
        }

        # keep cursor in center when moving up and down half page and in finds
        {
          mode = ["n"];
          key = "<C-d>";
          action = "<C-d>zz";
          desc = "Half page down and center";
        }
        {
          mode = ["n"];
          key = "<C-u>";
          action = "<C-u>zz";
          desc = "Half page up and center";
        }
        {
          mode = ["n"];
          key = "n";
          action = "nzzzv";
          desc = "Next search match and center";
        }
        {
          mode = ["n"];
          key = "N";
          action = "Nzzzv";
          desc = "Previous search match and center";
        }

        # reset lsp config
        {
          mode = ["n"];
          key = "<leader>rlsp";
          action = "<cmd>LspRestart<cr>";
          desc = "Restart LSP server";
        }

        # Diagnostic keymaps
        {
          mode = ["n"];
          key = "<leader>q";
          action = "<cmd>Trouble diagnostics<cr>"; # A common alternative if you use 'trouble.nvim'
          # action = "<cmd>lua vim.diagnostic.setloclist()<CR>"; # This is the direct Lua call, might work depending on NixVim's handling
          desc = "Open diagnostic [Q]uickfix list";
        }

        # Exit terminal mode in the builtin terminal
        {
          mode = ["t"];
          key = "<Esc><Esc>";
          action = "<C-\\><C-n>";
          desc = "Exit terminal mode";
        }

        # Keybinds to make split navigation easier.
        # Use CTRL+<hjkl> to switch between windows
        {
          mode = ["n"];
          key = "<C-h>";
          action = "<cmd>TmuxNavigateLeft<CR>";
          desc = "Move focus to the left window";
        }
        {
          mode = ["n"];
          key = "<C-l>";
          action = "<cmd>TmuxNavigateRight<CR>";
          desc = "Move focus to the right window";
        }
        {
          mode = ["n"];
          key = "<C-j>";
          action = "<cmd>TmuxNavigateDown<CR>";
          desc = "Move focus to the lower window";
        }
        {
          mode = ["n"];
          key = "<C-k>";
          action = "<cmd>TmuxNavigateUp<CR>";
          desc = "Move focus to the upper window";
        }

        # Move highlighted section up and down
        {
          mode = ["v"];
          key = "J";
          action = ":m '>+1<CR>gv=gv";
          desc = "Move visual block down";
        }
        {
          mode = ["v"];
          key = "K";
          action = ":m '<-2<CR>gv=gv";
          desc = "Move visual block up";
        }

        # Clipboard and void register
        # For these, the 'action' field needs to be a string representing the Vim command.
        # The '"_d' and '"+y' are normal mode commands, so you'd represent them as such.
        {
          mode = ["x"]; # Visual mode
          key = "<leader>p";
          action = "\"_dP"; # Pastes from system clipboard (") into void register (_)
          desc = "Paste into void register";
        }
        {
          mode = ["n"]; # Normal mode only
          key = "<leader>Y";
          action = "\"+Y"; # Yank line to system clipboard
          desc = "Yank line to system clipboard";
        }
        {
          mode = ["v"]; # Visual mode
          key = "<leader>y";
          action = "\"+y"; # Yank into system clipboard
          desc = "Yank to system clipboard";
        }
        {
          mode = ["n"]; # Normal mode
          key = "<leader>y";
          action = "\"+y"; # Yank into system clipboard
          desc = "Yank to system clipboard";
        }
        {
          mode = ["v"]; # Visual mode
          key = "<leader>d";
          action = "\"_d"; # Delete to void register (effectively delete without copying)
          desc = "Delete to void register";
        }
        {
          mode = ["n"]; # Normal mode
          key = "<leader>d";
          action = "\"_d"; # Delete to void register (effectively delete without copying)
          desc = "Delete to void register";
        }
        # undotree
        {
          mode = ["n"];
          key = "<leader>u";
          action = "<CMD>UndotreeToggle<CR>";
          desc = "[U]ndotree";
        }
        # Telescope Bindings
        {
          mode = ["n"];
          key = "<leader>sh";
          action = "<CMD> Telescope help_tags <CR>";
          desc = "[S]earch [H]elp";
        }
        {
          mode = ["n"];
          key = "<leader>sk";
          action = "<cmd>Telescope keymaps<cr>";
          desc = "[S]earch [K]eymaps";
        }
        {
          mode = ["n"];
          key = "<leader>sf";
          action = "<cmd>Telescope find_files<cr>";
          desc = "[S]earch [F]iles";
        }
        {
          mode = ["n"];
          key = "<leader>ss";
          action = "<cmd>Telescope builtin<cr>";
          desc = "[S]earch [S]elect Telescope";
        }
        {
          mode = ["n"];
          key = "<leader>sw";
          action = "<cmd>Telescope grep_string<cr>";
          desc = "[S]earch current [W]ord";
        }
        {
          mode = ["n"];
          key = "<leader>sg";
          action = "<cmd>Telescope live_grep<cr>";
          desc = "[S]earch by [G]rep";
        }
        {
          mode = ["n"];
          key = "<leader>sd";
          action = "<cmd>Telescope diagnostics<cr>";
          desc = "[S]earch [D]iagnostics";
        }
        {
          mode = ["n"];
          key = "<leader>sr";
          action = "<cmd>Telescope resume<cr>";
          desc = "[S]earch [R]esume";
        }
        {
          mode = ["n"];
          key = "<leader>s.";
          action = "<cmd>Telescope oldfiles<cr>";
          desc = "[S]earch Recent Files (\".\" for repeat)";
        }
        {
          mode = ["n"];
          key = "<leader><leader>";
          action = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
          desc = "[ ] Find existing buffers";
        }
        {
          mode = ["n"];
          key = "<leader>/";
          action = "<cmd>Telescope buffers<cr>";
          desc = "[/] Fuzzily search in current buffer";
        }
        # Telescope LSP: Goto Definition
        {
          mode = ["n"];
          key = "gd";
          action = "<cmd>Telescope lsp_definitions<cr>";
          desc = "[G]oto [D]efinition";
        }

        # Telescope LSP: Find References
        {
          mode = ["n"];
          key = "gr";
          action = "<cmd>Telescope lsp_references<cr>";
          desc = "[G]oto [R]eferences";
        }

        # Telescope LSP: Goto Implementation
        {
          mode = ["n"];
          key = "gI";
          action = "<cmd>Telescope lsp_implementations<cr>";
          desc = "[G]oto [I]mplementation";
        }

        # Telescope LSP: Type Definition
        {
          mode = ["n"];
          key = "<leader>D";
          action = "<cmd>Telescope lsp_type_definitions<cr>";
          desc = "Type [D]efinition";
        }

        # Telescope LSP: Document Symbols
        {
          mode = ["n"];
          key = "<leader>ds";
          action = "<cmd>Telescope lsp_document_symbols<cr>";
          desc = "[D]ocument [S]ymbols";
        }

        # Telescope LSP: Workspace Symbols
        {
          mode = ["n"];
          key = "<leader>ws";
          action = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>";
          desc = "[W]orkspace [S]ymbols";
        }

        # LSP: Rename
        {
          mode = ["n"];
          key = "<leader>rn";
          action = "<cmd>lua vim.lsp.buf.rename()<cr>";
          desc = "[R]e[n]ame";
        }

        # LSP: Code Action
        {
          mode = ["n"];
          key = "<leader>ca";
          action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
          desc = "[C]ode [A]ction";
        }

        # LSP: Goto Declaration
        {
          mode = ["n"];
          key = "gD";
          action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
          desc = "[G]oto [D]eclaration";
        }

        # Trouble Keybinds
        {
          mode = ["n"];
          key = "<leader>xx";
          action = "<cmd>Trouble diagnostics toggle<cr>";
          desc = "Diagnostics (Trouble)";
        }
        {
          mode = ["n"];
          key = "<leader>xX";
          action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
          desc = "Buffer Diagnostics (Trouble)";
        }
        {
          mode = ["n"];
          key = "<leader>cs";
          action = "<cmd>Trouble symbols toggle focus=false<cr>";
          desc = "Symbols (Trouble)";
        }
        {
          mode = ["n"];
          key = "<leader>cl";
          action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
          desc = "LSP Definitions / references / ... (Trouble)";
        }
        {
          mode = ["n"];
          key = "<leadexL";
          action = "<cmd>Trouble loclist toggle<cr>";
          desc = "Location List (Trouble)";
        }
        {
          mode = ["n"];
          key = "<leader>xQ";
          action = "<cmd>Trouble qflist toggle<cr>";
          desc = "Quickfix List (Trouble)";
        }
        # Markview toggle
        {
          mode = ["n"];
          key = "<C-m>";
          action = "<cmd>Markview<cr>";
          desc = "Toggle markview ";
        }
      ];
      telescope.enable = true;

      spellcheck = {
        enable = true;
        languages = ["en"];
        programmingWordlist.enable = true;
      };

      lsp = {
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = false;
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = true;
        otter-nvim.enable = false;
        nvim-docs-view.enable = false;
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        nix.enable = true;
        clang.enable = true;
        clang.dap.enable = true;
        zig.enable = true;
        python.enable = true;
        markdown = {
          enable = true;
          extensions.markview-nvim.enable = true;
        };
        ts = {
          enable = true;
          lsp.enable = true;
          format.type = "prettierd";
          extensions.ts-error-translator.enable = true;
        };
        html.enable = true;
        lua.enable = true;
        css.enable = false;
        typst.enable = true;
        rust = {
          enable = true;
          crates.enable = true;
        };
      };

      theme = {
        enable = false;
        name = "base16";
        base16-colors = {
          base00 = "#202021";
          base01 = "#2a2827";
          base02 = "#504945";
          base03 = "#5a524c";
          base04 = "#bdae93";
          base05 = "#ddc7a1";
          base06 = "#ebdbb2";
          base07 = "#fbf1c7";
          base08 = "#ea6962";
          base09 = "#e78a4e";
          base0A = "#d8a657";
          base0B = "#a9b665";
          base0C = "#89b482";
          base0D = "#7daea3";
          base0E = "#d3869b";
          base0F = "#bd6f3e";
        };
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

      autocomplete.nvim-cmp = {
        enable = true;
        mappings = {
          next = "<C-n>";
          previous = "<C-p>";
          confirm = "<C-y>";
        };
      };

      snippets.luasnip.enable = true;
      snippets.luasnip.loaders = "require('luasnip.loaders.from_vscode').lazy_load()";

      treesitter.context.enable = false;
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

      filetree.nvimTree = {
        enable = true;
        openOnSetup = true;
        setupOpts = {
          actions = {
            change_dir = {
              enable = true;
              global = false;
              restrict_above_cwd = false;
            };
          };
          view = {
            float = {
              enable = true;
              quit_on_focus_loss = true;
              # This ensures the window opens in the center
              open_win_config = {
                border = "rounded";
                relative = "editor";
                width = lib.mkLuaInline ''
                  math.floor(vim.o.columns * 0.4)
                '';
                height = lib.mkLuaInline ''
                  math.floor((vim.o.lines - vim.o.cmdheight) * 0.6)
                '';
                row = lib.mkLuaInline ''
                  math.floor(((vim.o.lines - vim.o.cmdheight) - math.floor((vim.o.lines - vim.o.cmdheight) * 0.6)) / 2)
                '';
                col = lib.mkLuaInline ''
                  math.floor((vim.o.columns - math.floor(vim.o.columns * 0.4)) / 2)
                '';
              };
            };
          };
          auto_reload_on_write = true;
        };
      };

      mini = {
        ai.enable = true;
        surround.enable = true;
        statusline.enable = true;
      };

      notify = {
        nvim-notify.enable = true;
        nvim-notify.setupOpts.background_colour = "#${config.lib.stylix.colors.base01}";
      };

      utility = {
        ccc.enable = false;
        vim-wakatime.enable = false;
        icon-picker.enable = true;
        surround.enable = true;
        diffview-nvim.enable = true;
        motion = {
          hop.enable = true;
          leap.enable = true;
          precognition.enable = false;
        };
        images = {
          image-nvim.enable = false;
        };
      };

      navigation = {
        harpoon = {
          enable = true;
          mappings = {
            file1 = "<A-q>";
            file2 = "<A-w>";
            file3 = "<A-e>";
            file4 = "<A-r>";
            markFile = "<A-a>";
            listMarks = "<A-m>";
          };
          setupOpts = {
            defaults = {
              save_on_toggle = true;
              sync_on_ui_close = true;
            };

            # Optional: customize UI style for the menu
            menu = {
              title = "Harpoon";
              title_pos = "center";
              border = "rounded";
              ui_width_ratio = 0.40;
            };
          };
        };
      };

      ui = {
        borders.enable = true;
        noice.enable = true;
        colorizer.enable = true;
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
        nvim-session-manager.enable = false;
      };

      notes.todo-comments.enable = true;
      comments = {
        comment-nvim.enable = true;
      };
    };
  };
}
