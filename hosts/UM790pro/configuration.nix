{
  stateVersion,
  hostname,
  pkgs,
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
  networking.networkmanager.wifi.powersave = false;
  programs.nix-ld.enable = true;

  system.stateVersion = stateVersion;
  boot = {
    kernelParams = ["usbcore.autosuspend=-1"];
  };
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*", RUN+="${pkgs.iw}/bin/iw dev $name set power_save off"
  '';
}
