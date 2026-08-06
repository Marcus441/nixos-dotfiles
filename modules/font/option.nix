{...}: {
  flake.modules.homeManager.core = [
    (
      {
        lib,
        fontSize,
        ...
      }: {
        # Font *definition* shared by every host. The font *packages* are aspect
        # business: palette installs them directly, stylix via stylix.
        options.desktop.font = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "IosevkaTerm Nerd Font Mono";
            description = "Primary monospace font family.";
          };
          # Point size is a property of the panel, not of the theme, so it
          # arrives from the host record rather than from an aspect.
          size = lib.mkOption {
            type = lib.types.int;
            default = fontSize;
            description = "Default font size, in points.";
          };
          ligatures = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to enable programming ligatures.";
          };
        };
      }
    )
  ];
}
