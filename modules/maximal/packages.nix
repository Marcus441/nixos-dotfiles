{...}: {
  flake.modules.homeManager.maximal = [
    (
      {pkgs, ...}: {
        # Maximal-only packages: heavy GUI apps and Hyprland-specific tooling.
        home.packages = with pkgs; [
          # Heavy GUI apps
          kdePackages.kdenlive

          # Document & Image Rendering (for Neovim/Snacks)
          ghostscript
          tectonic

          # Screenshots & picking (Hyprland-specific / used by the hyprland binds)
          grimblast
          hyprpicker
          (callPackage ../../home-manager/pkgs/ocr-copy.nix {})

          # Portals for GTK file choosers / settings
          xdg-desktop-portal-gtk
        ];
      }
    )
  ];
}
