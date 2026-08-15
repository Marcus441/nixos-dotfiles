_: {
  # load-bearing: docs/decisions/gaming.md#dualsense-no-driver
  flake.modules.homeManager.gaming = [
    ({pkgs, ...}: {home.packages = [pkgs.dualsensectl];})
  ];
}
