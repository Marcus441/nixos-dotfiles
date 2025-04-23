{ pkgs, stateVersion, hostname, config, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../../nixos/modules
  ];
  
  networking.hostName = hostname;
  
  hardware.graphics = {
     enable = true;
  };
  
  nixpkgs.config.allowUnfree = true; 

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

      modesetting.enable = true;

      powerManagement.enable = false;

      powerManagement.finegrained = false;

      open = false;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.latest;
  };


  system.stateVersion = stateVersion;
}

