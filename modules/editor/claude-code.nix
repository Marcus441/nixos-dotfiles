_: {
  flake.modules.nixos.apps = [
    (
      {pkgs, ...}: {
        # load-bearing: docs/decisions/placement.md#unfree-nixos
        environment.systemPackages = [pkgs.claude-code];
      }
    )
  ];
}
