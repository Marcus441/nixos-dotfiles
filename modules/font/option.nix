{...}: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        # Font *definition* shared by every host (consumed by ./foot.nix).
        # The font *packages* are aspect business: ./packages.nix installs them
        # directly, ../stylix.nix via stylix.
        # Option namespace kept as `suckless.font` until its consumers move.
        options.suckless.font = {
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
