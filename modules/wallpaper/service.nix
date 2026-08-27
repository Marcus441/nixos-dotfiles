_: {
  flake.modules.homeManager.hyprland = [
    (
      {
        pkgs,
        config,
        ...
      }: let
        walls = import ./_wallpapers.nix {inherit pkgs;};
      in {
        systemd.user.services.wallpaper-rotator = {
          Unit = {
            Description = "Background wallpaper rotator for Hyprpaper";
            After = ["wayland-session@hyprland.desktop.target"];
            PartOf = ["wayland-session@hyprland.desktop.target"];
            ConditionPathExists = "%C/wallpaper_rotator_enabled";
          };

          Install = {
            WantedBy = ["wayland-session@hyprland.desktop.target"];
          };

          Service = {
            ExecStart = "${pkgs.writeShellScript "rotate" ''
              CACHE_FILE="${config.xdg.cacheHome}/current_wallpaper.img"
              FLAG_FILE="${config.xdg.cacheHome}/wallpaper_rotator_enabled"

              while true; do
                CATEGORY=""
                [ -r "$FLAG_FILE" ] && CATEGORY=$(<"$FLAG_FILE")
                SCOPE="${walls}/walled_tiers/4k/$CATEGORY"
                { [ -n "$CATEGORY" ] && [ -d "$SCOPE" ]; } || SCOPE="${walls}"
                WALL=$(${pkgs.fd}/bin/fd . "$SCOPE" -e jpg -e png -e webp | ${pkgs.coreutils}/bin/shuf -n 1)

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
    )
  ];
}
