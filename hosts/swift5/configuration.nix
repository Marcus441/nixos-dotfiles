{
  pkgs,
  stateVersion,
  hostname,
  profile,
  ...
}: {
  networking.hostName = hostname;

  system.stateVersion = stateVersion;

  networking.networkmanager.wifi.powersave = true;
}
