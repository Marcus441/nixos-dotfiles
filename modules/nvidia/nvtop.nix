_: {
  flake.modules.nixos.nvidia = [
    (
      {pkgs, ...}: {
        # load-bearing: docs/decisions/placement.md#unfree-nixos
        environment.systemPackages = [pkgs.nvtopPackages.nvidia];
      }
    )
  ];
}
