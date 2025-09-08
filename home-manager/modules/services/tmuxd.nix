{pkgs, ...}: {
  systemd.user.services.tmux-server = {
    Unit = {
      Description = "Tmux server";
      After = ["graphical.target"];
    };

    Service = {
      Type = "forking";
      ExecStart = "${pkgs.tmux}/bin/tmux start-server";
      ExecStop = "${pkgs.tmux}/bin/tmux kill-server";
      Restart = "always";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
