_: {
  flake.modules.homeManager.hyprland = [
    (
      {
        pkgs,
        config,
        ...
      }: let
        walls = import ./_wallpapers.nix {inherit pkgs;};
        wallDir = "${walls}/walled_tiers/4k/";
        defaultImage = "${wallDir}/mountain/a_castle_on_a_hill_with_fog_with_Eltz_Castle_in_the_background.jpg";
        currentWallpaper = "${config.xdg.cacheHome}/current_wallpaper.img";
      in {
        services.hyprpaper = {
          enable = true;
          settings = {
            ipc = true;
            splash = false;
            wallpaper = [
              {
                monitor = "";
                path = currentWallpaper;
                fit_mode = "cover";
              }
            ];
          };
        };

        home.activation.initWallpaper = ''
          if [ ! -e "${currentWallpaper}" ]; then
            mkdir -p "${config.xdg.cacheHome}"
            ln -sf "${defaultImage}" "${currentWallpaper}"
          fi
        '';
      }
    )
  ];
}
