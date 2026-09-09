_: {
  flake.modules.homeManager.mango = [
    ({pkgs, ...}: {home.packages = [pkgs.brightnessctl];})
  ];

  flake.modules.homeManager.laptop = [
    ({pkgs, ...}: {home.packages = [pkgs.brightnessctl];})
  ];
}
