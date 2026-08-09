_: {
  # Setting `theme` at all overrides `services.walker.settings.theme` with its
  # name, so the launcher file names no theme.
  flake.modules.homeManager.hyprland = [
    (
      {
        config,
        lib,
        ...
      }: {
        services.walker.theme = {
          name = "custom";
          style = import ./_walker/style.nix {
            colors = lib.mapAttrs (_: lib.removePrefix "#") config.desktop.colors;
            font = config.desktop.font.name;
          };
          layout = {
            "layout" = import ./_walker/layout.nix;
            "item_calc" = import ./_walker/item_calc.nix;
            "item_menus-wallpapers" = import ./_walker/item_menus_wallpapers.nix;
          };
        };
      }
    )
  ];
}
