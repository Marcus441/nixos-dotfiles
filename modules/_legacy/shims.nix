{lib, ...}: {
  options.legacy = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = {};
  };

  config.legacy = {
    nixosHost = hostname: ../../hosts/${hostname}/configuration.nix;
    nixosProfile = profile: ../../nixos/profiles/${profile};
    hostFile = hostname: file: ../../hosts/${hostname}/${file};
    monitors = hostname: ../../hosts/${hostname}/monitors.nix;
    utilities = ../../utilities;
    homeProfile = profile: ../../home-manager/profiles/${profile};
    homeEntry = ../../home-manager/home.nix;
  };
}
