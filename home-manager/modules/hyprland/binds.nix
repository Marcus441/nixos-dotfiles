{pkgs, ...}: {
  home.packages = [];

  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mainMod,       Return, exec, walker"
      "$mainMod,       V, exec, walker -m clipboard"
      "$mainMod,       E, exec, $fileManager"
      "$mainMod,       Q, exec, $terminal"
      "$mainMod,       B, exec, $browser"
      "$mainMod,       A, exec, ${pkgs.chromium}/bin/chromium --app=https://chatgpt.com/"
      "$mainMod,       D, exec, vesktop --enable-blink-features=MiddleClickAutoscroll"
      "$mainMod,       T, exec, ${pkgs.chromium}/bin/chromium --app=https://teams.microsoft.com"
      "$mainMod,       G, exec, ${pkgs.chromium}/bin/chromium --app=https://github.com"
      "$mainMod,       Y, exec, ${pkgs.chromium}/bin/chromium --app=https://music.youtube.com/"
      "$mainMod,       C, exec, ${pkgs.chromium}/bin/chromium --app=https://calendar.google.com/"
      "$mainMod,       M, exec, ${pkgs.chromium}/bin/chromium --app=https://www.messenger.com/"
      "$mainMod,       W, killactive,"
      "$mainMod,       F, togglefloating,"
      "$mainMod SHIFT, C, exec, hyprpicker -an"
      "$mainMod,       S, togglesplit,"
      "$mainMod SHIFT, Z, exit,"
      "$mainMod,       Z, exec, loginctl lock-session"
      ",               Print, exec, grimblast --notify --freeze copysave area"

      # Moving focus
      "$mainMod, H, movefocus, l"
      "$mainMod, L, movefocus, r"
      "$mainMod, K, movefocus, u"
      "$mainMod, J, movefocus, d"

      # Moving windows
      "$mainMod SHIFT, H, swapwindow, l"
      "$mainMod SHIFT, L, swapwindow, r"
      "$mainMod SHIFT, K, swapwindow, u"
      "$mainMod SHIFT, J, swapwindow, d"

      # Switching workspaces
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"

      # Moving windows to workspaces
      "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, movetoworkspacesilent, 9"

      # Scratchpad
      "$mainMod,       0, togglespecialworkspace,  magic"
      "$mainMod SHIFT, 0, movetoworkspace, special:magic"
    ];

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # Laptop multimedia keys for volume and LCD brightness
    bindel = [
      ",XF86AudioRaiseVolume,  exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      "$mainMod, bracketright, exec, brightnessctl s 10%+"
      "$mainMod, bracketleft,  exec, brightnessctl s 10%-"
    ];

    # Audio playback
    bindl = [
      ", XF86AudioNext,  exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay,  exec, playerctl play-pause"
      ", XF86AudioPrev,  exec, playerctl previous"
    ];
  };
}
