_: {
  # Bound to keys in hyprland-binds.nix, so they follow the session rather than
  # the app set. dwl builds its own ocr-copy against its own keybind.
  flake.modules.homeManager.hyprland = [
    (
      {pkgs, ...}: {
        home.packages = [
          pkgs.grimblast
          pkgs.hyprpicker
          (pkgs.callPackage ./_pkgs/ocr-copy.nix {})
        ];
      }
    )
  ];
}
