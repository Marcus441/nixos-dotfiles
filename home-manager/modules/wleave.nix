{
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.stylix.colors) base00 base01 base02 base05 base07 base08 base09 base0A base0C base0D base0E;
in {
  programs.wleave = {
    enable = true;
    settings = {
      margin = 200;
      close-on-lost-focus = true;
      show-keybinds = true;
      no-version-info = true;
      buttons = [
        {
          label = "lock";
          action = "hyprlock";
          text = "Lock";
          keybind = "l";
          icon = "${pkgs.wleave}/share/wleave/icons/lock.svg";
        }
        {
          label = "logout";
          action = "hyprctl dispatch exit";
          text = "Logout";
          keybind = "e";
          icon = "${pkgs.wleave}/share/wleave/icons/logout.svg";
        }
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
        transition: all 0.2s ease;
      }
      window {
        background-color: rgba(0, 0, 0, 0.85);
      }
      button {
        color: #${base05};
        background-color: #${base01};
        border: 2px solid #${base00};
        margin: 15px;
        padding: 40px;
        font-size: 18px;
      }
      button:hover,
      button:focus,
      button:active {
        background-color: #${base02};
        color: #${base07};
        border-color: #${base02};
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
