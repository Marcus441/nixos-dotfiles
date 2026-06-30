{
  # Neutral, compositor-agnostic monitor description.
  # Consumers (hyprland, dwl/wlr-randr, hyprlock, ...) translate these fields
  # into their own config format -- see e.g.
  #   home-manager/profiles/maximal/hyprland/hyprland/monitors.nix
  #   home-manager/profiles/suckless/monitors.nix
  makeMonitor = name: width: height: refresh: x: y: scale: {
    inherit name width height refresh x y scale;
  };
}
