{ pkgs, ... }:

{
  home.packages = [  ];

  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mainMod Return, exec, $terminal"
      "$mainMod SHIFT, C, killactive,"
      "$mainMod SHIFT, Z, exit,"
      "$mainMod SHIFT, F, exec, $fileManager"
      "$mainMod,       F, togglefloating,"
      "$mainMod SHIFT, N, exec, $menu --show drun"
      "$mainMod,       C, pin,"
      "$mainMod,       A, togglesplit,"
      "$mainMod,       M, exec, bemoji -cn"
      "$mainMod,       V, exec, cliphist list | $menu --dmenu | cliphist decode | wl-copy"
      "$mainMod,       B, exec, pkill -SIGUSR2 waybar"
      "$mainMod SHIFT, B, exec, pkill -SIGUSR1 waybar"
      "$mainMod,       Z, exec, loginctl lock-session"
      "$mainMod,       C, exec, hyprpicker -an"
      "$mainMod,       N, exec, swaync-client -t"
      ", Print, exec, grimblast --notify --freeze copysave area"

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

      # Resizeing windows               X  Y
      "$mainMod CTRL, H, resizeactive, -60 0"
      "$mainMod CTRL, L, resizeactive,  60 0"
      "$mainMod CTRL, K, resizeactive,  0 -60"
      "$mainMod CTRL, J, resizeactive,  0  60"

      # Switching workspaces
      "$mainMod, Q, workspace, 1"
      "$mainMod, W, workspace, 2"
      "$mainMod, E, workspace, 3"
      "$mainMod, R, workspace, 4"
      "$mainMod, T, workspace, 5"
      "$mainMod, Y, workspace, 6"
      "$mainMod, U, workspace, 7"
      "$mainMod, I, workspace, 8"
      "$mainMod, O, workspace, 9"
      "$mainMod, P, workspace, 10"

      # Moving windows to workspaces
      "$mainMod SHIFT, Q, movetoworkspacesilent, 1"
      "$mainMod SHIFT, W, movetoworkspacesilent, 2"
      "$mainMod SHIFT, E, movetoworkspacesilent, 3"
      "$mainMod SHIFT, R, movetoworkspacesilent, 4"
      "$mainMod SHIFT, T, movetoworkspacesilent, 5"
      "$mainMod SHIFT, Y, movetoworkspacesilent, 6"
      "$mainMod SHIFT, U, movetoworkspacesilent, 7"
      "$mainMod SHIFT, I, movetoworkspacesilent, 8"
      "$mainMod SHIFT, O, movetoworkspacesilent, 9"
      "$mainMod SHIFT, P, movetoworkspacesilent, 10"

      # Scratchpad
      "$mainMod,       S, togglespecialworkspace,  magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"
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
