{
  lib,
  monitors,
  render,
  ...
}: let
  mkLabel = m: {
    monitor = render.identify m;
    text = "$TIME";
    # Scale font size with physical height to ensure consistent physical size.
    # 1080 / 11 ≈ 98.
    # 2160 / 11 ≈ 196.
    font_size = builtins.floor (m.height / 11);
    # Position as an offset from center.
    position = "0, ${toString (builtins.floor (m.height / 4))}";
    halign = "center";
    valign = "center";
    shadow_passes = 1;
  };

  mkBackground = m: {
    monitor = render.identify m;
    path = "screenshot";
    blur_passes = 3;
    blur_size = 8;
  };

  mkInputField = m: {
    monitor = render.identify m;
    size = "${toString (builtins.floor (m.width / 10))}, ${toString (builtins.floor (m.height / 20))}";
    position = "0, -${toString (builtins.floor (m.height / 10))}";
    dots_center = true;
    outline_thickness = 5;
    shadow_passes = 1;
  };
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 10;
        hide_cursor = true;
        no_fade_in = false;
      };

      # Generate configurations for all detected monitors
      background = lib.mkForce (map mkBackground monitors);
      label = lib.mkForce (map mkLabel monitors);
      input-field = lib.mkForce (map mkInputField monitors);
    };
  };
}
