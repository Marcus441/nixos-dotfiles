{
  pkgs,
  lib,
  ...
}: let
  image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/o3/wallhaven-o32do5.jpg";
    hash = "sha256-a6stwKasoy6V6XpfqgclWiP7NSw/kAVShHkI+gx3vIE=";
  };
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
          path = "${image}";
        }
      ];
    };
  };
}
