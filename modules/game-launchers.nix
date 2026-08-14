_: {
  flake.modules.nixos.gaming = [
    (
      {pkgs, ...}: {
        # load-bearing: docs/decisions/placement.md#launchers-nixos
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
