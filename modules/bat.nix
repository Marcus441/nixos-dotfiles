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

          # Not bat's built-in `base16`: it renders through ANSI, so it would
          # carry whichever sixteen colours the terminal happened to hold, and
          # a pager reached through `less` is not always ours. The tmTheme is
          # hex, and sharing yazi's makes the same file highlight the same in
          # both.
          themes.kanagawa-dragon.src = config.desktop.syntaxTheme;
          config.theme = "kanagawa-dragon";
        };
      }
    )
  ];
}
