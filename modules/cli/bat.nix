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

          # load-bearing: docs/decisions/theming.md#bat
          themes.kanagawa-dragon.src = config.desktop.syntaxTheme;
          config.theme = "kanagawa-dragon";
        };
      }
    )
  ];
}
