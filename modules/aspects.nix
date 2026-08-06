{lib, ...}: {
  # Aspects are a flat list of modules. `deferredModule` over `raw` buys back
  # `_file`, so an option conflict names the files instead of reporting
  # `<unknown-file>` twice.
  options.flake.modules = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf (lib.types.listOf lib.types.deferredModule));
    default = {};
  };

  # An aspect that reads another aspect's options only works for a host taking
  # both, and the failure is an eval error inside a guest module naming neither.
  # Declared by the file that creates the dependency rather than by a table
  # here, so it cannot drift from the code that needs it; the generator rejects
  # a host that leaves one unmet.
  options.aspectRequires = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.listOf lib.types.str);
    default = {};
  };
}
