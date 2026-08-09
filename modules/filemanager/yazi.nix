_: {
  flake.modules.homeManager.yazi = [
    (
      {
        config,
        lib,
        ...
      }: let
        # load-bearing: docs/decisions/terminal.md#yazi-command
        command = lib.escapeShellArgs (
          config.terminal.transientArgv ++ ["${config.programs.yazi.finalPackage}/bin/yazi"]
        );
      in {
        fileManager.command = command;

        xdg = {
          desktopEntries.yazi = {
            name = "Yazi";
            genericName = "File Manager";
            icon = "system-file-manager";
            exec = "${command} %f";
            terminal = false;
            startupNotify = false;
            categories = ["System" "FileTools" "FileManager"];
            mimeType = ["inode/directory"];
          };

          mimeApps.defaultApplications."inode/directory" = "yazi.desktop";
        };
      }
    )
  ];

  # load-bearing: docs/decisions/terminal.md#yazi-requires
  aspectRequires.yazi = ["apps"];

  flake.modules.homeManager.apps = [
    (
      {
        pkgs,
        config,
        ...
      }: let
        inherit (config.desktop) colors16;
      in {
        programs.yazi = {
          enable = true;
          shellWrapperName = "y";

          settings = {
            plugin = {
              prepend_fetchers = [
                {
                  url = "*";
                  run = "git";
                  group = "git";
                }
                {
                  url = "*/";
                  run = "git";
                  group = "git";
                }
              ];
            };
          };

          theme = {
            mgr = {
              marker_marked = {
                fg = "lightcyan";
                bg = "lightcyan";
              };
              tab_width = 1;
              syntect_theme = "${config.desktop.syntaxTheme}";

              border_style.fg = colors16.base0D;
            };

            confirm.border.fg = colors16.base0D;
            cmp.border.fg = colors16.base0D;
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

          plugins = {
            inherit (pkgs.yaziPlugins) git;
          };

          initLua = ''
            require("git"):setup()
          '';
        };
      }
    )
  ];
}
