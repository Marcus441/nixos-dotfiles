{
  programs.steam.enable = true;

  # Optional: Enable Proton-GE for better compatibility (you'll need to download Proton GE yourself)
  programs.steam.override = {
    steamConfig = {
      "Proton" = "Proton-GE";
    };
  };
}
