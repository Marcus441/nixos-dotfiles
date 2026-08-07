_: {
  # reads config.lib.stylix.colors
  aspectRequires.waybar = ["stylix"];

  flake.modules.homeManager.waybar = [
    (
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
          base0B
          base0C
          base0D
          ;
      in {
        programs.waybar.style = ''
          * {
            font-family: 'Inter', 'Symbols Nerd Font Mono';
            font-size: 12px;
            min-height: 0;
          }
          label.module {
            padding: 0;
          }
          window#waybar {
            background-color: #${base00};
            color: #${base05};
            border-bottom: 1px solid #${base01};
            min-height: 0;
          }
          .modules-left  { margin-left:  8px; }
          .modules-right { margin-right: 8px; }
          #bluetooth,
          #network,
          #pulseaudio,
          #battery,
          #custom-power {
            font-family: 'Symbols Nerd Font Mono', 'Inter';
          }
          #window {
            color: #${base03};
            font-weight: 400;
          }

          #workspaces {
            background-color: transparent;
            margin: 0 4px;
            padding: 0;
            border: none;
          }
          #workspaces button {
            all: unset;
            min-width: 24px;
            padding: 2px 4px;
            margin: 4px 2px;
            border-radius: 6px;
            background-color: #${base01};
            color: #${base05};
            font-weight: 600;
            border: none;
            transition: background-color 0.15s ease,
                        color 0.15s ease;
          }
          #workspaces button.empty {
            color: #${base03};
            background-color: #${base01};
          }
          #workspaces button.active {
            background-color: #${base0D};
            color: #${base00};
          }
          #workspaces button.urgent {
            background-color: #${base08};
            color: #${base00};
          }

          #custom-weather {
            font-weight: 400;
            color: #${base05};
            margin: 0 8px;
          }
          #clock {
            color: #${base05};
            font-weight: 400;
            margin: 0 4px;
          }
          #tray                   { margin-right: 12px; }
          #tray > .passive         { -gtk-icon-effect: dim; }
          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            color: #${base0A};
          }
          #bluetooth,
          #network,
          #pulseaudio,
          #battery {
            color: #${base03};
            margin: 0 4px;
            transition: color 0.15s ease;
          }
          #bluetooth           { margin: 0 4px 0 6px; }
          #bluetooth.connected { color: #${base0D}; }
          #network.disconnected,
          #network.linked      { color: #${base08}; }
          #pulseaudio.muted    { color: #${base08}; }
          #battery.warning:not(.charging)  { color: #${base0A}; }
          #battery.critical:not(.charging) { color: #${base08}; }
          #battery.charging                 { color: #${base0B}; }
          #battery.full,
          #battery.plugged                  { color: #${base0C}; }
          #custom-power {
            color: #${base08};
            margin: 0 8px 0 6px;
          }
          tooltip {
            background-color: #${base00};
            border: 1px solid #${base02};
            border-radius: 6px;
            padding: 2px;
          }
          tooltip label {
            color: #${base05};
            padding: 4px 8px;
          }
        '';
      }
    )
  ];
}
