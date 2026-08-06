{...}: {
  # Compositor-agnostic: both sessions bind a clipboard-history key.
  flake.modules.homeManager.core = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          wl-clipboard
          cliphist
        ];
      }
    )
  ];
}
