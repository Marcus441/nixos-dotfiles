{
  inputs,
  hostname,
  ...
}: let
  hostMonitors = import "${inputs.self}/hosts/monitors.nix";
in {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    settings = {
      env = [
        # Hint Electron apps to use Wayland
        "NIXOS_OZONE_WL,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland"
        "XDG_SCREENSHOTS_DIR,$HOME/screens"
      ];

      monitor = builtins.concatStringsSep " " (
        if builtins.hasAttr hostname hostMonitors
        then builtins.getAttr hostname hostMonitors
        else []
      );

      "$mainMod" = "SUPER";
      "$terminal" = "ghostty --gtk-single-instance=true";
      "$fileManager" = "nautilus";
      "$browser" = "chromium";

      exec-once = [
        "waybar"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;

        border_size = 2;

        "col.active_border" = "rgb(8BA4B0)";

        resize_on_border = false;

        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
        };

        blur = {
          enabled = true;
          new_optimizations = true;
          passes = 1;
          vibrancy = 0.1696;
        };
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
        force_no_accel = true;
      };

      gestures = {
        gesture = "3, horizontal, workspace";
        workspace_swipe_invert = false;
        workspace_swipe_distance = 700;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
        new_on_top = true;
        mfact = 0.5;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
      };

      windowrulev2 = [
        # windows that should not be focused
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        # xwayland windows that should not be focused
        "opacity 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "noinitialfocus, class:^(xwaylandvideobridge)$"
        "maxsize 1 1, class:^(xwaylandvideobridge)$"
        "noblur, class:^(xwaylandvideobridge)$"
        "nofocus, class:^(xwaylandvideobridge)$"

        # opacity
        "opacity 0.97 0.9, class:.*"
        "opacity 1 1, class:^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$"
        # windows that should be floating
        "float, tag:floating-window"
        "center, tag:floating-window"
        "size 800 600, tag:floating-window"
        "tag +floating-window, class:^(org.pulseaudio.pavucontrol|.blueman-manager-wrapped|org.gnome.Nautilus)$"
      ];

      layerrule = [
        "noanim, walker"
      ];
    };
  };
}
