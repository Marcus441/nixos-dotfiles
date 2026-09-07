_: {
  flake.modules.homeManager.apps = [
    (
      {
        lib,
        pkgs,
        ...
      }: {
        home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [pkgs.kdePackages.kdenlive];
      }
    )
  ];
}
