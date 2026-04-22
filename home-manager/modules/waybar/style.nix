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
    }
    .modules-left  { margin-left:  8px; }
    .modules-right { margin-right: 8px; }
    #bluetooth,
    #network,
    #pulseaudio,
    #battery,
    #custom-launcher,
    #custom-power {
      font-family: 'Symbols Nerd Font Mono', 'Inter';
    }
    #custom-launcher {
      font-size: 14px;
      color: #${base0D};
      margin: 0 8px 0 12px;
    }
    #custom-sep {
      color: #${base01};
      margin: 0 4px;
    }
    #workspaces button {
      all: initial;
      font-family: 'JetBrainsMono Nerd Font';
      font-size: 12px;
      color: #${base03};
      background-color: transparent;
      padding: 0 6px;
      margin: 0 1.5px;
      min-width: 9px;
      transition: color 0.15s ease;
    }
    #workspaces button.empty   { opacity: 0.35; }
    #workspaces button.active  { color: #${base05}; font-weight: 700; }
    #workspaces button.urgent  { color: #${base08}; }
    #custom-weather {
      color: #${base03};
      margin: 0 8px;
    }
    #clock {
      color: #${base05};
      font-weight: 700;
    }
    #tray                    { margin-right: 12px; }
    #tray > .passive         { -gtk-icon-effect: dim; }
    #tray > .needs-attention {
      -gtk-icon-effect: highlight;
      color: #${base0A};
    }
    #bluetooth,
    #network,
    #pulseaudio,
    #cpu,
    #memory,
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
    #cpu,
    #memory {
      font-family: 'JetBrainsMono Nerd Font';
      margin: 0 3px;
    }
    #cpu.warning               { color: #${base0A}; }
    #cpu.critical              { color: #${base08}; }
    #memory.warning            { color: #${base0A}; }
    #memory.critical           { color: #${base08}; }
    #battery.warning:not(.charging)  { color: #${base0A}; }
    #battery.critical:not(.charging) { color: #${base08}; }
    #battery.charging                { color: #${base0B}; }
    #battery.full,
    #battery.plugged                 { color: #${base0C}; }
    #custom-power {
      color: #${base08};
      margin: 0 8px 0 6px;
    }
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
