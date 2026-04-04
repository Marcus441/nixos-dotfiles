{pkgs, ...}: let
  lwalpapers = pkgs.fetchFromGitHub {
    owner = "whoisYoges";
    repo = "lwalpapers";
    rev = "35d131f28ca64b3526b7e85e11a2e45332113f70";
    hash = "sha256-yOlGzctUlN+ymYNy9h1d+lnC2MsUrFSW8t2igmHIhy8=";
  };
in {
  systemd.user.services.wallpaper-rotator = {
    Unit = {
      Description = "Background wallpaper rotator for Hyprpaper";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "rotate" ''
        sleep 10
        while true; do
          WALL=$(${pkgs.fd}/bin/fd . ${lwalpapers} -e jpg -e png -e webp | ${pkgs.coreutils}/bin/shuf -n 1)
          if [ -n "$WALL" ]; then
            ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper ",$WALL"
          fi
          sleep 1800
        done
      ''}";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
