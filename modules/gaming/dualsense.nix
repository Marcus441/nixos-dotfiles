_: {
  flake.modules.homeManager.gaming = [
    ({pkgs, ...}: {home.packages = [pkgs.dualsensectl];})
  ];
}
