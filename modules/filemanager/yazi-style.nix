_: {
  flake.modules.homeManager.apps = [
    (
      {config, ...}: let
        inherit (config.desktop) colors colors16;
      in {
        programs.yazi.settings = {
          input = {
            cd_title = " Change directory:";
            create_title = [" Create:" " Create (dir):"];
            rename_title = " Rename:";
            filter_title = " Filter:";
            find_title = [" Find next:" " Find previous:"];
            search_title = " Search via {n}:";
            shell_title = [" Shell:" " Shell (block):"];
          };

          confirm = {
            trash_title = " Trash {n} selected file{s}?";
            delete_title = " Permanently delete {n} selected file{s}?";
            overwrite_title = " Overwrite file?";
            quit_title = " Quit?";
          };

          pick.open_title = " Open with:";
        };

        programs.yazi.theme = {
          mgr = {
            marker_marked = {
              fg = "lightcyan";
              bg = "lightcyan";
            };
            tab_width = 1;
            syntect_theme = "${config.desktop.syntaxTheme}";

            border_style.fg = colors16.base0D;
          };

          confirm = {
            border.fg = colors16.base0D;

            btn_yes = {
              fg = colors.base14;
              bold = true;
            };
            btn_no.fg = colors.base12;
            btn_labels = ["  󰄬 Yes  " "  󰅖 No  "];
          };

          cmp = {
            border.fg = colors16.base0D;

            icon_file = "󰈔";
            icon_folder = "󰉋";
            icon_command = "󰆍";
          };

          notify = {
            icon_info = "󰋽";
            icon_warn = "󰀪";
            icon_error = "󰅚";
          };

          input.border.fg = colors16.base0D;
          pick.border.fg = colors16.base0D;
          spot.border.fg = colors16.base0D;
          tasks.border.fg = colors16.base0D;

          indicator = {
            padding = {
              open = "▐";
              close = "▌";
            };

            preview = {
              underline = false;
              bg = colors16.base02;
            };
          };

          # load-bearing: docs/decisions/terminal.md#yazi-reset
          mode = {
            normal_main = {
              fg = colors16.base00;
              bg = colors16.base0D;
              bold = true;
            };
            normal_alt = {
              fg = colors16.base0D;
              bg = colors16.base00;
            };
            select_main = {
              fg = colors16.base00;
              bg = colors16.base0B;
              bold = true;
            };
            select_alt = {
              fg = colors16.base0B;
              bg = colors16.base00;
            };
            unset_main = {
              fg = colors16.base00;
              bg = colors16.base08;
              bold = true;
            };
            unset_alt = {
              fg = colors16.base08;
              bg = colors16.base00;
            };
          };

          status = {
            sep_left = {
              open = "▐";
              close = "▌";
            };
            sep_right = {
              open = "▐";
              close = "▌";
            };

            progress_normal = {
              fg = colors16.base0D;
              bg = "reset";
            };
            progress_error = {
              fg = colors16.base08;
              bg = "reset";
            };
          };

          which = {
            cols = 3;
            separator = "  ";
          };

          icon = {
            dirs = [];
            conds = [
              {
                "if" = "orphan";
                text = "";
              }
              {
                "if" = "link";
                text = "";
              }
              {
                "if" = "block";
                text = "";
              }
              {
                "if" = "char";
                text = "";
              }
              {
                "if" = "fifo";
                text = "";
              }
              {
                "if" = "sock";
                text = "";
              }
              {
                "if" = "sticky";
                text = "";
              }
              {
                "if" = "dummy";
                text = "";
              }
              {
                "if" = "dir & hovered";
                text = "";
              }
              {
                "if" = "dir";
                text = "";
              }
              {
                "if" = "exec";
                text = "";
              }
              {
                "if" = "!dir";
                text = "";
              }
            ];
          };
        };
      }
    )
  ];
}
