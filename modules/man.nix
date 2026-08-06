{...}: {
  # bash.nix colours the pager; these are the pages themselves.
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
