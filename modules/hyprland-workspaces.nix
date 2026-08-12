{
  config,
  lib,
  ...
}: let
  top = config;
  persistent = ["1" "2" "3" "4" "5"];
in {
  flake.modules.homeManager.hyprland = [
    (
      {monitors, ...}: {
        # load-bearing: docs/decisions/sessions.md#persistent-workspaces
        wayland.windowManager.hyprland.settings.workspace_rule =
          lib.optionals (monitors != []) (
            map (w: {
              workspace = w;
              monitor = top.flake.lib.monitors.identify (lib.head monitors);
              persistent = true;
            })
            persistent
          );
      }
    )
  ];

  flake.modules.homeManager.waybar = [
    {
      programs.waybar.settings.mainBar."hyprland/workspaces".persistent-workspaces =
        lib.genAttrs persistent (_: []);
    }
  ];
}
