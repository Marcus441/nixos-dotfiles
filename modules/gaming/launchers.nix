_: {
  flake.modules.homeManager.gaming = [
    (
      {pkgs, ...}: {
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
