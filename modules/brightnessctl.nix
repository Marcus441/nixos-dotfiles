_: {
  flake.modules.homeManager.hyprland = [
    ({pkgs, ...}: {home.packages = [pkgs.brightnessctl];})
  ];

  flake.modules.homeManager.laptop = [
    ({pkgs, ...}: {home.packages = [pkgs.brightnessctl];})
  ];
}
