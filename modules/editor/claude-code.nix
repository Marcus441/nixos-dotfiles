_: {
  flake.modules.homeManager.apps = [
    (
      {pkgs, ...}: {
        # load-bearing: docs/decisions/placement.md#unfree-home
        home.packages = [pkgs.claude-code];
      }
    )
  ];
}
