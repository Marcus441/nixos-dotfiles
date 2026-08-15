_: {
  flake.modules.nixos.gaming = [
    (
      {pkgs, ...}: {
        programs.steam = {
          # load-bearing: docs/decisions/gaming.md#proton-compat-path
          extraCompatPackages = [pkgs.proton-ge-bin];
          protontricks.enable = true;
        };

        # load-bearing: docs/decisions/gaming.md#ntsync-module
        boot.kernelModules = ["ntsync"];
      }
    )
  ];
}
