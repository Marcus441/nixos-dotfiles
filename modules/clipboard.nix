_: {
  flake.modules.homeManager.wayland = [
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
