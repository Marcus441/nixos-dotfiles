_: {
  flake.modules.homeManager.apps = [
    (
      {pkgs, ...}: {
        programs.bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [batdiff batman batgrep];

          # bat's built-in base16 renders through ANSI 0-15, and foot sets those
          # from desktop.colors -- so highlighting follows the palette without a
          # generated tmTheme, and follows the terminal if the palette changes.
          config.theme = "base16";
        };
      }
    )
  ];
}
