{...}: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        # Font *definition* shared by every host. The font *packages* are aspect
        # business: palette installs them directly, stylix via stylix.
        options.desktop.font = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "IosevkaTerm Nerd Font Mono";
            description = "Primary monospace font family.";
          };
          size = lib.mkOption {
            type = lib.types.int;
            default = 16;
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
