{
  pkgs,
  stateVersion,
  hostname,
  profile,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../../nixos/core
    ../../nixos/profiles/${profile}
  ];

  networking.hostName = hostname;

  system.stateVersion = stateVersion;

  networking.networkmanager.wifi.powersave = true;
}
