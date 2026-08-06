{config, ...}: let
  # Surfaced files are flake-parts modules, so they reach flake.lib directly;
  # the _module.args.render bridge that stood in for this is gone.
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
