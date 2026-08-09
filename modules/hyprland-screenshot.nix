_: {
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
