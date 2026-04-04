{pkgs, ...}: let
  walls = pkgs.fetchFromGitHub {
    owner = "dharmx";
    repo = "walls";
    rev = "6bf4d733ebf2b484a37c17d742eb47e5139e6a14";
    hash = "sha256-M96jJy3L0a+VkJ+DcbtrRAquwDWaIG9hAUxenr/TcQU=";
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
          WALL=$(${pkgs.fd}/bin/fd . ${walls} -e jpg -e png -e webp -E anime | ${pkgs.coreutils}/bin/shuf -n 1)
          if [ -n "$WALL" ]; then
            ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper ",$WALL"
          fi
          sleep 1800
        done
      ''}";
      Restart = "on-failure";
    };
  };
}
