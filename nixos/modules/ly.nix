{
  systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = {
    bigclock = "en";
    bigclock_12hr = true;
    vi_mode = true;
    hide_borders = true;
    bg = "0x00181616";
    fg = "0x007FB4CA";
    animation = "colormix";
  };
}
