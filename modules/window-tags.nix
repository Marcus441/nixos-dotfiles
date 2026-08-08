_: {
  # `core`, not `hyprland`: the file that installs an app describes its windows,
  # and that file must not acquire a dependency on a compositor to do it. A host
  # whose session reads nothing carries the value inertly.
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.windowTags = lib.mkOption {
          type = lib.types.attrsOf (lib.types.listOf lib.types.str);
          default = {};
          example = {floating-window = ["^(thunar|Thunar)$"];};
          description = "Window tag name -> the class regexes that carry it. The session renders the tagging rules; what a tag *means* stays with the session that reads it. The values are Hyprland `class` regexes, so a second session translates them rather than consuming them -- dwl matches app_id by substring, and its own `tags` are workspace bitmasks.";
        };
      }
    )
  ];
}
