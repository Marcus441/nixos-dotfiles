{...}: {
  # Two audiences, and neither is `core`: the Hyprland binds and hypridle call
  # it by bare name, so it must be on PATH wherever that session runs; on a
  # laptop it is a tool the user reaches for directly. dwl needs neither entry
  # -- it interpolates the store path into its compiled config.
  flake.modules.homeManager.hyprland = [
    ({pkgs, ...}: {home.packages = [pkgs.brightnessctl];})
  ];

  flake.modules.homeManager.laptop = [
    ({pkgs, ...}: {home.packages = [pkgs.brightnessctl];})
  ];
}
