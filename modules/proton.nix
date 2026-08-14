_: {
  flake.modules.nixos.gaming = [
    (
      {pkgs, ...}: {
        programs.steam = {
          extraCompatPackages = [pkgs.proton-ge-bin];
          protontricks.enable = true;
        };
      }
    )
  ];
}
