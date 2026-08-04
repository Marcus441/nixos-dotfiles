{...}: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        # Font *definition* shared by every profile (consumed by ./foot.nix).
        # The font *packages* are profile business: suckless installs them in
        # home-manager/profiles/suckless/font.nix, maximal via stylix.nix.
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
