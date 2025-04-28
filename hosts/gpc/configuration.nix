{ pkgs, stateVersion, hostname, config, lib, user, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../../nixos/modules
  ];
  
  networking.hostName = hostname;
  
  # nvidia stuff 
  hardware.graphics = {
     enable = true;
     enable32Bit = true;
  };
 
  nixpkgs.config.allowUnfree = true; 

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

      modesetting.enable = true;

      powerManagement.enable = false;

      powerManagement.finegrained = false;

      open = true;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # gaming stuff
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  programs.gamemode.enable = true;
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${user}/.steam/root/compatibilitytoolds.d";
  };
  system.stateVersion = stateVersion;
}

