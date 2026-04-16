{
  monitors,
  user,
  sensitivity,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      env = [
        "NIXOS_OZONE_WL,1"
        "QT_QPA_PLATFORM,wayland"
        "XDG_SCREENSHOTS_DIR,/home/${user}/Screenshots"
      ];

      monitor = map (m: m.hyprland) monitors;

      "$mainMod" = "SUPER";
      "$terminal" = "ghostty +new-window -e fish -c \"fastfetch; exec fish\"";
      "$fileManager" = "thunar";
      "$browser" = "uwsm app -- helium";

      exec-once = [
        "uwsm app -- wl-paste --type text --watch cliphist store"
        "uwsm app -- wl-paste --type image --watch cliphist store"
      ];

      general = {
        gaps_in = 2.5;
        gaps_out = 5;
        border_size = 2;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        shadow.enabled = false;
        blur.enabled = false;
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 0, 0, ease"
        ];
      };

      input = {
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.6;
        };
        accel_profile = "flat";
        inherit sensitivity;
      };

      gestures = {
        gesture = "3, horizontal, workspace";
        workspace_swipe_invert = true;
        workspace_swipe_distance = 700;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
      };

      cursor = {
        hide_on_key_press = true;
        warp_on_change_workspace = 1;
      };

      windowrule = [
        # Maximize suppression
        "suppress_event maximize, match:class .*"
        "no_focus on, match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false"

        # Xwaylandvideobridge
        "opacity 0.0 override, match:class ^(xwaylandvideobridge)$"
        "no_anim on, match:class ^(xwaylandvideobridge)$"
        "no_initial_focus on, match:class ^(xwaylandvideobridge)$"
        "max_size 1 1, match:class ^(xwaylandvideobridge)$"
        "no_blur on, match:class ^(xwaylandvideobridge)$"
        "no_focus on, match:class ^(xwaylandvideobridge)$"

        # Floating windows (tagging)
        "tag +floating-window, match:class ^(org.pulseaudio.pavucontrol|.blueman-manager-wrapped|thunar|Thunar|xdg-desktop-portal-gtk)$"
        "tag +floating-window, match:title ^(ghostty-float)$"
        "float on, match:tag floating-window"
        "center on, match:tag floating-window"
        "size 1200 600, match:tag floating-window"

        # Smart gaps
        "border_size 0, match:float 0, match:workspace w[tv1]"
        "rounding 0, match:float 0, match:workspace w[tv1]"
        "border_size 0, match:float 0, match:workspace f[1]"
        "rounding 0, match:float 0, match:workspace f[1]"
      ];

      workspace = [
        "f[1], gapsout:0, gapsin:0"
        "w[tv1], gapsout:0, gapsin:0"
      ];

      layerrule = [
        "no_anim on, match:namespace selection"
        "no_anim on, match:namespace walker"
      ];
    };
  };
}
