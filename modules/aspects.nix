{lib, ...}: {
  options.flake.modules = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf (lib.types.listOf lib.types.deferredModule));
    default = {};
  };

  options.aspectRequires = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.listOf lib.types.str);
    default = {};
  };
}
