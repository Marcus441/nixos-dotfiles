{pkgs, ...}: let
  default = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/3l/wallhaven-3lj5r6.png";
    sha256 = "sha256-12REUbhvnOoBd7kppaAyKkD2ViazPOKiBeUW/lMmkvQ=";
  };
in {
  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = default;
    };
  };
}
