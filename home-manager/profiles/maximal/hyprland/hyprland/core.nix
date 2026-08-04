{
  sensitivity,
  config,
  ...
}: let
  c = config.lib.stylix.colors;
in {
  wayland.windowManager.hyprland.settings = {
    config = {
      general = {
        gaps_in = 2.5;
        gaps_out = 5;
        border_size = 2;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
        col = {
          active_border = "0xff${c.base0D}";
          inactive_border = "0xff${c.base03}";
        };
      };

      decoration = {
        rounding = 0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "0x66${c.base00}";
        };
        blur = {
          enabled = true;
          size = 4;
          passes = 2;
          xray = true;
          new_optimizations = true;
        };
      };

      input = {
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.6;
        };
        accel_profile = "flat";
        inherit sensitivity;
      };

      dwindle = {
        force_split = 0;
        preserve_split = true;
        smart_split = false;
        smart_resizing = true;
        permanent_direction_override = false;
        special_scale_factor = 1.0;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        default_split_ratio = 1.0;
        split_bias = 0;
        precise_mouse_move = false;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
        vrr = 2;
      };

      cursor = {
        hide_on_key_press = true;
        warp_on_change_workspace = 1;
      };

      gestures = {
        workspace_swipe_invert = true;
        workspace_swipe_distance = 700;
      };
    };
    gesture = {
      fingers = 3;
      direction = "horizontal";
      action = "workspace";
    };
  };
}
