{
  wayland.windowManager.hyprland.settings = {
    window_rule = [
      # Maximize suppression
      {
        name = "suppress-maximize";
        match = {class = ".*";};
        suppress_event = "maximize";
      }
      # Fix blank unclickable Xwayland components
      {
        name = "no-focus-empty-xwayland";
        match = {
          class = "^$";
          title = "^$";
          xwayland = true;
          float = true;
          fullscreen = false;
          pin = false;
        };
        no_focus = true;
      }
      # Xwaylandvideobridge
      {
        name = "xwvb";
        match = {class = "^(xwaylandvideobridge)$";};
        opacity = 0.0;
        no_anim = true;
        no_initial_focus = true;
        max_size = "1 1";
        no_blur = true;
        no_focus = true;
      }
      # Tag floating windows (by class & title targets)
      {
        name = "tag-floating-by-class";
        match = {class = "^(org.pulseaudio.pavucontrol|.blueman-manager-wrapped|thunar|Thunar|xdg-desktop-portal-gtk)$";};
        tag = "+floating-window";
      }
      {
        name = "tag-floating-by-title";
        match = {title = "^(ghostty-float)$";};
        tag = "+floating-window";
      }
      # Apply behaviors onto custom matching window tags
      {
        name = "floating-float";
        match = {tag = "floating-window";};
        float = true;
      }
      {
        name = "floating-center";
        match = {tag = "floating-window";};
        center = true;
      }
      {
        name = "floating-size";
        match = {tag = "floating-window";};
        size = "1200 600";
      }
      # Smart gaps (Zero constraints when single window matches tiled criteria)
      {
        name = "no-gaps-wtv1";
        match = {
          float = false;
          workspace = "w[tv1]";
        };
        border_size = 0;
        rounding = 0;
      }
      {
        name = "no-gaps-f1";
        match = {
          float = false;
          workspace = "f[1]";
        };
        border_size = 0;
        rounding = 0;
      }
    ];

    workspace_rule = [
      {
        workspace = "f[1]";
        gaps_out = 0;
        gaps_in = 0;
      }
      {
        workspace = "w[tv1]";
        gaps_out = 0;
        gaps_in = 0;
      }
    ];

    layer_rule = [
      {
        name = "no-anim-selection";
        match = {namespace = "selection";};
        no_anim = true;
      }
      {
        name = "no-anim-walker";
        match = {namespace = "walker";};
        no_anim = true;
      }
      {
        name = "blur-walker";
        match = {namespace = "walker";};
        blur = true;
        ignore_alpha = 0.3;
      }
    ];
  };
}
