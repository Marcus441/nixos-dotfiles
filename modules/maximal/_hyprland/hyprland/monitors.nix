{monitors, ...}: {
  # Translate the neutral monitor data into Hyprland's lua hl.monitor({...}) form.
  wayland.windowManager.hyprland.settings.monitor =
    map (m: {
      _args = [
        {
          output = m.name;
          mode = "${toString m.width}x${toString m.height}@${toString m.refresh}";
          position = "${toString m.x}x${toString m.y}";
          inherit (m) scale;
        }
      ];
    })
    monitors;
}
