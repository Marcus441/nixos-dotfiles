{config, ...}: let
  inherit
    (config.lib.stylix.colors)
    base00
    base01
    base02
    base03
    base05
    base08
    base0A
    base0E
    ;
in {
  programs.waybar.style = ''
    * {
      background-color: #${base00};
      color: #${base05};
      border: none;
      border-radius: 0;
      min-height: 0;
      font-family: 'JetBrainsMono Nerd Font';
      font-size: 12px;
    }

    window#waybar {
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
      background-color: #${base00};
      border-bottom: 1px solid #${base01};
    }

    .modules-left {
      margin-left: 8px;
    }

    .modules-right {
      margin-right: 8px;
    }

    /* Launcher */
    #custom-launcher {
      color: #${base0E};
      margin-left: 12px;
      margin-right: 5px;
    }

    /* Workspaces */
    #workspaces button {
      all: initial;
      font-family: 'JetBrainsMono Nerd Font';
      font-size: 12px;
      color: #${base05};
      background-color: transparent;
      padding: 0 6px;
      margin: 0 1.5px;
      min-width: 9px;
    }
    #workspaces button.empty {
      opacity: 0.4;
    }
    #workspaces button.active {
      opacity: 1;
      font-weight: 700;
    }
    #workspaces button.urgent {
      color: #${base08};
    }

    /* Spacer */
    #custom-spacer {
      opacity: 0;
      min-width: 4px;
    }

    /* Weather */
    #custom-weather {
      margin: 0 7.5px;
    }

    /* Clock */
    #clock {
      font-weight: 700;
      margin-left: 8.75px;
    }

    /* Tray */
    #tray {
      margin-right: 16px;
    }
    #tray > .passive {
      -gtk-icon-effect: dim;
    }
    #tray > .needs-attention {
      -gtk-icon-effect: highlight;
    }

    /* Status modules */
    #cpu,
    #disk,
    #backlight,
    #pulseaudio {
      margin: 0 7.5px;
    }

    #network {
      margin-right: 13px;
    }

    #bluetooth {
      margin-right: 17px;
    }

    /* Battery */
    #battery {
      margin: 0 7.5px;
    }
    #battery.warning:not(.charging) {
      color: #${base0A};
    }
    #battery.critical:not(.charging) {
      color: #${base08};
    }

    /* Power */
    #custom-power {
      margin-left: 5px;
      margin-right: 8px;
      color: #${base08};
    }

    /* Tooltips */
    tooltip {
      background-color: #${base00};
      border: 1px solid #${base02};
      border-radius: 4px;
      padding: 2px;
    }
    tooltip label {
      color: #${base05};
      padding: 4px 8px;
    }
  '';
}
