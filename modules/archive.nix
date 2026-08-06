_: {
  flake.modules.homeManager.core = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          unzip
          zip
        ];
      }
    )
  ];
}
