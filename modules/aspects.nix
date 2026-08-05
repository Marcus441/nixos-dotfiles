{lib, ...}: {
  # Aspects are a flat list of modules. `deferredModule` over `raw` buys back
  # `_file`, so an option conflict names the files instead of reporting
  # `<unknown-file>` twice.
  options.flake.modules = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf (lib.types.listOf lib.types.deferredModule));
    default = {};
  };
}
