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
  # load-bearing: docs/decisions/wiring.md#record-strict
  host = lib.types.submodule {
    options = {
      hostname = lib.mkOption {
        type = lib.types.str;
        description = "Must equal the attribute name; the generator rejects a disagreement.";
      };

      system = lib.mkOption {type = lib.types.str;};

      stateVersion = lib.mkOption {
        type = lib.types.str;
        description = "The NixOS release this machine was installed at. Never bumped to follow nixpkgs.";
      };

      aspects = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Order is load-bearing: it sets merge order, which reaches derivation hashes. AGENTS.md §5.";
      };

      hardware = lib.mkOption {
        type = lib.types.path;
        description = "Machine-generated hardware-configuration.nix. Never edited, not regenerable without the machine.";
      };

      fontSize = lib.mkOption {type = lib.types.ints.positive;};

      monitors = lib.mkOption {
        type = lib.types.listOf monitor;
        default = [];
      };

      input.sensitivity = lib.mkOption {
        type = lib.types.number;
        default = 0;
      };

      bar.position = lib.mkOption {
        type = lib.types.enum ["top" "bottom" "left" "right"];
        default = "top";
        description = "Edge of the screen the bar occupies, for hosts whose aspects provide one.";
      };

      packages = lib.mkOption {
        type = lib.types.deferredModule;
        default = {};
        description = "Machine-specific system packages that no aspect owns.";
      };

      # load-bearing: docs/decisions/wiring.md#record-nixos
      nixos = lib.mkOption {
        type = lib.types.deferredModule;
        description = "Machine facts with nowhere else to sit -- hostname, stateVersion, quirks of this box.";
      };
    };
  };
in {
  options.hosts = lib.mkOption {
    type = lib.types.attrsOf host;
    default = {};
  };
}
