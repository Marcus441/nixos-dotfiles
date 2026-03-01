{
  stateVersion,
  hostname,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../../nixos/modules
  ];

  networking.hostName = hostname;

  programs.nix-ld.enable = true;

  system.stateVersion = stateVersion;
  boot = {
    kernelParams = ["usbcore.autosuspend=-1"];
  };
}
