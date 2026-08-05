{lib, ...}: {
  # Aspects are a flat list of modules. Element type is `raw`, not
  # `deferredModule`: deferredModule rewrites each element's _file, which
  # becomes its module key and reorders module collection, which reorders
  # list-valued options. Consumers splice the list in at the depth the legacy
  # imports held.
  options.flake.modules = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf (lib.types.listOf lib.types.raw));
    default = {};
  };
}
