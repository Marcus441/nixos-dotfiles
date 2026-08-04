{pkgs, ...}: let
  walls = import ./wallpapers.nix {inherit pkgs;};
in {
  systemd.user.services.wallpaper-rotator = {
    Unit = {
      Description = "Background wallpaper rotator for Hyprpaper";
      After = ["wayland-session@hyprland.desktop.target"];
      PartOf = ["wayland-session@hyprland.desktop.target"];
      ConditionPathExists = "%h/.cache/wallpaper_rotator_enabled";
    };

    Install = {
      WantedBy = ["wayland-session@hyprland.desktop.target"];
    };

    Service = {
      ExecStart = "${pkgs.writeShellScript "rotate" ''
        CACHE_FILE="$HOME/.cache/current_wallpaper.img"

        while true; do
          WALL=$(${pkgs.fd}/bin/fd . ${walls} -e jpg -e png -e webp | ${pkgs.coreutils}/bin/shuf -n 1)

          if [ -n "$WALL" ]; then
            ln -sf "$WALL" "$CACHE_FILE"
            ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper ",$WALL"
          fi

          sleep 1800
        done
      ''}";
      Restart = "on-failure";
    };
  };
}
