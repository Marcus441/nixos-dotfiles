_: {
  flake.modules.homeManager.gaming = [
    (
      {pkgs, ...}: {
        # load-bearing: docs/decisions/placement.md#unfree-home
        home.packages = with pkgs; [
          lutris
          heroic
          bottles
          ludusavi
        ];
      }
    )
  ];
}
