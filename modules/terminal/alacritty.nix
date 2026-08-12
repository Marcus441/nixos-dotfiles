_: {
  # load-bearing: docs/decisions/terminal.md#terminal-daemons
  flake.modules.nixos.alacritty = [
    {dwl.autostart = ["alacritty --daemon"];}
  ];

  flake.modules.homeManager.alacritty = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        inherit (config.desktop) ansi font colors16;

        # the eight ANSI colour names, in slot order; the index is the slot
        names = ["black" "red" "green" "yellow" "blue" "magenta" "cyan" "white"];
        slots = offset:
          lib.listToAttrs (lib.imap0 (
              i: name: lib.nameValuePair name (builtins.elemAt ansi (offset + i))
            )
            names);
      in {
        terminal = {
          # load-bearing: docs/decisions/terminal.md#terminal-daemons
          argv = ["${pkgs.alacritty}/bin/alacritty" "msg" "create-window"];
          fallbackArgv = ["${pkgs.alacritty}/bin/alacritty"];
          appIdArgv = id: ["--class" id];
          exec = ["-e"];
          compactArgv = config.terminal.transientArgv ++ ["-o" "font.size=${toString config.terminal.compactSize}"];
          desktopFile = "Alacritty.desktop";
          binary = "alacritty";
        };

        # load-bearing: docs/decisions/terminal.md#terminal-daemons
        systemd.user.services.alacritty = {
          Unit = {
            Description = "Alacritty daemon, resident so that opening a window costs nothing";
            PartOf = ["graphical-session.target"];
            After = ["graphical-session.target"];
            ConditionEnvironment = "WAYLAND_DISPLAY";
          };

          Install.WantedBy = ["graphical-session.target"];

          Service = {
            ExecStart = "${pkgs.alacritty}/bin/alacritty --daemon";
            Restart = "on-failure";
          };
        };

        programs.alacritty = {
          enable = true;
          settings = {
            font = {
              inherit (font) size;
              normal.family = font.name;
            };

            window.padding = {
              x = 8;
              y = 8;
            };

            scrolling.history = 10000;
            mouse.hide_when_typing = true;

            # load-bearing: docs/decisions/terminal.md#terminal-clipboard-keys
            keyboard.bindings = [
              {
                key = "Cut";
                action = "Copy";
              }
            ];

            # load-bearing: docs/decisions/terminal.md#terminal-ansi
            colors = {
              primary = {
                foreground = colors16.base05;
                background = colors16.base00;
              };

              selection = {
                text = colors16.base06;
                background = colors16.base02;
              };

              cursor = {
                text = colors16.base00;
                cursor = colors16.base05;
              };

              normal = slots 0;
              bright = slots 8;

              indexed_colors = [
                {
                  index = 16;
                  color = colors16.base09;
                }
                {
                  index = 17;
                  color = colors16.base0F;
                }
              ];
            };
          };
        };
      }
    )
  ];
}
