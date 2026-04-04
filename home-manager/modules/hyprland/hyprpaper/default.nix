{pkgs, ...}: let
  walls = import ./wallpapers.nix {inherit pkgs;};
  defaultImage = "${walls}/mountain/a_castle_on_a_hill_with_fog_with_Eltz_Castle_in_the_background.jpg";
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
      preload = [
        "${defaultImage}"
        "~/.cache/current_wallpaper.img"
      ];
      wallpaper = [
        {
          monitor = "";
          path = "~/.cache/current_wallpaper.img";
        }
      ];
    };
  };

  home.activation.initWallpaper = ''
    if [ ! -f "$HOME/.cache/current_wallpaper.img" ]; then
      mkdir -p "$HOME/.cache"
      ln -sf "${defaultImage}" "$HOME/.cache/current_wallpaper.img"
    fi
  '';
}
