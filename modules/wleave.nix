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
        inherit (lib.mapAttrs (_: lib.removePrefix "#") config.desktop.colors) base00 base01 base02 base03 base05 base08 base09 base0A base0C base0D base0E;
      in {
        powerMenu.command = "wleave";

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
          style = ''
            * {
              font-family: "Inter", "Symbols Nerd Font Mono";
              font-weight: bold;
              transition: none;
              animation: none;
            }
            window {
              background-color: #${base00};
            }
            /* adw-gtk3 gives buttons a radius, a gradient and a shadow.
               None of it survives contact with the flat palette. */
            button {
              color: #${base05};
              background-color: #${base01};
              background-image: none;
              box-shadow: none;
              border: 1px solid #${base02};
              border-radius: 0;
              margin: 15px;
              padding: 40px;
              font-size: 18px;
            }
            button:hover,
            button:focus,
            button:active {
              background-color: #${base02};
              border-color: #${base03};
              background-image: none;
              box-shadow: none;
            }
            #lock     { color: #${base0D}; }
            #logout   { color: #${base0C}; }
            #suspend  { color: #${base0A}; }
            #hibernate { color: #${base09}; }
            #shutdown  { color: #${base08}; }
            #reboot    { color: #${base0E}; }
          '';
        };
      }
    )
  ];
}
