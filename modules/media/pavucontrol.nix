_: {
  flake.modules.homeManager.wayland = [
    (
      {pkgs, ...}: {
        home.packages = [pkgs.pavucontrol];
      }
    )
  ];
}
