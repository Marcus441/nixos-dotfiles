_: {
  flake.modules.homeManager.hyprland = [
    (
      {
        config,
        lib,
        ...
      }: {
        options.floatingWindow = {
          # load-bearing: docs/decisions/sessions.md#floating-gtk-id
          term = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = "term.floating";
            description = "app-id a terminal sets to open as a floating window. Dotted: ghostty parses it as a GTK application ID.";
          };

          app = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = "app.floating";
            description = "app-id a GUI utility sets to open as a floating window.";
          };
        };

        # load-bearing: docs/decisions/sessions.md#floating-appid
        config.windowTags.floating-window = [
          "^(${lib.escapeRegex config.floatingWindow.term})$"
          "^(${lib.escapeRegex config.floatingWindow.app})$"
        ];
      }
    )
  ];
}
