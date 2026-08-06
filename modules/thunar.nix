{...}: {
  flake.modules.nixos.apps = [
    (
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

        # Daemon mode: keep a thunar instance resident so windows open instantly.
        #
        # thunar ships its own `thunar.service` (Type=dbus, ExecStart=Thunar
        # --daemon), which systemd starts on demand when something asks for
        # org.xfce.FileManager. It has no [Install] section, so it only ever starts
        # lazily -- the first window still pays the startup cost. This override adds
        # the missing install wiring so the daemon comes up with the graphical
        # session instead.
        #
        # Deliberately no ExecStart here: NixOS merges this as a drop-in over the
        # packaged unit, and a second ExecStart on a non-oneshot service makes
        # systemd refuse to load it ("more than one ExecStart= setting").
        systemd.user.services.thunar = {
          partOf = ["graphical-session.target"];
          after = ["graphical-session.target"];
          wantedBy = ["graphical-session.target"];
          # uwsm's slice for session apps: the daemon owns every thunar window, so
          # it belongs where `uwsm app -- thunar` would have put them.
          serviceConfig.Slice = "app-graphical.slice";
        };
      }
    )
  ];
}
