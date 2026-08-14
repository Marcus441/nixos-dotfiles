_: {
  flake.modules.nixos.gaming = [
    (
      {pkgs, ...}: {
        programs.steam = {
          extraCompatPackages = [pkgs.proton-ge-bin];
          protontricks.enable = true;
        };

        # load-bearing: docs/decisions/gaming.md#ntsync-module
        boot.kernelModules = ["ntsync"];
      }
    )
  ];
}
