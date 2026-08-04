{lib, ...}: {
  options.legacy = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = {};
  };

  config.legacy = {
    nixosHost = hostname: ../../hosts/${hostname}/configuration.nix;
    hostFile = hostname: file: ../../hosts/${hostname}/${file};
    monitors = hostname: ../../hosts/${hostname}/monitors.nix;
    utilities = ../../utilities;
    homeEntry = ../../home-manager/home.nix;
  };
}
