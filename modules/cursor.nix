_: {
  flake.modules.homeManager.core = [
    (
      {
        pkgs,
        lib,
        config,
        ...
      }: {
        # The two theming regimes disagreed -- swift5 was DMZ-Black, the stylix
        # hosts Adwaita, both 24px. DMZ-Black wins the whole fleet: it is the
        # one a file in this repo chose, where Adwaita came with the generator.
        options.desktop.cursor = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "DMZ-Black";
            description = "Xcursor theme name.";
          };
          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.vanilla-dmz;
            description = "Package providing the cursor theme.";
          };
          size = lib.mkOption {
            type = lib.types.int;
            default = 24;
            description = "Cursor size, in pixels.";
          };
        };

        config = {
          home.pointerCursor = {
            enable = true;
            name = config.desktop.cursor.name;
            package = config.desktop.cursor.package;
            size = config.desktop.cursor.size;
            gtk.enable = true;
            x11.enable = true;
          };

          home.sessionVariables = {
            XCURSOR_THEME = config.desktop.cursor.name;
            XCURSOR_SIZE = toString config.desktop.cursor.size;
          };
        };
      }
    )
  ];
}
