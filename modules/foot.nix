_: {
  flake.modules.homeManager.core = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        inherit (config.desktop) font colors;
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
        };

        # By store path, not bare name: the consumers can hold a path, and §3
        # prefers that where they can.
        config.terminal = {
          argv = ["${pkgs.foot}/bin/footclient"];
          fallbackArgv = ["${pkgs.foot}/bin/foot"];
        };

        # Shared terminal for all hosts: the explicit base24 palette below is the
        # single source of terminal colours everywhere. stylix must NOT theme
        # foot on the stylix hosts — see stylix.targets.foot.enable = false in
        # ./stylix.nix.
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

            # base24 terminal mapping (./colors.nix): brights from base12-17,
            # extended colours 16/17 from base09/base0F.
            colors-dark = {
              foreground = strip colors.base05;
              background = strip colors.base00;

              selection-foreground = strip colors.base06;
              selection-background = strip colors.base02;

              regular0 = strip colors.base11;
              regular1 = strip colors.base08;
              regular2 = strip colors.base0B;
              regular3 = strip colors.base0A;
              regular4 = strip colors.base0D;
              regular5 = strip colors.base0E;
              regular6 = strip colors.base0C;
              regular7 = strip colors.base06;

              bright0 = strip colors.base03;
              bright1 = strip colors.base12;
              bright2 = strip colors.base14;
              bright3 = strip colors.base13;
              bright4 = strip colors.base16;
              bright5 = strip colors.base17;
              bright6 = strip colors.base15;
              bright7 = strip colors.base07;

              "16" = strip colors.base09;
              "17" = strip colors.base0F;
            };
          };
        };
      }
    )
  ];
}
