_: {
  flake.modules.homeManager.apps = [
    (
      {pkgs, ...}: {
        home.packages = [pkgs.claude-code];
      }
    )
  ];
}
