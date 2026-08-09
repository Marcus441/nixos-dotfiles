_: {
  flake.modules.homeManager.hyprland = [
    (
      {
        config,
        lib,
        ...
      }: {
        options.floatingWindow = {
          term = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = "floating-term";
            description = "app-id a terminal sets to open as a floating window.";
          };

          app = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = "floating-app";
            description = "app-id a GUI utility sets to open as a floating window.";
          };
        };

        # load-bearing: docs/decisions/sessions.md#floating-appid
        config.windowTags.floating-window = [
          "^(${config.floatingWindow.term})$"
          "^(${config.floatingWindow.app})$"
        ];
      }
    )
  ];
}
