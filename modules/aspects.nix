{lib, ...}: {
  # load-bearing: docs/decisions/wiring.md#aspects-deferred
  options.flake.modules = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf (lib.types.listOf lib.types.deferredModule));
    default = {};
  };

  # load-bearing: docs/decisions/wiring.md#aspects-requires
  options.aspectRequires = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.listOf lib.types.str);
    default = {};
  };
}
