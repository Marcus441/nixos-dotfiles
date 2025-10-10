{
  systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = {
    animation = "colormix";
    bigclock = "en";
    bigclock_12hr = true;
    vi_mode = true;
  };
}
