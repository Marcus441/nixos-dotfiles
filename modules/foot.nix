_: {
  # load-bearing: docs/decisions/terminal.md#foot-server
  flake.modules.nixos.core = [
    {dwl.autostart = ["foot --server"];}
  ];

  flake.modules.homeManager.core = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        inherit (config.desktop) ansi font colors16;
        fontAt = size:
          "${font.name}:size=${toString size}"
          + lib.optionalString (!font.ligatures) ":fontfeatures=-calt,-liga,-clig,-dlig";
        fontStr = fontAt font.size;

        strip = c: lib.removePrefix "#" c;
      in {
        options.terminal = {
          argv = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Program and arguments that open a terminal.";
          };

          fallbackArgv = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Terminal that does not depend on a running server.";
          };

          # load-bearing: docs/decisions/terminal.md#foot-transient
          transientArgv = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = config.terminal.argv;
            description = "Terminal for a TUI opened, used and closed in one sitting. A session renders that however it likes; the default is `argv`.";
          };

          # load-bearing: docs/decisions/terminal.md#terminal-exec
          exec = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Arguments introducing the command to run, appended after every option and immediately before it. Empty where the terminal takes a bare trailing command.";
          };

          compactArgv = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            # load-bearing: docs/decisions/terminal.md#foot-compact
            default = config.terminal.transientArgv ++ ["--override" "main.font=${fontAt (font.size * 3 / 5)}"];
            description = "`transientArgv` at a font size chosen so a TUI needing 24 rows fits a session's floating window.";
          };

          command = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = lib.escapeShellArgs config.terminal.argv;
            description = "`argv` as a shell command.";
          };

          fallbackCommand = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = lib.escapeShellArgs config.terminal.fallbackArgv;
            description = "`fallbackArgv` as a shell command.";
          };

          transientCommand = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = lib.escapeShellArgs config.terminal.transientArgv;
            description = "`transientArgv` as a shell command.";
          };
        };

        config.terminal = {
          argv = ["${pkgs.foot}/bin/footclient"];
          fallbackArgv = ["${pkgs.foot}/bin/foot"];
        };

        config.programs.foot = {
          enable = true;
          # load-bearing: docs/decisions/terminal.md#foot-server
          server.enable = true;
          settings = {
            main = {
              font = fontStr;
              pad = "8x8";
              initial-color-theme = "dark";
            };
            scrollback.lines = 10000;
            mouse.hide-when-typing = "yes";
            mouse.alternate-scroll-mode = "no";

            # load-bearing: docs/decisions/terminal.md#terminal-ansi
            colors-dark =
              {
                foreground = strip colors16.base05;
                background = strip colors16.base00;

                selection-foreground = strip colors16.base06;
                selection-background = strip colors16.base02;

                "16" = strip colors16.base09;
                "17" = strip colors16.base0F;
              }
              // lib.listToAttrs (lib.imap0 (
                  i: hex:
                    lib.nameValuePair
                    "${
                      if i < 8
                      then "regular"
                      else "bright"
                    }${toString (lib.mod i 8)}"
                    (strip hex)
                )
                ansi);
          };
        };
      }
    )
  ];

  flake.modules.homeManager.hyprland = [
    (
      {config, ...}: {
        terminal.transientArgv = config.terminal.argv ++ ["--app-id" config.floatingWindow.term];
      }
    )
  ];
}
