{lib, ...}: let
  monitor = lib.types.submodule ({config, ...}: {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Connector, as the kernel names it (`HDMI-A-1`). Required: wlr-randr and dwl understand nothing else.";
      };

      description = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "EDID string from `hyprctl monitors -j`. Survives replugging, unlike the connector. Hyprland-only.";
      };

      width = lib.mkOption {type = lib.types.ints.positive;};
      height = lib.mkOption {type = lib.types.ints.positive;};

      refresh = lib.mkOption {
        type = lib.types.numbers.positive;
        default = 60;
      };

      x = lib.mkOption {
        type = lib.types.int;
        default = 0;
      };

      y = lib.mkOption {
        type = lib.types.int;
        default = 0;
      };

      scale = lib.mkOption {
        type = lib.types.numbers.positive;
        default = 1;
      };

      mode = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "${toString config.width}x${toString config.height}@${toString config.refresh}";
      };
    };
  });
in {
  # The freeform escape hatch carries the rest of the host record -- hostname,
  # system, stateVersion, aspects, hardware, packages, nixos -- which is still
  # untyped. See issue #3 item 2.
  options.hosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      freeformType = lib.types.attrsOf lib.types.raw;

      options = {
        monitors = lib.mkOption {
          type = lib.types.listOf monitor;
          default = [];
        };

        # Pointer sensitivity is not a display property; it shared monitors.nix
        # only because that file was really a per-host input/output bag.
        input.sensitivity = lib.mkOption {
          type = lib.types.number;
          default = 0;
        };
      };
    });
    default = {};
  };
}
