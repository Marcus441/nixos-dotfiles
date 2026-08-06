_: {
  flake.modules.homeManager.apps = [
    (
      {pkgs, ...}: {
        programs.bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [batdiff batman batgrep];
        };
      }
    )
  ];
}
