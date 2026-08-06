{...}: {
  flake.modules.homeManager.apps = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          # Heavy GUI apps
          kdePackages.kdenlive

          # Document & Image Rendering (for Neovim/Snacks)
          ghostscript
          tectonic
        ];
      }
    )
  ];
}
