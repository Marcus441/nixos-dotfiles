_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.powerMenu.command = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Command opening a power menu, bare of any session launcher prefix. Empty when no aspect provides one.";
        };
      }
    )
  ];

  flake.modules.homeManager.wleave = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        # load-bearing: docs/decisions/sessions.md#wleave-toggle
        toggle = pkgs.writeShellScript "wleave-toggle" ''
          if hyprctl layers 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q 'namespace: wleave'; then
            exec systemctl --user restart wleave.service
          fi

          exec ${pkgs.wleave}/bin/wleave
        '';
      in {
        powerMenu.command = "${toggle}";

        # load-bearing: docs/decisions/sessions.md#wleave-service
        systemd.user.services.wleave = {
          Unit = {
            Description = "wleave power menu, resident so that opening it costs nothing";
            PartOf = ["graphical-session.target"];
            After = ["graphical-session.target"];
            # load-bearing: docs/decisions/sessions.md#wleave-toggle
            StartLimitIntervalSec = 0;
          };

          Install.WantedBy = ["graphical-session.target"];

          Service = {
            ExecStart = lib.concatStringsSep " " [
              "${pkgs.wleave}/bin/wleave"
              "--service"
              "--layout ${config.xdg.configFile."wleave/layout.json".source}"
              "--css ${config.xdg.configFile."wleave/style.css".source}"
            ];
            Restart = "on-failure";
          };
        };

        programs.wleave = {
          enable = true;
          settings = {
            margin = 200;
            close-on-lost-focus = true;
            show-keybinds = true;
            no-version-info = true;

            buttons =
              lib.optional (config.lock.command != "") {
                label = "lock";
                action = config.lock.command;
                text = "Lock";
                keybind = "l";
                icon = "${pkgs.wleave}/share/wleave/icons/lock.svg";
              }
              ++ lib.optional (config.logout.command != "") {
                label = "logout";
                action = config.logout.command;
                text = "Logout";
                keybind = "e";
                icon = "${pkgs.wleave}/share/wleave/icons/logout.svg";
              }
              ++ [
                {
                  label = "suspend";
                  action = "systemctl suspend";
                  text = "Suspend";
                  keybind = "u";
                  icon = "${pkgs.wleave}/share/wleave/icons/suspend.svg";
                }
                {
                  label = "hibernate";
                  action = "systemctl hibernate";
                  text = "Hibernate";
                  keybind = "h";
                  icon = "${pkgs.wleave}/share/wleave/icons/hibernate.svg";
                }
                {
                  label = "shutdown";
                  action = "systemctl poweroff";
                  text = "Shutdown";
                  keybind = "s";
                  icon = "${pkgs.wleave}/share/wleave/icons/shutdown.svg";
                }
                {
                  label = "reboot";
                  action = "systemctl reboot";
                  text = "Reboot";
                  keybind = "r";
                  icon = "${pkgs.wleave}/share/wleave/icons/reboot.svg";
                }
              ];
          };
        };
      }
    )
  ];
}
