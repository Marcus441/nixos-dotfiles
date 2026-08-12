_: {
  flake.modules.homeManager.core = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        inherit (config.desktop) font colors16;
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

            # load-bearing: docs/decisions/terminal.md#foot-base16
            colors-dark = {
              foreground = strip colors16.base05;
              background = strip colors16.base00;

              selection-foreground = strip colors16.base06;
              selection-background = strip colors16.base02;

              regular0 = strip colors16.base00;
              regular1 = strip colors16.base08;
              regular2 = strip colors16.base0B;
              regular3 = strip colors16.base0A;
              regular4 = strip colors16.base0D;
              regular5 = strip colors16.base0E;
              regular6 = strip colors16.base0C;
              regular7 = strip colors16.base05;

              bright0 = strip colors16.base03;
              bright1 = strip colors16.base08;
              bright2 = strip colors16.base0B;
              bright3 = strip colors16.base0A;
              bright4 = strip colors16.base0D;
              bright5 = strip colors16.base0E;
              bright6 = strip colors16.base0C;
              bright7 = strip colors16.base07;

              "16" = strip colors16.base09;
              "17" = strip colors16.base0F;
            };
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
