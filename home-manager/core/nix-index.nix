{inputs, ...}: {
  programs.nix-index = {
    enable = true;
    enableFishIntegration = false;
  };

  programs.nix-index-database.comma.enable = true;
}
