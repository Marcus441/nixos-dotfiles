{pkgs, ...}: {
  systemd.user.services.tmux-server = {
    Unit = {
      Description = "Tmux server";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "forking";
      ExecStart = "${pkgs.tmux}/bin/tmux start-server";
      ExecStop = "${pkgs.tmux}/bin/tmux kill-server";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
