_: {
  flake.modules.nixos.gaming = [
    (
      {pkgs, ...}: {
        # load-bearing: docs/decisions/placement.md#unfree-nixos
        environment.systemPackages = with pkgs; [
          lutris
          heroic
          bottles
          ludusavi
        ];
      }
    )
  ];
}
