{config, ...}: let
  inherit (config.lib.stylix.colors) base00 base01 base03 base05 base0D base0E base08;
in {
  programs.waybar.style = ''
    * {
      border: none;
      border-radius: 0;
      min-height: 0;
    }

    window#waybar {
      background-color: #${base00};
      border-bottom: 1px solid #${base01};
    }

    #custom-launcher {
      color: #${base0E};
      margin-left: 12px;
      margin-right: 5px;
    }

    #workspaces button {
      padding: 0 4px;
      margin: 0 4px;
      color: #${base05};
      transition: all 0.3s ease;
    }

    #workspaces button.empty {
      color: #${base03};
    }

    #workspaces button.active {
      color: #${base0D};
    }

    #workspaces button.urgent {
      color: #${base08};
    }

    #clock {
      color: #${base05};
      font-weight: bold;
    }

    #cpu, #memory, #disk, #bluetooth, #network, #battery, #backlight, #pulseaudio {
      margin: 0 8px;
      color: #${base05};
    }

    #tray {
      margin-right: 10px;
    }

    #custom-power {
      color: #${base08};
      margin-left: 10px;
      margin-right: 15px;
    }

    tooltip {
      background-color: #${base00};
      border: 1px solid #${base01};
      border-radius: 4px;
    }

    tooltip label {
      color: #${base05};
      padding: 4px;
    }
  '';
}
