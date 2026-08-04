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

    # Only profiles still living in the legacy tree. A profile drops out of
    # these when it becomes an aspect; both go empty at 2.6.
    nixosProfiles = {
      maximal = ../../nixos/profiles/maximal;
    };
    homeProfiles = {
      maximal = ../../home-manager/profiles/maximal;
    };
    homeEntry = ../../home-manager/home.nix;
  };
}
