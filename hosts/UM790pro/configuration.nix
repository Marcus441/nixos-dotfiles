{
  stateVersion,
  hostname,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../../nixos/modules
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
