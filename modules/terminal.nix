_: {
  flake.modules.homeManager.core = [
    (
      {
        config,
        lib,
        ...
      }: {
        # load-bearing: docs/decisions/terminal.md#terminal-namespace
        options.terminal = {
          argv = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Program and arguments that open a terminal.";
          };

          fallbackArgv = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = config.terminal.argv;
            description = "Terminal that does not depend on a running server. Defaults to `argv`, which is the honest answer for a terminal with no daemon.";
          };

          # load-bearing: docs/decisions/terminal.md#terminal-transient
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

          # load-bearing: docs/decisions/terminal.md#terminal-appid
          appIdArgv = lib.mkOption {
            type = lib.types.functionTo (lib.types.listOf lib.types.str);
            description = "Arguments making the terminal announce the given app-id. A function because the three spellings differ in shape, not just in name.";
          };

          compactArgv = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "`transientArgv` at `compactSize`, so a TUI needing 24 rows fits a session's floating window.";
          };

          # load-bearing: docs/decisions/terminal.md#terminal-compact
          compactSize = lib.mkOption {
            type = lib.types.int;
            readOnly = true;
            default = config.desktop.font.size * 3 / 5;
            description = "Font size at which a TUI needing 24 rows fits a session's floating window.";
          };

          # load-bearing: docs/decisions/terminal.md#terminal-desktopfile
          desktopFile = lib.mkOption {
            type = lib.types.str;
            description = "The terminal's own desktop entry. No default: two terminal aspects on one host collide here, by name, instead of silently concatenating their argv.";
          };

          binary = lib.mkOption {
            type = lib.types.str;
            description = "Name a third-party tool reading $TERMINAL should spawn.";
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

        config.home.sessionVariables.TERMINAL = config.terminal.binary;
      }
    )
  ];

  flake.modules.homeManager.hyprland = [
    (
      {config, ...}: {
        terminal.transientArgv =
          config.terminal.argv ++ config.terminal.appIdArgv config.floatingWindow.term;
      }
    )
  ];
}
