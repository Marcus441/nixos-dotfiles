_: {
  flake.modules.homeManager.core = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          man-pages
          man-pages-posix
        ];
      }
    )
  ];
}
