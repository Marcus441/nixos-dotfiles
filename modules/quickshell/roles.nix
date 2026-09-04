_: {
  flake.modules.homeManager.quickshell = [
    (
      {
        config,
        lib,
        ...
      }: {
        # load-bearing: docs/conventions/colour.md#shell-roles
        options.desktop.roles = lib.mkOption {
          type = lib.types.attrsOf (lib.types.strMatching "#([0-9a-fA-F]{6}|[0-9a-fA-F]{8})");
          default = with config.desktop.colors; {
            accent = base0D;
            card = base10;
            chrome = base01;
            scrim = "#66000000";
            selection = base02;
            textMuted = base03;
            textPrimary = base05;
            textSecondary = base04;
          };
          description = "What each palette slot means to the shell, so a QML file names the role and not the slot. Qt reads eight hex digits as `#aarrggbb`.";
        };
      }
    )
  ];
}
