{
  pkgs,
  config,
  ...
}: let
  walls = import ./wallpapers.nix {inherit pkgs;};
  wallDir = "${walls}/walled_tiers/4k/";
  defaultImage = "${wallDir}/mountain/a_castle_on_a_hill_with_fog_with_Eltz_Castle_in_the_background.jpg";
  currentWallpaper = "${config.home.homeDirectory}/.cache/current_wallpaper.img";
in {
  imports = [
    ./wallpaper-picker.nix
    ./wallpaper-service.nix
  ];
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
    if [ ! -e "$HOME/.cache/current_wallpaper.img" ]; then
      mkdir -p "$HOME/.cache"
      ln -sf "${defaultImage}" "$HOME/.cache/current_wallpaper.img"
    fi
  '';
}
