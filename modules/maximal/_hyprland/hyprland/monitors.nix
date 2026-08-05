{
  monitors,
  hostname,
  render,
  ...
}: {
  assertions = render.assertionsFor hostname monitors;

  wayland.windowManager.hyprland.settings.monitor = map render.toHyprland monitors;
}
