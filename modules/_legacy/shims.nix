{lib, ...}: {
  options.legacy = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = {};
  };

  config.legacy = {
    utilities = ../../utilities;
    homeEntry = ../../home-manager/home.nix;
  };
}
