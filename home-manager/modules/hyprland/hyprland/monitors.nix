{monitors, ...}: {
  wayland.windowManager.hyprland.settings.monitor = map (m: m.hyprlandLua) monitors;
}
