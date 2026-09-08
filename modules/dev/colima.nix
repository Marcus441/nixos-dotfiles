_: {
  flake.modules.homeManager.dev = [
    (
      {
        lib,
        pkgs,
        ...
      }: {
        home.packages = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [pkgs.colima];
      }
    )
  ];
}
