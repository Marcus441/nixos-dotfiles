{pkgs, ...}: {
  programs = {
    xfconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };

  # Daemon mode: keeps a thunar instance resident so windows open instantly.
  # /run/current-system/sw/bin points at the plugin-wrapped thunar that
  # programs.thunar installs (referencing pkgs.xfce.thunar here would build a
  # second, unwrapped copy). graphical-session.target is activated by uwsm.
  systemd.user.services.thunar = {
    description = "Thunar file manager daemon";
    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/thunar --daemon";
      Restart = "on-failure";
      # uwsm's slice for session apps: the daemon owns every thunar window,
      # so it belongs where `uwsm app -- thunar` would put them.
      Slice = "app-graphical.slice";
    };
  };
}
