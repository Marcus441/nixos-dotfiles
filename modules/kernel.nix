{...}: {
  flake.modules.nixos.core = [
    (
      {pkgs, ...}: {
        boot = {
          kernelPackages = pkgs.linuxPackages_latest;
        };
      }
    )
  ];
}
