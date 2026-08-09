{config, ...}: let
  top = config;
in {
  flake.modules.homeManager.hyprland = [
    (
      {
        lib,
        monitors,
        ...
      }: let
        mkLabel = m: {
          monitor = top.flake.lib.monitors.identify m;
          text = "$TIME";
          font_size = builtins.floor (m.height / 11);
          position = "0, ${toString (builtins.floor (m.height / 4))}";
          halign = "center";
          valign = "center";
          shadow_passes = 1;
        };

        mkBackground = m: {
          monitor = top.flake.lib.monitors.identify m;
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        };

        mkInputField = m: {
          monitor = top.flake.lib.monitors.identify m;
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

            background = lib.mkForce (map mkBackground monitors);
            label = lib.mkForce (map mkLabel monitors);
            input-field = lib.mkForce (map mkInputField monitors);
          };
        };
      }
    )
  ];
}
