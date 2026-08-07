_: {
  flake.modules.homeManager.apps = [
    (
      {
        config,
        pkgs,
        ...
      }: {
        programs.bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [batdiff batman batgrep];

          # Not bat's built-in `base16`: it renders through ANSI, and foot's
          # base24 mapping puts base12 in slot 9 where base16 expects base09, so
          # numbers came out bright red. Sharing yazi's tmTheme fixes that and
          # makes the same file highlight the same in both.
          themes.kanagawa-dragon.src = config.desktop.syntaxTheme;
          config.theme = "kanagawa-dragon";
        };
      }
    )
  ];
}
