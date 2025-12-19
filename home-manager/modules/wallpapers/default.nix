{pkgs, ...}: let
  wallpapersRepo = pkgs.fetchFromGitHub {
    owner = "D3Ext";
    repo = "aesthetic-wallpapers";
    rev = "e34f05935c5b768f4c016b0893924d18ec1dba61";
    hash = "sha256-yN+0g8mQKWB29miQjtQDYySJWTwb/MQ5x5dXgoBuTkY=";
    sparseCheckout = ["images/Nepal_5160x2160.png"];
  };
in {
  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = "${wallpapersRepo}/images/Nepal_5160x2160.png";
    };
  };
}
