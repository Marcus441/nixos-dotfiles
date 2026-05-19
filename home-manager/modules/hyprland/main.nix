{
  monitors,
  user,
  sensitivity,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };
}
