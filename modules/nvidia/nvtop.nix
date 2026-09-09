_: {
  flake.modules.homeManager.nvidia = [
    (
      {pkgs, ...}: {
        home.packages = [pkgs.nvtopPackages.nvidia];
      }
    )
  ];
}
