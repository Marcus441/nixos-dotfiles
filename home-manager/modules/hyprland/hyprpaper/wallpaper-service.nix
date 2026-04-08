{pkgs, ...}: let
  walls = import ./wallpapers.nix {inherit pkgs;};
in {
  systemd.user.services.wallpaper-rotator = {
    Unit = {
      Description = "Background wallpaper rotator for Hyprpaper";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
      # Systemd will silently skip starting this service if the file doesn't exist
      ConditionPathExists = "%h/.cache/wallpaper_rotator_enabled";
    };

    # Add this so it hooks into your login process
    Install = {
      WantedBy = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.writeShellScript "rotate" ''
        CACHE_FILE="$HOME/.cache/current_wallpaper.img"

        # Continuous random rotation loop
        while true; do
          WALL=$(${pkgs.fd}/bin/fd . ${walls} -e jpg -e png -e webp | ${pkgs.coreutils}/bin/shuf -n 1)

          if [ -n "$WALL" ]; then
            ln -sf "$WALL" "$CACHE_FILE"
            ${pkgs.hyprland}/bin/hyprctl hyprpaper preload "$WALL"
            ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper ",$WALL"
            ${pkgs.hyprland}/bin/hyprctl hyprpaper unload unused
          fi

          sleep 1800
        done
      ''}";
      Restart = "on-failure";
    };
  };
}
