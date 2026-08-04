{
  pkgs,
  lib,
  config,
  ...
}: {
  options.suckless.cursor = {
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
      name = config.suckless.cursor.name;
      package = config.suckless.cursor.package;
      size = config.suckless.cursor.size;
      gtk.enable = true;
      x11.enable = true;
    };

    home.sessionVariables = {
      XCURSOR_THEME = config.suckless.cursor.name;
      XCURSOR_SIZE = toString config.suckless.cursor.size;
    };
  };
}
