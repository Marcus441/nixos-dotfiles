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
        fontStr =
          "${font.name}:size=${toString font.size}"
          + lib.optionalString (!font.ligatures) ":fontfeatures=-calt,-liga,-clig,-dlig";

        strip = c: lib.removePrefix "#" c;
      in {
        # `argv` for the same reason as `launcher` (§3): dwl's binds are a C argv
        # array, Hyprland's are shell strings. The fallback is a role of its own
        # because every spawn point needs one -- footclient is useless if the
        # server is down, which is precisely when you want a terminal.
        options.terminal = {
          argv = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Program and arguments that open a terminal.";
          };

          fallbackArgv = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Terminal that does not depend on a running server.";
          };

          floatingArgv = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Terminal carrying the `floatingWindow.term` app-id, for a TUI that wants a window rather than a tile.";
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

          floatingCommand = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = lib.escapeShellArgs config.terminal.floatingArgv;
            description = "`floatingArgv` as a shell command.";
          };
        };

        # By store path, not bare name: the consumers can hold a path, and §3
        # prefers that where they can.
        config.terminal = {
          argv = ["${pkgs.foot}/bin/footclient"];
          fallbackArgv = ["${pkgs.foot}/bin/foot"];

          # foot is the one window this config floats that can name itself, so
          # the convention in ./floating-windows.nix is reachable here and
          # nowhere else. Set unconditionally rather than per session: an app-id
          # only means something to a session carrying a rule for it, so under
          # dwl this tiles like any other terminal.
          floatingArgv = config.terminal.argv ++ ["--app-id" config.floatingWindow.term];
        };

        # Shared terminal for all hosts: the base16 mapping below is the single
        # source of terminal colours everywhere. Programs that render through
        # ANSI inherit it from here -- but see tmtheme.nix for the two that
        # must not.
        config.programs.foot = {
          enable = true;
          # Daemon mode: terminals spawn as footclient against this server. The
          # systemd unit binds to graphical-session.target, which uwsm activates
          # on hyprland; the dwl session is a plain script, so dwl starts the
          # server from its own autostart instead (see ./dwl.nix). Every
          # spawn point keeps a fallback bind to plain foot in case the server is
          # down.
          server.enable = true;
          settings = {
            main = {
              font = fontStr;
              pad = "8x8";
              initial-color-theme = "dark";
            };
            scrollback.lines = 10000;
            mouse.hide-when-typing = "yes";

            # The standard base16 slot mapping, not a base24 one. A TUI asking
            # for "the base16 theme" asserts ANSI 9 is base09; the brights used
            # to come from base12-17 and that assertion was false, so anything
            # reading a colour by number was quietly off by a slot. The cost is
            # that regular and bright now differ only in 0 and 7 -- the punch
            # base24 bought is deliberately gone.
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
}
