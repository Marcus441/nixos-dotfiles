{config, ...}: let
  top = config;
in {
  flake.modules.homeManager.hyprland = [
    (
      {
        config,
        lib,
        monitors,
        ...
      }: let
        # load-bearing: docs/conventions/colour.md
        inherit
          (lib.mapAttrs (_: c: "rgb(${lib.removePrefix "#" c})") config.desktop.colors)
          base00
          base03
          base05
          base08
          base09
          base0A
          base0D
          ;

        mkLabel = m: {
          monitor = top.flake.lib.monitors.identify m;
          text = "$TIME";
          color = base05;
          font_family = "Inter";
          font_size = builtins.floor (m.height / 11);
          position = "0, ${toString (builtins.floor (m.height / 4))}";
          halign = "center";
          valign = "center";
        };

        mkDateLabel = m: {
          monitor = top.flake.lib.monitors.identify m;
          text = ''cmd[update:60000] date +"%A, %d %B %Y"'';
          color = base03;
          font_family = "Inter";
          font_size = builtins.floor (m.height / 30);
          position = "0, ${toString (builtins.floor (m.height / 4) - builtins.floor (m.height / 11))}";
          halign = "center";
          valign = "center";
        };

        mkBackground = m: {
          monitor = top.flake.lib.monitors.identify m;
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          brightness = 0.35;
          vibrancy = 0.0;
          color = base00;
        };

        mkInputField = m: {
          monitor = top.flake.lib.monitors.identify m;
          size = "${toString (builtins.floor (m.width / 10))}, ${toString (builtins.floor (m.height / 20))}";
          position = "0, -${toString (builtins.floor (m.height / 10))}";
          dots_center = true;
          dots_rounding = -1;
          rounding = 0;
          outline_thickness = 2;
          outer_color = base0D;
          inner_color = base00;
          font_color = base05;
          font_family = "Inter";
          check_color = base0A;
          fail_color = base08;
          capslock_color = base09;
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
            label = lib.mkForce (map mkLabel monitors ++ map mkDateLabel monitors);
            input-field = lib.mkForce (map mkInputField monitors);
          };
        };
      }
    )
  ];
}
