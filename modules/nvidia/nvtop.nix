_: {
  flake.modules.homeManager.nvidia = [
    (
      {pkgs, ...}: {
        # load-bearing: docs/decisions/placement.md#unfree-home
        home.packages = [pkgs.nvtopPackages.nvidia];
      }
    )
  ];
}
