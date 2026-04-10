{
  systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
  services = {
    displayManager.ly.enable = true;
    displayManager.ly.settings = {
      bigclock = "en";
      bigclock_12hr = true;
      vi_mode = true;
      bg = "0x00181616";
      fg = "0x007FB4CA";
      session_log = null;
    };
  };
}
