{config, ...}: let
  top = config;
in {
  flake.modules.homeManager.hyprland = [
    (
      {
        monitors,
        hostname,
        ...
      }: {
        assertions = top.flake.lib.monitors.assertionsFor hostname monitors;

        wayland.windowManager.hyprland.settings.monitor = map top.flake.lib.monitors.toHyprland monitors;
      }
    )
  ];
}
