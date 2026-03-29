{config, ...}: let
  inherit
    (config.lib.stylix.colors)
    base00
    base01
    base02
    base03
    base04
    base05
    base06
    base07
    base08
    base09
    base0A
    base0B
    base0C
    base0D
    base0E
    base0F
    ;
in {
  programs.waybar.style = ''
    * {
      border: none;
      border-radius: 0;
      min-height: 0;
      font-family: "Ubuntu", "Noto Sans", "Symbols Nerd Font Mono";
      font-size: 13px;
      font-weight: bold;
    }

    window#waybar {
      background-color: #${base00};
      border-bottom: 1px solid #${base01};
      transition-property: background-color;
      transition-duration: 0.5s;
    }

    window#waybar.hidden {
      opacity: 0.5;
    }

    #workspaces {
      background-color: transparent;
      margin: 0 4px;
    }

    #workspaces button {
      all: initial;
      min-width: 0;
      padding: 0 10px;
      margin: 0 2px;
      color: #${base04};
      border-bottom: 3px solid transparent;
      transition: all 0.3s ease;
    }

    #workspaces button.active {
      color: #${base0D};
      border-bottom: 3px solid #${base0D};
    }

    #workspaces button:hover {
      color: #${base05};
      border-bottom-color: #${base04};
    }

    #workspaces button.urgent {
      color: #${base08};
      border-bottom-color: #${base08};
    }

    #cpu,
    #memory,
    #custom-kernel,
    #custom-power,
    #custom-logo,
    #disk,
    #battery,
    #backlight,
    #pulseaudio,
    #network,
    #clock,
    #tray,
    #idle_inhibitor,
    #bluetooth,
    #custom-weather {
      margin: 0 8px;
      padding: 4px 2px;
      border-bottom: 3px solid transparent;
      transition: all 0.3s ease;
    }

    /* LEFT SIDE */
    #custom-logo {
      color: #${base0E};
      border-bottom-color: #${base0E};
    }

    #custom-weather {
      color: #${base0C};
      border-bottom-color: #${base0C};
    }

    /* CENTER */
    #clock {
      color: #${base0E};
      border-bottom-color: #${base0E};
    }

    /* RIGHT SIDE - Rainbow Spectrum Underlines */
    #custom-kernel {
      color: #${base08};
      border-bottom-color: #${base08};
    }

    #cpu {
      color: #${base09};
      border-bottom-color: #${base09};
    }

    #memory {
      color: #${base0A};
      border-bottom-color: #${base0A};
    }

    #disk {
      color: #${base0B};
      border-bottom-color: #${base0B};
    }

    #bluetooth {
      color: #${base0C};
      border-bottom-color: #${base0C};
    }

    #network {
      color: #${base0D};
      border-bottom-color: #${base0D};
    }

    #battery {
      color: #${base0E};
      border-bottom-color: #${base0E};
    }

    #backlight {
      color: #${base0F};
      border-bottom-color: #${base0F};
    }

    #idle_inhibitor {
      color: #${base0E};
      border-bottom-color: #${base0E};
    }

    #pulseaudio {
      color: #${base08};
      border-bottom-color: #${base08};
    }

    #tray {
      color: #${base05};
      border-bottom-color: #${base04};
    }

    #custom-power {
      color: #${base08};
      border-bottom-color: #${base08};
      margin-right: 12px;
    }

    /* Logic-based states */
    #pulseaudio.muted {
      color: #${base03};
      border-bottom-color: #${base03};
    }

    #idle_inhibitor.activated {
      color: #${base08};
      border-bottom-color: #${base08};
      text-shadow: 0 0 5px #${base08};
    }

    #battery.warning:not(.charging) {
      color: #${base09};
      border-bottom-color: #${base09};
    }

    #battery.critical:not(.charging) {
      color: #${base08};
      border-bottom-color: #${base08};
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
    }

    #battery.charging {
      color: #${base0B};
      border-bottom-color: #${base0B};
    }

    tooltip {
      border-radius: 4px;
      padding: 15px;
      background-color: #${base00};
      border: 1px solid #${base01};
    }

    tooltip label {
      padding: 5px;
      color: #${base05};
    }

    @keyframes blink {
      to {
        opacity: 0.5;
        border-bottom-color: transparent;
      }
    }
  '';
}
